---
title: "Kubernetesについて学ぶ 5"
date: 2018-01-16T10:42:25+09:00
tags:
- kubernetes
---

デプロイのチュートリアルをやっていく。

<!--more-->

[Interactive Tutorial - Deploying an App](https://kubernetes.io/docs/tutorials/kubernetes-basics/deploy-interactive/)をやっていく。

### kubectl basics

```
minikubeのように、kubectlはオンライン端末にインストールされています。
ターミナルにkubectlと入力して、その使用方法を確認します。 
kubectlコマンドの一般的な形式は次のとおりです。
```

```
$ kubectl action resource
```

```
これは、指定されたリソース（node、containerなど）に対して指定されたアクション（create、describeなど）を実行します。
コマンドの後に--helpを使用すると、可能なパラメータに関する追加情報を取得できます（kubectl get nodes --help）。

kubectl versionコマンドを実行して、kubectlがクラスタと通信するように設定されていることを確認します。
```

```
$ kubectl version
Client Version: version.Info{Major:"1", Minor:"8", GitVersion:"v1.8.0", GitCommit:"6e937839ac04a38cac63e6a7a306c5d035fe7b0a", GitTreeState:"clean", BuildDate:"2017-09-28T22:57:57Z", GoVersion:"go1.8.3", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"5", GitVersion:"v1.5.2", GitCommit:"08e099554f3c31f6e6f07b448ab3ed78d0520507", GitTreeState:"clean", BuildDate:"1970-01-01T00:00:00Z", GoVersion:"go1.7.1", Compiler:"gc", Platform:"linux/amd64"}
```

```
OK、kubectlがインストールされており、クライアントとサーバの両方のバージョンが表示されます。

クラスタ内のノードを表示するには、kubectl get nodesコマンドを実行します。
```

```
$ kubectl get nodes
NAME      STATUS    ROLES     AGE       VERSION
host01    Ready     <none>    6m        v1.5.
```

```
ここでは、利用可能なノード（ここでは01）が表示されます。 
Kubernetesは、ノードの利用可能なリソースに基づいてアプリケーションをどこに展開するかを選択します。
```

ここまでは前回もやった。

### Deploy our app

```

kubectlの実行コマンドを使ってKubernetesで最初のアプリケーションを実行しましょう。 
runコマンドは、新しいデプロイメントを作成します。
デプロイメント名とアプリケーションイメージの場所
（Dockerハブの外部にホストされているイメージの完全なリポジトリURLを含む）
を提供する必要があります。
特定のポートでアプリケーションを実行したいので--portパラメータを追加します：
```

```
$ kubectl run kubernetes-bootcamp --image=docker.io/jocatalin/kubetes-bootcamp:v1 --port=8080
deployment "kubernetes-bootcamp" created
```

```
Great！デプロイメントを作成するだけで、最初のアプリケーションをデプロイしました。
これはあなたのためにいくつかのことを行いました：

* アプリケーションのインスタンスを実行できる適切なノードを検索しました（利用可能なノードは1つしかありません）
* そのノードでアプリケーションを実行するようにスケジュールしました
* 必要に応じて新しいノードでインスタンスを再スケジュールするようにクラスタを構成しました

デプロイメントをリストするには、get deploymentsコマンドを使用します。
```

```
$ kubectl get deployments
NAME                  DESIRED   CURRENT   UP-TO-DATE   AVAILABLE AGE
kubernetes-bootcamp   1         1         1            1 1m
```

```
アプリの1つのインスタンスを実行する1つのデプロイメントがあることがわかります。
インスタンスは、ノード上のDockerコンテナ内で実行されています。
```

ためしに、 `kubectl run --help` してみた。

```
$ kubectl run --help
Create and run a particular image, possibly replicated.

Creates a deployment or job to manage the created container(s).

Examples:
  # Start a single instance of nginx.
  kubectl run nginx --image=nginx

  # Start a single instance of hazelcast and let the container expose port 5701 .
  kubectl run hazelcast --image=hazelcast --port=5701

  # Start a single instance of hazelcast and set environment variables "DNS_DOMAIN=cluster" and "POD_NAMESPACE=default" in the container.
  kubectl run hazelcast --image=hazelcast --env="DNS_DOMAIN=cluster" --env="POD_NAMESPACE=default"

  # Start a single instance of hazelcast and set labels "app=hazelcast" and "env=prod" in the container.
  kubectl run hazelcast --image=nginx --labels="app=hazelcast,env=prod"

  # Start a replicated instance of nginx.
  kubectl run nginx --image=nginx --replicas=5

  # Dry run. Print the corresponding API objects without creatingthem.
  kubectl run nginx --image=nginx --dry-run

  # Start a single instance of nginx, but overload the spec of the deployment with a partial set of values parsed from JSON.
  kubectl run nginx --image=nginx --overrides='{ "apiVersion": "v1", "spec": { ... } }'

  # Start a pod of busybox and keep it in the foreground, don't restart it if it exits.
  kubectl run -i -t busybox --image=busybox --restart=Never

  # Start the nginx container using the default command, but use custom arguments (arg1 .. argN) for that command.
  kubectl run nginx --image=nginx -- <arg1> <arg2> ... <argN>

  # Start the nginx container using a different command and custom arguments.
  kubectl run nginx --image=nginx --command -- <cmd> <arg1> ... <argN>

  # Start the perl container to compute π to 2000 places and print it out.
  kubectl run pi --image=perl --restart=OnFailure -- perl -Mbignum=bpi -wle 'print bpi(2000)'

  # Start the cron job to compute π to 2000 places and print it out every 5 minutes.
  kubectl run pi --schedule="0/5 * * * ?" --image=perl --restart=OnFailure -- perl -Mbignum=bpi -wle 'print bpi(2000)'

(Optionsは省略)

Usage:
  kubectl run NAME --image=image [--env="key=value"] [--port=port] [--replicas=replicas] [--dry-run=bool] [--overrides=inline-json][--command] -- [COMMAND] [args...] [options]

Use "kubectl options" for a list of global command-line options (applies to all commands).
```

最低限必要なのは、 `NAME` と コンテナイメージらしい。ローカルでビルドしたイメージを使うにはどうするのか？が気になる。

この後は別エントリとする。
