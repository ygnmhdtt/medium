---
title: "RailsでMySQLを使用する時にidの自動採番をリセットしたい"
date: 2016-11-23T18:00:00+09:00
tags:
- Rails
- MySQL
---
RailsではIDがデフォルトでautoIncrementされる

rails generate modelで作ったテーブルは必ずIDカラムがauto_incrementで最初につく．
開発中に動作確認を適当に叩いてるといらないデータができるので，削除したい．
しかし，削除してもidの値はリセットされない．

<!--more-->

### どうするか

mysqlの場合，autoincrementの値はsystem側のテーブルにあるのでそこをいじる．

```
mysql> show databases;

+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+

mysql> use information_schema;
mysql> select * from tables where table_name = ''ここをautoincrementリセットしたいテーブルに変える'';

+----------------+
| auto_increment |
+----------------+
|              8 |
+----------------+
```

これをupdateすればOK.権限は適当に与えてください．
`mysql.information_schema.tables` にこの辺の値があるっぽい．

SQLiteの場合

[http://qiita.com/satomyumi/items/1d90230484051afe409e:embed:cite]
