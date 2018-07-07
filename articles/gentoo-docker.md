---
title: "GentooにDockerを入れた"
date: 2017-12-31T08:48:51+09:00
tags:
- Linux
- Docker
- Gentoo
---

表題の手順をメモる。

<!--more-->

Gentooを仕事で使うにあたり、Dockerがないとなにもできない。インストールしていく。

### dockerインストール

先にカーネルの設定をしてもいいが、筆者はとりあえず入れた。

```
$ emerge app-emulation/docker
```

筆者のUSEフラグはデフォルトのままにしてあり、なにもいじってない。
注意点としてはファイルシステム周り。overlayを有効にすることだけ気をつければいい。
この状態で試しに、

```
$ rc-service docker start
```

でdockerをスタートする。
カーネルがいい感じに設定されていれば、これでも起動するはず。 `sudo docker ps` などして確認する。

もし起動しなければ、カーネルの再設定が必要。必要に応じて `/var/log/docker.log` を確認しておく。

### カーネル設定

カーネル設定については、[wiki](https://wiki.gentoo.org/wiki/Docker)の通りやればOK。  
筆者の場合、特にモジュールを追加でロードするような設定もしなかった。  
注意点としては、このwikiはファイルシステムにoverlayを採用するようなやり方が書いてある。  
もしなんらかの理由で他のファイルシステム(AUFSなど)を使いたい場合、この通りではダメ。  
特に、AUFSの場合は[こちら](https://wiki.gentoo.org/wiki/Aufs) を参考にパッチを当てる必要がある。  
また、AUFSを使う場合はdockerインストール時にaufsのUSEフラグを立てておくことも必要。

カーネル設定したら `grub-mkconfig` して再起動。

### 使用準備

これでdockerがちゃんと起動することを確認する。
また、

```
$ rc-update add docker default
```

でdockerが起動時に上がることを設定しておく。  
最後に、

```
$ sudo gpasswd -a ユーザ名 docker
```

で、ユーザをdockerグループに入れておく。こうしないと、 `docker ps` すら `sudo` が必要。また、グループ変更は一回ログアウトしないと反映されない。


### ちなみに

[公式](https://docs.docker.com/engine/userguide/storagedriver/overlayfs-driver/)にある通り、AUFSよりオーバーレイのほうが推奨らしい。注意。
