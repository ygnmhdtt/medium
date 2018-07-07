---
title: "left_ctrl+hjklで移動する"
date: 2017-10-22T20:23:50+09:00
tags:
- tools
- karabiner-elements
---
Ctrl+hjklでvim以外でも移動したかったので、karabiner-elementsを設定した。

<!--more-->

vimっぽく動かしたかった。


~/.config/karabiner/karabiner.json を以下のように編集。

```
                    {
                        "description": "Change left_control+hjkl to arrow keys",
                        "manipulators": [
                            {
                                "from": {
                                    "key_code": "h",
                                    "modifiers": {
                                        "mandatory": [
                                            "left_control"
                                        ],
                                        "optional": [
                                            "any"
                                        ]
                                    }
                                },
                                "to": [
                                    {
                                        "key_code": "left_arrow"
                                    }
                                ],
                                "type": "basic"
                            },
                            {
                                "from": {
                                    "key_code": "j",
                                    "modifiers": {
                                        "mandatory": [
                                            "left_control"
                                        ],
                                        "optional": [
                                            "any"
                                        ]
                                    }
                                },
                                "to": [
                                    {
                                        "key_code": "down_arrow"
                                    }
                                ],
                                "type": "basic"
                            },
                            {
                                "from": {
                                    "key_code": "k",
                                    "modifiers": {
                                        "mandatory": [
                                            "left_control"
                                        ],
                                        "optional": [
                                            "any"
                                        ]
                                    }
                                },
                                "to": [
                                    {
                                        "key_code": "up_arrow"
                                    }
                                ],
                                "type": "basic"
                            },
                            {
                                "from": {
                                    "key_code": "l",
                                    "modifiers": {
                                        "mandatory": [
                                            "left_control"
                                        ],
                                        "optional": [
                                            "any"
                                        ]
                                    }
                                },
                                "to": [
                                    {
                                        "key_code": "right_arrow"
                                    }
                                ],
                                "type": "basic"
                            }
                        ]
                    }
```

見れば分かる通り、hjklで移動できるようになるというより、それぞれ矢印キーにマップしている。

なので、例えばシェルで前のコマンドを叩くときに上矢印を押すのも、Ctrl+k でいけるようになる。かなり便利。
chrome拡張とかで実現してる人もいるけど、karabiner-elementsで思った以上にいろんなことができる。
