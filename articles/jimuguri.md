---
title: "Rubyでシンプルなコマンドラインツールを作成するためのGem Jimuguri"
date: 2018-01-30T20:06:26+09:00
tags:
- tools
- Ruby
---

Qiitaからこちらに移す。

<!--more-->

# はじめに
コマンドラインツールでも作るか〜と考えた時、最近はGoを使って書いている人が多いかと思います。バイナリで配布できるし。
筆者もGoで書くことが多いっちゃ多いのですが、書き慣れたRubyで書きたい、という方向けに、シンプルなCLIツールクリエイターを紹介します。(ここでいうシンプルとは、覚えることが少なく、機能も少ない、の意)

RubyでCLIツールを作るとなると [Thor](https://github.com/erikhuda/thor) がメジャーかと思いますが、かなり高機能で、ここまで色々できなくていい、、という方にピッタリかと思います。

また、筆者はこのGemの作者です。「いいものを作ったから、いろんな人に使ってもらいたい！！」というモチベーションでこの記事を書いています。あくまで技術共有のための記事ですが、「宣伝や販売を主目的とした記事は投稿しない」に抵触する場合は、エントリの改修もしくは削除を行うので、ご指摘ください。m(_ _)m

# ソース

[Github :octocat: ](https://github.com/ygnmhdtt/jimuguri)
[RubyGem :gem: ](https://rubygems.org/gems/jimuguri)

# できること

こんな感じでコマンドが作れます。
受け取ったメッセージをprintするアクションと、reverseしてprintするアクションです。

```ruby
# インスタンス
app = Jimuguri::Cli.new(name: 'jimuguri sample', description: 'sample app', version: '1.0.1')

# アクション定義
app.add_action 'print', 'print passed message' do
  print app.options[:message]
end

app.add_action 'reverse', 'print reversed passed message' do
  print app.options[:message].reverse
end

# オプション定義
app.add_option 'm message', 'message message', 'Print message(required)'

# start
app.run ARGV
```

```sh
$ ruby sample.rb print -m 'Hello World!'
Hello World!
$ ruby sample.rb reverse -m 'Hello World!'
!dlroW olleH
```

# 使い方

使い方を説明します。

## アプリ作成

```ruby
Cli.new(name: 'jimuguri sample', description: 'sample app', version: '1.0.1')
```
name, description, versionを初期化時に渡します。
この情報はヘルプに出てくるだけなので適当でもいいっちゃいいです。

## action追加

```ruby
app.add_action 'print', 'print passed message' do
  print app.options[:message]
end
```

アドドアクションメソッドでアドドできます。

|第1引数|第2引数|ブロック|
|:---|:---|:---|
|コマンド名|コマンドの説明|コマンドの中身|

コマンドの説明はヘルプにのみ使われます。
もちろん、アクションは複数定義できます。

また、以下のように、doブロックの中から別のメソッドも呼び出せます。

```ruby
def upper_case(str)
  str.upcase
end

app.add_action 'print', 'print passed message' do
  print upper_case app.options[:message]
end
```

## option追加

```ruby
app.add_option 'm', 'message', 'Print message(required)'
```

アドドオプションメソッドでアドドできます。

|第1引数|第2引数|第3引数|
|:---|:---|:---|
|オプション名(short)|オプション名(long)|オプションの説明|

オプションの説明はヘルプにのみ使われます。

オプションを定義すると、shortは `-#{short}` 、 `--#{long}` の形で使用することができます。
つまり、上記の例では、`-m` もしくは `--message` のように呼び出すことができます。

### オプションについての説明

オプションには次の3つが存在します。

|オプション|役割|
|:---|:---|
|フラグオプション|true/false|
|必須オプション|引数が必須となる|
|任意オプション|引数があれば引数を取り、なければtrue/false|

書き方は以下のとおりです。

#### フラグオプション

```ruby
app.add_option 'f', 'force', 'Do something force'
```

フラグオプションは、あればtrueがとれ、なければfalseとなります。

#### 必須オプション

```ruby
app.add_option 'o FILENAME', 'output FILENAME', 'Specify output file.(required)'
```

第2引数にスペースつなぎで渡してほしいものをくっつけます。(名前は `FILENAME` でなくてもなんでもOK)
必須オプションは、引数(例で言うとFILENAME)がないとコマンドが叩けません。(ヘルプが表示されます。)

#### 任意オプション

```ruby
app.add_option 'm [message]', 'message [message]', 'Shows message if passed(optional)'
```

第2引数にスペースつなぎで渡してほしいものをくっつけますが、それを `[]` でかこむことで任意になります。
引数があれば引数を取得でき、なければ `true` をとれます。

## オプションの使い方

オプションをアクションの中から以下のように取得できます。

```ruby
msg = app.options[:message]
```

ハッシュのキーは、オプションに設定した第2引数です。

## その他

ヘルプとバージョンは自動生成されます。
ここまで説明したもので試してみます。

```
$ bundle exec ruby sample.rb help
NAME:
    jimuguri sample - sample app

USAGE:
    ruby `file_name.rb` command [command options] [arguments...]

VERSION:
    1.0.1

COMMANDS:
    help        Shows a list of commands or help for one command
    version     Shows version
    print       print passed message
    reverse     print reversed passed message

OPTIONS:
    -f --force  Do something force
    -o FILENAME --output FILENAME     Specify output file.
    -m [message] --message [message]  Shows message if passed
```

```
$ bundle exec ruby sample.rb version
1.0.1
```

# まとめ

Jimuguriは制約を多くし、やれることを少なくすることでシンプルさを保っています。
コマンドラインツールを書き慣れた Rubyで書きたい、しかし `Thor` ほどの高機能はなくてよい、というシチュエーションで、ぜひ使ってみてください!!

