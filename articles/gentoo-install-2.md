---
title: "ThinkPadE470にGentooをインストールした その2"
date: 2017-12-26T11:39:37+09:00
tags:
- Gentoo
---

その1は[こちら](https://yaginumahidetatsu.com/2017/12/26/gentoo-install-1/)。

<!--more-->

以下について書く。

6 . tarballを展開したディレクトリにchrootする  
7 . portageをセットアップする  
8 . カーネルをビルドする  
9 . ブートローダをセットアップする  
10 . Gentooが起動することを確認する  

### 6. tarballを展開したディレクトリにchrootする

```
# /etc/resolv.confのコピー
% cp -L /etc/resolv.conf /mnt/gentoo/etc/

# 必要なファイルシステムをマウント
% mount -t proc proc /mnt/gentoo/proc
% mount --rbind /dev /mnt/gentoo/dev
% mount --rbind /sys /mnt/gentoo/sys

# /dev/sda3に入る
% chroot /mnt/gentoo /bin/bash
% source /etc/profile
```

### 7. portageをセットアップする

portageとは、Gentooのパッケージ管理ツール。MacでいうHomebrew。
設定の前に、コンパイルオプションを設定する。

```
% nano -w /etc/portage/make.conf
```

nanoコマンドの使い方はググる。(筆者はほぼ使えない)

デフォルトに加えて、以下のように編集する。

```
# デフォルトに追加
MAKEOPTS="-march=native"

# 行として追加
GRUB_PLATFORMS="efi-64"
```

Gentooは、基本的に全てのツールをソースコードからビルドする。その際に、ファイルをコンパイルする時のオプションをここで指定できる。と思えばOK。
詳しくは[これ](https://wiki.gentoo.org/wiki/Safe_CFLAGS)を見る。筆者もあまり詳しくない。

そしてportageをセットアップする。

```
% emerge-webrsync
% emerge --sync
% eselect profile set 1
```

まあまあ時間がかかった気がする。

### 8. カーネルをビルドする

ここがけっこう大変。
どのようにビルドするかの方針を決める必要がある。

全てを自分で判断するのは難しい。筆者は簡単カーネルビルドツールを使用した。

また、簡単ビルドツールには `/etc/fstab` をいい感じにしておく必要がある。
以下のようにした。

```
/dev/sda1   /boot   vfat    noauto,noatime  1 2
/dev/sda3   /       ext4    noatime         0 1
/dev/sda2   none    swap    sw              0 0
```

カーネルをビルドする。

```
# ソースコードとビルドツールをemerge
% emerge gentoo-sources genkernel
% genkernel all
```

しかしこれだとダメだった。筆者がビルドした際のソースコードはバグっていて、([こちら](https://patchwork.kernel.org/patch/9960627/)の事象)途中でコケてしまう。
この時(2017/12/23)の最新バージョンは `4.14.8-rc1` 。
暫定対処として、1つ前のstableのソースコードを使用した。

```
# バージョン指定してインストール
% emerge \=sys-kernel/gentoo-sources-4.12.12
% genkernel all
```

これでうまくいった。ハマった…

### 9. ブートローダをセットアップする

ブートローダをセットアップする。grubを使った。

```
% mkdir -p /boot/efi
% emerge grub efibootmgr
% grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=gentoo_grub /dev/sda
% mkdir -p /boot/efi/boot
% cp /boot/efi/gentoo_grub/grubx64.efi /boot/efi/boot/bootx64.efi
% grub-mkconfig -o /boot/grub/grub.cfg
```

筆者は、 `grub-install` のときに `Could not prepare Boot variable: Read-only file system` のエラーが出たので、[こちら](https://forums.gentoo.org/viewtopic-t-1069106-start-0.html)を参考に以下のようにした。

```
% mount -o remount,rw /sys/firmware/efi/efivars
```

また、 `grub-mkconfig` の時のメッセージで、先程ビルドしたカーネルが認識されていることを確認すること。

### 10. Gentooが起動することを確認する

これでたぶんできているはず。
以下のようにして再起動。

```
% exit

# chrootは抜けている
% cd
% umount -l /mnt/gentoo/dev{/shm,/pts,}
% umount -l /mnt/gentoo{/boot,/proc,}
% reboot
```

Gentooが上がってきたら優勝です。
