---
title: "AWS ECSを使った普通の開発・デプロイフロー"
date: 2018-03-14T09:34:04+09:00
tags:
- AWS
- ECS
- Docker
---

ECSを使った開発・デプロイの基本的なやり方。

<!--more-->

本番環境でコンテナを使う時、実際なにかしらのコンテナオーケストレーションツールが必要になる。
プリミティブにdocker-compose on EC2でも別にいいんだけど、AWS使ってるなら、シンプルにコンテナを管理できるECSが
(少なくとも今は)いいと思う。

## 前提

* 開発環境・ステージング環境(stg)・本番環境(prd)が存在
* Railsを想定し、すべての環境で同じコンテナを使う(Goとかだと話が変わってくる。後述。)
* Railsコンテナとnginxコンテナが存在
* ベースイメージは、ECRで管理する(重要)

## 開発フロー

開発フローを示す。
開発環境構築 -> stg/prd構築 -> 開発 -> デプロイの流れで書いていく。

### 開発環境構築

* Dockerfileを書く

まずはDockerfileの設計を行う。
Railsでは、stg/prdのみアセットプリコンパイルしたい、みたいな要件があると思うので、
開発環境とstg/prd環境のDockerfileを同じものを使うのはあんまよくない。

しかし、Dockerfileを分けるにしても、ほとんどの部分はかぶるはず(Rubyのバージョンとか)なので、
こういうときは `Dockerfile.base` を作る。

Dockerfile.base

```
FROM ubuntu:16.04

# install tools
RUN apt-get update && apt-get clean && \
    apt-get install -y --no-install-recommends build-essential \
    libssl-dev libreadline-dev make mysql-client libmysqld-dev \
    rm -rf /var/lib/apt/lists/*

# install ruby-build
RUN git clone https://github.com/rbenv/ruby-build.git /tmp/ruby-build && \
    cd /tmp/ruby-build && \
    ./install.sh && \
    cd / && \
    rm -rf /tmp/ruby-build

WORKDIR /app

# Install ruby & base gems
RUN CONFIGURE_OPTS="--disable-install-doc" ruby-build -v 2.5 /usr/local && \
    gem install bundler rubygems-bundler --no-rdoc --no-ri && \
    gem regenerate_binstubs && \
    gem update --system && \
    gem update bundler && \
    rm -rf /tmp/ruby-build*

# use bundle container & set RAILS_ENV
ENV BUNDLE_GEMFILE=/app/Gemfile \
    BUNDLE_JOBS=2 \
    BUNDLE_PATH=/bundle \
    RAILS_ENV=development

# bundle
ADD Gemfile* /app/
RUN bundle install --retry 5
```

雰囲気としてはこんな感じになる。開発環境とstg/prdで揃ってなきゃいけない部分をbaseに書いていく。
そして、これをAWS ECRにプッシュする。
ECRはAWSマネージドのDockerHubみたいなもの。

ECRへのプッシュは以下のようなシェルスクリプトで行う。

```
#!/bin/bash

ECR_REPO=#ECRのリポジトリのARNを書く

# ECR ログイン
$(aws ecr get-login --no-include-email --region ap-northeast-1)

LOGIN_RETURN_CD=$?

if [ $LOGIN_RETURN_CD -ne 0 ]; then
  echo "ECR login failed."
  echo "Please check your aws credentials and try again."
  echo "RETURN_CD: ${LOGIN_RETURN_CD}"
  exit ${LOGIN_RETURN_CD}
fi

docker build -t app -f Dockerfile.base .
RETURN_CD=$?

if [ $RETURN_CD -ne 0 ]; then
	echo "RETURN_CD: ${RETURN_CD}"
	exit ${RETURN_CD}
else
	echo ""
	echo "docker build done."
	echo ""
	echo "pushing image to DockerHub."
	docker tag app:latest ${ECR_REPO}:base
	docker push ${ECR_REPO}:base
	echo ""
	echo "docker push done."
fi
```

読めばわかるけど、これはAWS CLI経由でECRログインしているので、事前に `aws configure` を叩いておく必要がある。
また、Dockerfile.baseを基にイメージをビルドしているのがわかると思う。
これにより、baseイメージをECRで一元管理することができる。
baseイメージをECRで一元管理できると、開発環境とstg/prdの差異を別のDockerfileに分割する時にDRYにできる。

開発環境用のDockerfileはこんな感じ。

```
FROM ECRのイメージのARN

# bundle
ADD Gemfile* /app/
RUN bundle install --retry 5

ADD . /app/


EXPOSE 3000
CMD ["/app/scripts/start-server.sh"]
```

最後に、開発環境用のdocker-compose.ymlを書いておく。

```
version: '2.2'
services:
  db:
    environment:
      - MYSQL_ROOT_PASSWORD=docker
      - MYSQL_PASSWORD=docker
      - MYSQL_USER=docker
      - MYSQL_DATABASE=dbname_development
    build: ./docker/mysql

  redis:
    image: redis:4.0.6

  app:
    build: .
    command: '/app/scripts/start-server.sh'
    volumes:
      - .:/app
    ports:
      - "3000:3000"
    links:
      - db
      - redis
    environment:
      - RAILS_DATABASE_USERNAME=root
      - RAILS_DATABASE_PASSWORD=docker
      - RAILS_DATABASE_NAME=dbname_development
      - RAILS_DATABASE_HOST=db
      - REDIS_HOST=redis
      - REDIS_PORT=6379
    env_file:
      - .env

  nginx:
    build: ./docker/nginx
    command: nginx -g "daemon off;"
    links:
      - app
    ports:
      - "80:80"
```

これで、

```
$ docker-compose build
```

を叩く。
app(Rails)コンテナは、./Dockerfileを見ており、DockerfileはECRのベースイメージを見る。
あとは、CIからデプロイする時にもbaseイメージを使ってECRにプッシュするようにすればOK。

開発者がDockerfileを編集したくなったら(ミドルウェア追加など)、Dockerfile.baseを編集し、ローカルでECRにプッシュするシェルスクリプトを叩いてもらう必要がある。
もしやらないと、ローカルのイメージとstg/prdのイメージに差異が発生してしまう。
この辺のいいやり方がまだわかってなくて、理想はCIで、Dockerfile.baseが変更されたら自動でECRにプッシュしたい。
しかし、Dockerfileの変更が検知できるのかわからない(checksumとかでできるのかな、、)のと、
ECRへのプッシュがけっこう時間がかかるため、実現できていない。
いずれにせよ、READMEで開発者への周知が必要。

とはいえ、ここまでやれば、各自の開発環境のイメージが、ECRのベースイメージを見るようにできた。
次にデプロイメントについて書いていく。

### デプロイ

さっきも書いたように、stg/prdではアセットプリコンパイルしたいので、
Dockerfileをそのまま使えない。なので、Dockerfile.deployを作り、あくまでFROMにはECRのベースイメージを指定する。

```
FROM ECRのイメージのARN

# bundle
ADD Gemfile* /app/
RUN bundle install --retry 5

ADD . /app/

RUN /bin/bash -c "set -a && \
    source .env && \
    rm -rf /app/tmp/cache/webpacker/* && \
    rm -rf /app/public/assets/* && \
    rm -rf /app/public/packs/* && \
    bundle exec rake assets:precompile"

EXPOSE 3000
CMD ["/app/scripts/start-server.sh"]
```

こんな感じ。これをCIからいい感じにやっていく。

CircleCIの設定はこんな感じ。

.circleci/config.yml

```
defaults: &defaults
    working_directory: ~/app
    docker:
      - image: # ECRのARN
        aws_auth:
            aws_access_key_id: $AWS_ACCESS_KEY_ID
            aws_secret_access_key: $AWS_SECRET_ACCESS_KEY
        environment:
          TZ: /usr/share/zoneinfo/Asia/Tokyo
          RAILS_ENV: test
          RAILS_DATABASE_USERNAME: root
          RAILS_DATABASE_PASSWORD: docker
          RAILS_DATABASE_NAME: dbname_test
          RAILS_DATABASE_HOST: 127.0.0.1
          NODE_PATH: ./
      - image: circleci/mysql:5.7.20
        environment:
          TZ: /usr/share/zoneinfo/Asia/Tokyo
          MYSQL_ROOT_PASSWORD: docker
          MYSQL_PASSWORD: docker
          MYSQL_USER: rails
          MYSQL_DATABASE: dbname_test
      - image: circleci/node:8.9.1
version: 2
jobs:
  build:
    <<: *defaults
    steps:
      - checkout
      - setup_remote_docker:
          reusable: true
      - restore_cache:
          name: restore bundle cache
          key: gemfile-{{ checksum "Gemfile.lock" }}
      - run:
          name: bundle install
          command: bundle install --jobs=4 --path=vendor/bundle
      - save_cache:
          name: save bundle cache
          key: gemfile-{{ checksum "Gemfile.lock" }}
          paths:
              - vendor/bundle
      - run:
          name: rubocopとか、マイグレーションとか、やりたいことやる
          command: bundle exec rubocop --rails
      - run:
          name: run test
          command: |
            circleci tests glob 'spec/**/*_spec.*' \
              | circleci tests split --split-by=timings --timings-type=filename \
              | tee -a /dev/stderr \
              | xargs bundle exec rspec \
              --profile 100 \
              --format progress
      - persist_to_workspace:
          root: ~/app
          paths:
              - ./*

  deploy:
    working_directory: ~/app
    docker:
      - image: docker:17.09-git
    steps:
      - attach_workspace:
          at: ~/app
      - setup_remote_docker
      - run:
          name: install python, pip, awscli, jq
          command: |
            apk add --update python \
            jq \
            python-dev \
            py-pip \
            build-base \
            gcc \
            abuild \
            binutils \
            binutils-doc \
            gcc-doc \
            bash \
            && pip install --no-cache-dir awscli
      - run:
          name: build docker image
          command: ./scripts/circleci_build.sh
      - run:
          name: deployment
          command: ./scripts/circleci_ecs.sh
workflows:
  version: 2
  build_and_test:
    jobs:
      - build
      - deploy:
          requires:
            - build
          filters:
            branches:
              only:
                - master
                - release
```

こんな感じになる。
`workflows` の通り、 `build` は毎回(どのブランチにプッシュした際も)行われる。(自動テスト)
`deploy` は、ブランチがmaster/releaseのときのみ実行される。(この辺は各自のフローに従う)

buildはテストとかしてるだけなので置いといて、deployを見ていく。
pipとか入れたあと、
`build docker image` -> `deployment` と進んでいく。

#### build docker image

以下のようなシェルスクリプトでやっていく。

```
#!/bin/bash
echo "********************************"
echo "Building Docker container: app"
echo "********************************"

$(aws ecr get-login --no-include-email --region ap-northeast-1)

if [ ${CIRCLE_BRANCH} == "master" ]; then
  echo RAILS_ENV=staging >> .env
  env | grep STG_ >> .env
elif [ ${CIRCLE_BRANCH} == "release" ]; then
  echo RAILS_ENV=production >> .env
  env | grep PRD_ >> .env
fi

docker build --no-cache -t app . -f Dockerfile.deploy
RETURNCD=$?
if [ ${RETURNCD} -ne 0 ]; then
  echo
  echo "docker build FAILED"
  echo
  exit ${RETURNCD}
fi

echo "app build done."

echo "circleci_build.sh done."
exit 0
```

RAILS_ENVなど設定したあと、
前述のDockerfile.deployを基にイメージをビルドする。
このフローは `workflow` で、デプロイ時にのみ走るよう調整する必要がある。

ビルドしたら、実際デプロイする。
デプロイ用のシェルスクリプトはこんな感じ。

```
#!/bin/bash

ECR_REPO=ECRのARN
PROJECT_PREFIX=PREFIX

APPNAME=xxxapp
STG_TAG=stg-latest
PRD_TAG=latest

docker tag app ${ECR_REPO}/${APPNAME}:${PROJECT_PREFIX}-${CIRCLE_SHA1}
docker push ${ECR_REPO}/${APPNAME}:${PROJECT_PREFIX}-${CIRCLE_SHA1}

if [ ${CIRCLE_BRANCH} == "master" ]; then
  docker tag app ${ECR_REPO}/${APPNAME}:${STG_TAG}
  docker push ${ECR_REPO}/${APPNAME}:${STG_TAG}
  echo "STAGING build done and running ecsdeploy..."
  ./scripts/ecs-deploy --profile default --timeout $ECS_TIMEOUT -c $STG_ECS_CLUSTER -n $STG_ECS_SERVICE -i ${ECR_REPO}/${APPNAME}:${PROJECT_PREFIX}-${CIRCLE_SHA1}
elif [ ${CIRCLE_BRANCH} == "release" ]; then
  docker tag app ${ECR_REPO}/${APPNAME}:${PRD_TAG}
  docker push ${ECR_REPO}/${APPNAME}:${PRD_TAG}
  echo "PRODUCTION build done and running ecsdeploy..."
  ./scripts/ecs-deploy --profile default --timeout $ECS_TIMEOUT -c $PRD_ECS_CLUSTER -n $PRD_ECS_SERVICE -i ${ECR_REPO}/${APPNAME}:${PROJECT_PREFIX}-${CIRCLE_SHA1}
fi

RETURNCD=$?
if [ ${RETURNCD} -ne 0 ]; then
  echo
  echo "ECS DEPLOY FAILED"
  echo
  exit ${RETURNCD}
fi

exit 0
```

`*_ECS_CLUSTER` とかの環境変数は、circleci側で持っている。この辺は好みでOK。プロジェクトの設定画面から `env-vars` のパーマリンクがあるはず。

中で実際叩いている `ecs-deploy` は便利なのがあって、[これ](https://github.com/silinternational/ecs-deploy)を使っている。

これで、対象のブランチがプッシュされたら、CI経由でECRのbaseを基にイメージビルド -> ECSにデプロイができるようになった。

### Goとかの場合

Railsだと、実行環境にrubyが必要だし、こんな大げさになったけど、Goだとけっこう簡略化できる。
疲れたので書かないけど、[multi stage build](https://docs.docker.com/develop/develop-images/multistage-build/) を使う。

イメージとしては、

```
FROM golang:1.9.2-alpine as build

RUN apk add --update git mysql-client tzdata ca-certificates zip bash && \
    update-ca-certificates && \
    go get -u github.com/golang/dep/cmd/dep && \
    go get -u github.com/golang/lint/golint && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    apk del tzdata && \
    rm -rf /var/cache/apk/*

WORKDIR /go/src/app/

ADD . /go/src/app/
RUN dep ensure
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /usr/local/bin/api ./api

FROM alpine:edge

ENV TZ=Asia/Tokyo GOROOT=/go

COPY --from=build /usr/local/bin/api /usr/local/bin/api-server
ADD https://github.com/golang/go/raw/master/lib/time/zoneinfo.zip /go/lib/time/zoneinfo.zip

RUN chmod 755 /usr/local/bin/api-server
CMD /usr/local/bin/api-server
```

こんな感じ。バイナリをコピーして叩けばいいだけなので最高。

### 結論
Golang最高!!!
