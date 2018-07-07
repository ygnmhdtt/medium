---
title: "karabiner-elements(公式)が進化してた"
date: 2017-10-17T15:09:56+09:00
tags:
- Mac
- Karabiner-Elements
---
karabiner-elementsを公式にしたのでメモ。

<!--more-->

自分がkarabinerを使って実現したいのは、左右のCommandを英数/かなにするのと、SandS。
今までは、これを参考に、本家のkarabiner-elementsをforkしたPRを使っていた。
いつしか公式でこれらができるようになっていたのでやり方をメモしておく。

### やり方

公式 からDLする。(執筆時点で11.0.0)

DLして展開したら、以下のコマンドで設定ファイルを編集する。

```
vi ~/.config/karabiner/karabiner.json
```

中身はこちら に置いといた。
抜き出して説明すると、

```
"manipulators": [
  {
      "from": {
          "key_code": "spacebar",
          "modifiers": {
              "optional": [
                  "any"
              ]
          }
      },
      "to": [
          {
              "key_code": "left_shift"
          }
      ],
      "to_if_alone": [
          {
              "key_code": "spacebar"
          }
      ],
      "type": "basic"
  },
  {
      "from": {
          "key_code": "left_command",
          "modifiers": {
              "optional": [
                  "any"
              ]
          }
      },
      "to": [
          {
              "key_code": "left_command"
          }
      ],
      "to_if_alone": [
          {
              "key_code": "japanese_eisuu"
          }
      ],
      "type": "basic"
  },
  {
      "from": {
          "key_code": "right_command",
          "modifiers": {
              "optional": [
                  "any"
              ]
          }
      },
      "to": [
          {
              "key_code": "right_command"
          }
      ],
      "to_if_alone": [
          {
              "key_code": "japanese_kana"
          }
      ],
      "type": "basic"
  }
```

この辺が大事。
to_if_alone が、単独で押した時の挙動になる。
公式でできるようになってよかった。
