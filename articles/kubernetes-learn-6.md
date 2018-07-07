---
title: "Kubernetesについて学ぶ 6"
date: 2018-01-16T10:57:50+09:00
tags:
- aaa
---

続きをやる。

<!--more-->

[Interactive Tutorial - Deploying an App](https://kubernetes.io/docs/tutorials/kubernetes-basics/deploy-interactive/)のStep3をやる。

### View our app

```
Kubernetes内で動作しているポッドは、プライベートな独立したネットワーク上で実行されています。
デフォルトでは、同じkubernetesクラスタ内の他のポッドやサービスからは見えますが、
そのネットワーク外では表示されません。 
kubectlを使用するときは、アプリケーションと通信するためにAPIエンドポイントを介して対話しています。
```

Podとは、 `group of one or more containers (such as Docker containers), with shared storage/network, and a specification for how to run the containers` とのこと。
作成したデプロイメントによってあがるコンテナ郡のことをPodという単位で呼称しているのだと思う(たぶん)。
重要な概念っぽい。

```
モジュール4のkubernetesクラスターの外部にアプリケーションを公開する方法に関するその他のオプションについても説明します。

kubectlコマンドは、通信をクラスタ全体のプライベートネットワークに転送するプロキシを作成できます。
プロキシはcontrol-Cを押して終了することができ、実行中は出力を表示しません。

プロキシを実行するための2番目の端末ウィンドウを開きます。
```

```
$ kubectl proxy
Starting to serve on 127.0.0.1:8001
```

```
私たちは現在、ホスト（オンライン端末）とKubernetesクラスタとの間の接続を持っています。
プロキシは、これらの端末からAPIへの直接アクセスを可能にします。

プロキシエンドポイント経由でホストされているすべてのAPIを見ることができます。
これはhttp://localhost:8001から入手できます。
たとえば、curlコマンドを使用してAPIを介して直接バージョンを問い合わせることができます。
```

```
$ curl http://localhost:8001/version
{
  "major": "1",
  "minor": "5",
  "gitVersion": "v1.5.2",
  "gitCommit": "08e099554f3c31f6e6f07b448ab3ed78d0520507",
  "gitTreeState": "clean",
  "buildDate": "1970-01-01T00:00:00Z",
  "goVersion": "go1.7.1",
  "compiler": "gc",
  "platform": "linux/amd64"
}
```

つまり、ポッドはプライベートなネットワーク上で稼働するので、そこに外部からアクセスするためのプロキシを立てられるということっぽい。


```
APIサーバーは、ポッド名に基づいて各ポッドのエンドポイントを自動的に作成します。ポッド名は、プロキシを介してアクセスすることもできます。

まず、Pod名を取得する必要があります。それを、環境変数POD_NAMEに保存します。
```

```
$ export POD_NAME=$(kubectl get pods -o go-template --template '{ge .items}}{{.metadata.name}}{{"\n"}}{{end}}')
$ echo Name of the Pod: $POD_NAME
Name of the Pod: kubernetes-bootcamp-390780338-7bv66
```

```
これで、そのポッドで実行されているアプリケーションに対してHTTPリクエストを行うことができます。
```

```
$ curl http://localhost:8001/api/v1/proxy/namespaces/default/pods/$POD_NAME/
Hello Kubernetes bootcamp! | Running on: kubernetes-bootcamp-390780338-7bv66 | v=1
```

```
urlは、PodのAPIへのルートです。

注：端末の上部を確認してください。プロキシは新しいタブ（ターミナル2）で実行され、最近のコマンドは元のタブ（ターミナル1）で実行されました。プロキシはまだ2番目のタブで実行されており、curlコマンドはlocalhost：8001を使用して動作することができました。
```

補足する。

![](/images/kubernetes-learn-6/1.png)

Terminal1ではAPIを叩いていて、

![](/images/kubernetes-learn-6/2.png)

Terminal2でプロキシが動いている。(つまり同じホスト)

コンテナをデプロイして、プロキシ経由でアクセスする。という流れで使うことがわかった。

