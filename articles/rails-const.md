---
title: "Railsのconstantsが反映されなかった"
date: 2016-12-20T18:00:00+09:00
tags:
- Rails
- Docker
---

`app/initializers/constants.rb` に定数を書きたくて書いたんだけど、何故か反映されなくて地味にハマっていた。時間を無駄にした…

<!--more-->

### どうするか

`docker-compose kill` でdockerのインスタンスを終了させて、
`docker-compose up` で再開
要は再起動

### 何故これで治るのか？

app/initializers配下のファイルはアプリケーションを読み込む時にしか読み込まれないっぽい。
実行中にいくらいじってもダメなようでした。ややハマった。
