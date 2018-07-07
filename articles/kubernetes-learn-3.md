---
title: "Kubernetesについて学ぶ 3"
date: 2018-01-13T18:00:29+09:00
tags:
- kubernetes
---

オンラインチュートリアルをやっていく。

<!--more-->

前回は[こちら](https://yaginumahidetatsu.com/2018/01/12/kubernetes-learn-2/)。

今日は[Interactive Tutorial](https://kubernetes.io/docs/tutorials/kubernetes-basics/cluster-interactive/)をやってみる。

### Interactive Tutorial - Creating a Cluster

チュートリアルはブラウザ上にターミナルがあって、どっかの仮想サーバをいじれるようになっている。

```
$ minikube version
minikube version: v0.17.1-katacoda
```

```
$ minikube start
Starting local Kubernetes cluster...
$
```

`start` でスタートできるっぽい。

```
このブートキャンプ中にKubernetesと対話するために、
コマンドラインインターフェイスkubectlを使用します。
次のモジュールでkubectlについて詳しく説明しますが、今はクラスタ情報をいくつか見ていきます。 
kubectlがインストールされているかどうかを確認するには、kubectl versionコマンドを実行します：
```

```
$ kubectl version
Client Version: version.Info{Major:"1", Minor:"8", GitVersion:"v1.8.0", GitCommit:"6e937839ac04a38cac63e6a7a306c5d035fe7b0a", GitTreeState:"clean", BuildDate:"2017-09-28T22:57:57Z", GoVersion:"go1.8.3", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"5", GitVersion:"v1.5.2", GitCommit:"08e099554f3c31f6e6f07b448ab3ed78d0520507", GitTreeState:"clean", BuildDate:"1970-01-01T00:00:00Z", GoVersion:"go1.7.1", Compiler:"gc", Platform:"linux/amd64"}
$
```

Go製らしい。kubectlというインタフェースでminikubeを操作する。

```

OK、kubectlが設定されており、クライアントのバージョンとサーバーのバージョンの両方を見ることができます。
クライアントのバージョンはkubectlのバージョンです。サーバーのバージョンは、
マスターにインストールされたKubernetesバージョンです。ビルドの詳細を表示することもできます。
```

とのこと。


```
$ kubectl cluster-info
Kubernetes master is running at http://host01:8080
heapster is running at http://host01:8080/api/v1/namespaces/kube-system/services/heapster/proxy
kubernetes-dashboard is running at http://host01:8080/api/v1/namespaces/kube-system/services/kubernetes-dashboard/proxy
monitoring-grafana is running at http://host01:8080/api/v1/namespaces/kube-system/services/monitoring-grafana/proxy
monitoring-influxdb is running at http://host01:8080/api/v1/namespaces/kube-system/services/monitoring-influxdb/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

`cluster-info` をたたくことで、クラスタの情報をとれるっぽい。
上記を見るに、master、及びdashboardなどがクラスタ内で動いているらしい。


ちなみに、 `kubectl cluster-info dump` を叩いてみたら、めちゃめちゃ長いjsonが吐かれた。

```
$kubectl get nodes
NAME      STATUS    ROLES     AGE       VERSION
host01    Ready     <none>    8m        v1.5.2
```

これは `docker ps` した時のやつですね。


要するに、 `host01` っていうホストで構成されるクラスタがあり、その上でmasterやdashboardが動いている。その情報にアクセスするためのAPIが
`kubectl` らしい。

ここまでで `Module1(Create a Cluster)` が終了した。

この後はModule2の `Deploy an App` をやっていく。
