---
title: "pecoを使ったカスタムスクリプトをまとめる"
date: 2017-06-08T09:55:55+09:00
tags:
- tools
- peco
- bash
---
pecoが便利すぎるので、カスタムしたスクリプトについてメモしておく。

<!--more-->

### pecoでディレクトリを移動する

```
#!bin/bash
function peco-lscd {
    local dir="$( ls -1d ./* | peco )"
    if [ ! -z "$dir" ] ; then
        cd "$dir"
        ls -a
    fi
}
```

パスを通してpeco-lscd を叩くと

```
QUERY>                                                                                                                                                                                IgnoreCase [13 (1/1)]
./Applications
./Desktop
./Documents
./Downloads
./Dropbox
./Library
./Movies
./Music
./Pictures
./Public
./work
```

こういう感じで出てくるので、インクリメンタルサーチしながら移動ができる。そんなに使ってないかも。

### pecoでファイルをviで開く

```
#!bin/bash
function peco-vim {
    local file="$( ls -F | grep -v / | peco )"
    if [ ! -d "$file" -a "$file" != "" ] ; then
        vi "$file"
    fi
}
```

IDEとかを使わずにコーディングするときは、ファイルが多いことが多いのでけっこう使える。

### pecoでdockerコンテナに入る

```
#!/bin/bash

function peco-docker-exec() {
  docker exec -it `docker ps | peco | cut -d" " -f 1` /bin/bash
}
```

通常は `docker exec -it xxxx /bin/bash` と打たなきゃいけないんだけど、かなりめんどくさいので、作った。これは本当に便利、一番良く使う。

### まとめ

pecoは最高。
適当にエイリアスを作って、コピペして使ってください！
