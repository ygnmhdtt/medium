---
title: "tmuxについて学んだ"
date: 2017-12-26T22:13:40+09:00
tags:
- tmux
---

tmuxをちゃんと勉強した。

<!--more-->

Gentooを使い始めるにあたり、iTermなんてものはなく、まだウインドウマネージャーも入れてないので、ターミナルの分割をtmuxで行っている。
忘れないようにメモっておく。

# コマンドたち

```
# 新規セッション開始
tmux

# 名前をつけて新規セッション開始
tmux new -s <セッション名>

# セッションの一覧表示
tmux ls

# セッションを再開
tmux a

# セッションを終了
tmux kill-session
```

tmuxは、セッション > window > ペイン のような関係になっている。
セッションを作るところから全てが始まる。
セッション内でセッションは作れない。
まずはセッションを作って、その中でwindowやペインを自由に作るような形になる。

# 筆者の設定ファイル

```sh
# bind Ctrl-t to prefix
set -g prefix C-t

# unbind default prefix
unbind C-b

# decrease delay
set -sg escape-time 1

# reload conf
bind-key r source-file ~/.tmux.conf \; \
  display-message "source-file done"

# use |
bind | split-window -h

# use -
bind - split-window -v

# use hjkl
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# use 256 colored terminal
set -g default-terminal "screen-256color"

# set color of status bar
set -g status-fg white
set -g status-bg black

# set color of window
setw -g window-status-fg cyan
setw -g window-status-bg default
setw -g window-status-attr dim

# set hiughlight on forcused window
setw -g window-status-current-fg white
setw -g window-status-current-bg red
setw -g window-status-current-attr bright

# set color of pane
set -g pane-border-fg green
set -g pane-border-bg black

# set hiughlight on forcused pane
set -g pane-active-border-fg white
set -g pane-active-border-bg yellow

# set color of commandline
set -g message-fg white
set -g message-bg black
set -g message-attr bright

# statusbar

## left
set -g status-left-length 40
set -g status-left '#[fg=cyan,bg=#303030]#{?client_prefix,#[reverse],} #H[#S] #[default]'

## right
set -g status-right "#[fg=cyan][%Y-%m-%d(%a) %H:%M]"

## interval of reflesh
set -g status-interval 60
## position of window list
set -g status-justify centre
## enable visual notification
setw -g monitor-activity on
set -g visual-activity on

# top statusbar
set -g status-position top

# like vim
setw -g mode-keys vi

# highlight prefix
```


# プレフィックス

tmuxではプレフィックス(ショートカット)の後に特定のキーを押すことでいろんな操作ができる。
デフォルトのプレフィックスは\<C-t\>にしている。

以下のコマンドはプレフィックスの後に入力することで実行される。自分がよく使うものだけメモ。

```
s    セッションの一覧選択
d    セッションからデタッチ
```

```
c    新規ウインドウ作成
w    ウインドウの一覧選択
0-9  指定番号のウインドウへ移動
&    ウインドウの破棄
n    次のウインドウへ移動
p    前のウインドウへ移動
l    以前のウインドウへ移動
,    ウインドウに名前をつける
```

```
|    左右にペイン分割
-    上下にペイン分割
q    ペイン番号を表示
hjkl 指定方向のペインへ移動
!    ペインを解除してウインドウ化
x    ペインの破棄
```

筆者はひとりで使っているので、セッションは常にひとつ、ウインドウが何枚かあり、ペインは各ウインドウに細大でも4つ程度用意していることが多い。

# コピペ

```
[       コピーモードの開始
スペース コピー開始位置決定
エンター コピー終了位置決定
]       コピーした内容を貼り付け
```

上記の設定ファイルどおりなら、 `hjkl` で移動可能。めっちゃ便利。

# プレフィックスの可視化

[こちら](https://qiita.com/dtan4/items/363e92525e7c5a16f3fc)を参考に、プレフィックスが押されたらハイライトするようにしている。必須設定だと思う。

# まとめ
tmuxサイコー!!
