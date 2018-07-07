---
title: "MySQLでViewのdefinerエラーが出た際の対応"
date: 2017-11-02T13:30:33+09:00
tags:
- MySQL
---
ちょこちょこ見るやつを、ちゃんと理解して、ちゃんと対応した。メモ。

<!--more-->

### 発生した事象

MySQLからdumpをとるために、以下のようなコマンドを叩いた。

```
mysqldump -u user -p --no-data db > db_schema.dump
```

すると、以下のようなエラーが出た。

```
mysqldump: Got error: 1449: The user specified as a definer (''user2''@''%'') does not exist when using LOCK TABLES
```

### これはなにか？

これは要するに、viewのdefinerとして存在すべきユーザ user2 が存在していないよ！というエラー。
viewはテーブルみたいなものだが、ちょっと違う。viewがわからない場合はこことかを参照。
viewにはdefinerという概念があるが、  user でアクセスすると user2 をdefinerとするviewはダンプできないらしい。

### 対応策

まず、tableでなくviewになっているのはどれなのか、以下のコマンドで確認する。

```
show table status;
```

長くなるのでここには貼らないが、一番右の Comment に VIEW とあるやつがあるはず。それがview.

次に、viewのdefinerを確認する。
view名が test_view の場合、以下のコマンドをたたく。

```
show create table test_view;
```

すると、viewの定義が見られる。

```
(前略)
CREATE ALGORITHM=UNDEFINED DEFINER=`user2`@`%` SQL SECURITY DEFINER VIEW `test_view` AS select
(後略)
```

やはり、definer=user2になっている。
これを、 user になおしてやる。
上の CREATE ALGORHITHM のSQL文を最後までコピペし、以下のように変える。

```
(前略)
ALTER ALGORITHM=UNDEFINED DEFINER=`user`@`%` SQL SECURITY DEFINER VIEW `test_view` AS select
(後略)
```

変えたのは最初のCREATEを ALTER に変えたのと、 DEFINER=user にするのみ。
これをすべてのviewに対して行う。

これで最初のmysqldumpを叩くと、正常にイケルはず。
