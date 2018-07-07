---
title: "mount --rbind とはなにか"
date: 2017-12-10T18:16:35+09:00
tags:
- linux
---
表題について学んだ。

<!--more-->

chroot(チョルート)の前に以下のようなコマンドを叩くことが多い。

```
# mount -t proc proc /mnt/gentoo/proc
# mount --rbind /dev /mnt/gentoo/dev
# mount --rbind /sys /mnt/gentoo/sys
```

これはなんなのかいまいちわかっていなかったので学んだ。

# 結論

結論としては、 `/proc` `/dev` `/sys` を、chroot後にも見えるようにするための処理だった。
そもそも mount コマンドはあくまでファイルシステムをマウントするためのコマンド。
`mount -t` `mount --rbind` みたいにするとそれぞれ、ファイルシステムを指定してマウント、ディレクトリをマウントができる。
シンボリックリンクを張ってるみたいなものらしい。
