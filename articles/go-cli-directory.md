---
title: "go getすれば即コマンドとして使えるようにCLIツールを作る"
date: 2018-01-30T20:08:16+09:00
tags:
- Go
- CLI
---

これも載せ替える。

<!--more-->

# この記事を読むとわかること

本記事には **`go get` すれば、即コマンドとして実行できるCLIツール(コマンド)を作る手順** が書かれています。

# はじめに
Goはソースコードをクロスコンパイルして、各プラットフォーム向けに配布することができます。しかし、実際やろうとすると、どうやって配布するか悩みます。(GHRが多いと思う。)あと、全部のプラットフォーム向けにビルドしようとすると、スクリプトを書かなきゃいけなかったりしますよね。
本エントリでは、もう少し軽いタッチで、Goの環境があるユーザに対して、goで作ったCLIツールを配布する方法を書いていきます。

# 事前準備

ツールを使うユーザは、以下の環境変数を持っている必要があります。

```
PATH=$PATH:$GOPATH/bin
```
[公式](https://golang.org/doc/code.html#GOPATH)にもありますね。
作りたいツールのREADMEにでも書いておきましょう。

# ツールの作り方

ディレクトリ構成を、こんな感じにします。ここでは、 `hello` というコマンドを作るとします。

```
.
├── cmd
│   └── hello
│       └── main.go
├── hello_lib.go
├── hello_lib_test.go
├── LICENSE
└── README.md
```

説明していきます。

## main.go

main.goはコマンドの起点となります。これは、 `./cmd/コマンド名/main.go` という名前にします。
こんな感じで書いてみます。

```
package main

import (
  "fmt"
  "github.com/ygnmhdtt/hello_lib"
)

func main() {
  fmt.Println(hello_lib.World())
}
```

ポイントとしては、

* 依存ライブラリ(`hello_lib`)はgithub上のパスを書く

ことです。
次に、 `hello_lib` を書いていきます。

## hello_lib

hello_libはmainから呼ばれるパッケージです。(名前は好きなように付けてください。)

```
package hello_lib

func World() string {
  return "hello world"
}
```

# ダウンロード方法
この状態で、

```
$ hello
```

と叩いたら

```
hello world
```

と表示されるようにするには、ユーザーに以下のコマンドを叩いてもらいます。

```
$ go get github.com/ygnmhdtt/hello/cmd/hello
```

(↑ `/cmd/hello` まで必ず含めてください。)
これで

```
$ hello
```

が叩けるようになります。

# なぜこれだけでいいのか？

`go get` は渡されたパスのソースをダウンロードして、ユーザのプラットフォームに合わせてビルドし、それを `$GOPATH/bin` に配置してくれます。
この時、main.goがあるディレクトリ名(上記の例では `hello` )のバイナリになります。
ユーザが `$GOPATH/bin` にPATHを通してくれていれば、 `hello` というバイナリを叩けるわけです。
また、 `main` で `hello_lib` というパッケージをimportしていますが、このような依存しているパッケージも勝手に落としてくれます。

# コマンドを増やすことができる

```
.
├── cmd
│   └── hello
│       └── main.go
├── hello_lib.go
├── hello_lib_test.go
├── LICENSE
└── README.md
```

当初の状態から

```
.
├── cmd
│   └── hello
│       └── main.go
│   └── dog
│       └── main.go
│   └── cat
│       └── main.go
├── hello_lib.go
├── hello_lib_test.go
├── LICENSE
└── README.md
```

こんな風に `cmd` 配下を増やして、

```
$ go get github.com/ygnmhdtt/hello/cmd/dog
```

```
$ go get github.com/ygnmhdtt/hello/cmd/cat
```

とすれば、hello_libを共通で使うようなコマンドを簡単に増やすことができます。
そのため、 `hello_lib` にユーティリティ的な関数を定義しておいて、それらを小さなコマンドに分割して、パイプでつないで使うような、粋な使い方ができます。

# ライブラリとしても使える

このやり方だと、 `hello_lib` をライブラリとしても提供できるようになります。
ユーザは `go get github.com/ygnmhdtt/hello_lib`するだけです。
コマンドとして使う場合と、ライブラリとして使う場合、どちらも備わっていたらクールですよね。

# まとめ
このやり方を採用することで、

* `go get`すれば即コマンドとして使える
* 小さいコマンドを増やしていける
* ライブラリとしてGoのソースからも使える

ようなメリットがあります。
ぜひお試しくださいませ :v: (｀・ω・´) :v:

