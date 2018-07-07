---
title: "grubでGentooとWindowsを起動できるようにする"
date: 2017-12-28T22:36:16+09:00
tags:
- Gentoo
- Windows
- grub
---

grubを使ってLinuxとWindowsを選択できるようにする方法のメモ。

<!--more-->

[ハンドブック](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Bootloader/ja)にはLinuxとWindowsのデュアルブートのやり方があんまり書いてない。
このやり方はマザーボードがUEFIに対応していることを前提としている。

# 必要なライブラリ

```
# emerge --ask --newuse sys-boot/os-prober
```

# udevをマウント

`udev` をマウントすることで別のOSの情報にアクセスできるようになるらしい。
(これは `/mnt/gentoo` にgentooのルートをマウントしていることを前提としている。)

```
# mkdir -p /mnt/gentoo/run/udev
# mount -o bind /run/udev /mnt/gentoo/run/udev
# mount --make-rslave /mnt/gentoo/run/udev
```

# grubの設定ファイルを作る

```
# grub-mkconfig -o /boot/grub/grub.cfg
```

これで標準出力に `Found windows boot manager...` みたいに出てきたらOK。
rebootして、windowsが選択、起動できることをテストする。

# 参考
[GRUB2](https://wiki.gentoo.org/wiki/GRUB2/ja)
