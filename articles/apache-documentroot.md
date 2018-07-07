---
title: "Apacheのドキュメントルート変更が反映されなかった"
date: 2016-12-06T18:00:00+09:00
tags:
- Apache
---
apacheでgitからcloneしたphpのプロジェクトを動かしたかったのに動かせなくてややハマったのでメモ．
※php関係ないです

<!--more-->

最初にやったこと

cd /etc/apache2
vi http.conf
でhttp.confを

  DocumentRoot "/path/to/project"
  <directory>


のように変更

しかし，apacheのデフォルト画面が出るだけなので，指定がおかしい，もしくは設定ファイルが間違っている．

直し方

which apachectl

の結果が
/usr/sbin/apachectl
でなかった．
macにはapacheがデフォルトで入っている．上記のパスはそのデフォルトのapacheを示す．
これをデフォルトに戻してやればOK.
私の環境では，brew uninstall httpd24でいけました．（以前brewから入れたapacheが悪さしていた．） 
