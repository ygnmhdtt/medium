---
title: "カーネル構築時のオプションについて"
date: 2017-12-29T10:40:43+09:00
tags:
- Gentoo
- Kernel
---

`make *config` について学んだ。

<!--more-->

以下の内容は `/usr/src/linux/Documentation/admin-guide/README.rst` にあったもの。

```
カーネルの設定
----------------------

   このステップは、たとえマイナーバージョンのアップデートであっても省略することはできません。
   どのリリースでも新たな設定オプションが追加されるし、もし設定ファイルが期待される通りでなければ、
   奇妙な問題が起こるでしょう。もし最低限の手順で既存の設定を新しいバージョンに持っていきたいならば、
   `make oldconfig` を使用します。これは、新たなカーネル設定に対する回答のみをあなたに尋ねます。

 - 設定のコマンド::

     "make config"      プレーンテキストの設定インタフェース。

     "make menuconfig"  テキストベースの色付きのメニュー、ラジオリスト、ダイアログ。

     "make nconfig"     改良されたテキストベースの色付きのメニュー。

     "make xconfig"     Qtベースの設定ツール。

     "make gconfig"     Gtk+ベースの設定ツール。

     "make oldconfig"   全ての質問の答えを既存の `.config` ファイルのコンテンツをベースとし、
                        新たな設定シンボルについては質問する。

     "make silentoldconfig"
                        上と似ているが、すでに回答済みの質問については画面に出さない。

     "make olddefconfig"
                        上と似ているが、新たなシンボルは自動的にそれらのデフォルトにする。

     "make defconfig"   `arch/$ARCH/defconfig` か、 `arch/$ARCH/configs/${PLATFORM}_defconfig` のいずれかから、
                        アーキテクチャに依存して、デフォルトのシンボルを用いて新たな `.config` ファイルを作る。

     "make ${PLATFORM}_defconfig"
                        `arch/$ARCH/configs/${PLATFORM}_defconfig` のデフォルト値を使って、新たな `.config` を作る。
                        あなたのアーキテクチャで使用可能な全てのプラットフォームのリストを得るためには、
                        `make help` を使う。

     "make allyesconfig"
                        可能な限り全てのシンボルを `y(カーネル組み込み)` にした `.config` を作る。

     "make allmodconfig"
                        可能な限り全てのシンボルを `m(カーネルモジュール)` にした `.config` を作る。

     "make allnoconfig" 可能な限り全てのシンボルを `n(ビルドしない)` にした `.config` を作る。

     "make randconfig"  シンボルをランダムに設定した `.config` を作る。

     "make localmodconfig" 今の設定とロード中のモジュール(`lsmod`)をベースに設定を作る。
                           ロード済みのモジュールに不要なオプションは無効にする。

                           別のマシンのための `localmodconfig` を作るには、そのマシンの `lsmod` をファイルにして、
                           `LSMOD` パラメータと一緒に渡す。

                   target$ lsmod > /tmp/mylsmod
                   target$ scp /tmp/mylsmod host:/tmp

                   host$ make LSMOD=/tmp/mylsmod localmodconfig

                           これはクロスコンパイル時にも動作する。

     "make localyesconfig" localmodconfigと似ているが、全てのモジュールオプションをカーネル組み込み(=y)とする。

   Linuxカーネル設定ツールについての情報は、 `Documentation/kbuild/kconfig.txt` で参照できる。
```

原文は以下。

```
Configuring the kernel
----------------------

   Do not skip this step even if you are only upgrading one minor
   version.  New configuration options are added in each release, and
   odd problems will turn up if the configuration files are not set up
   as expected.  If you want to carry your existing configuration to a
   new version with minimal work, use ``make oldconfig``, which will
   only ask you for the answers to new questions.

 - Alternative configuration commands are::

     "make config"      Plain text interface.

     "make menuconfig"  Text based color menus, radiolists & dialogs.

     "make nconfig"     Enhanced text based color menus.

     "make xconfig"     Qt based configuration tool.

     "make gconfig"     GTK+ based configuration tool.

     "make oldconfig"   Default all questions based on the contents of
                        your existing ./.config file and asking about
                        new config symbols.

     "make silentoldconfig"
                        Like above, but avoids cluttering the screen
                        with questions already answered.
                        Additionally updates the dependencies.

     "make olddefconfig"
                        Like above, but sets new symbols to their default
                        values without prompting.

     "make defconfig"   Create a ./.config file by using the default
                        symbol values from either arch/$ARCH/defconfig
                        or arch/$ARCH/configs/${PLATFORM}_defconfig,
                        depending on the architecture.

     "make ${PLATFORM}_defconfig"
                        Create a ./.config file by using the default
                        symbol values from
                        arch/$ARCH/configs/${PLATFORM}_defconfig.
                        Use "make help" to get a list of all available
                        platforms of your architecture.

     "make allyesconfig"
                        Create a ./.config file by setting symbol
                        values to 'y' as much as possible.

     "make allmodconfig"
                        Create a ./.config file by setting symbol
                        values to 'm' as much as possible.
     "make allnoconfig" Create a ./.config file by setting symbol
                        values to 'n' as much as possible.

     "make randconfig"  Create a ./.config file by setting symbol
                        values to random values.

     "make localmodconfig" Create a config based on current config and
                           loaded modules (lsmod). Disables any module
                           option that is not needed for the loaded modules.

                           To create a localmodconfig for another machine,
                           store the lsmod of that machine into a file
                           and pass it in as a LSMOD parameter.

                   target$ lsmod > /tmp/mylsmod
                   target$ scp /tmp/mylsmod host:/tmp

                   host$ make LSMOD=/tmp/mylsmod localmodconfig

                           The above also works when cross compiling.

     "make localyesconfig" Similar to localmodconfig, except it will convert
                           all module options to built in (=y) options.

   You can find more information on using the Linux kernel config tools
   in Documentation/kbuild/kconfig.txt.
```
