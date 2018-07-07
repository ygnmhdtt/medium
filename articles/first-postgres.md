---
title: "PostgreSQLに入門したのでメモ"
date: 2017-06-24T19:00:19+09:00
tags:
- PostgreSQL
---
PostgreSQLを初めて触ったら、コマンドに慣れていなかったので、メモしておく。Dockerを使ってます。

<!--more-->

# ポスグレでよく使うコマンド
 
### ログイン

```
psql -h ホスト -U ユーザ -W
```
-W がパスワード。

-p はポートなので注意(mysqlではパスワード)

# DBを見る

```
\l
```

# DBに入る

```
\c <db_name>
```

# テーブル一覧

```
\d
```

# スキーマを見る

```
\d <table_name>
```

# DB作成

```
Create database database_name encoding ''UTF-8'';
```

# テーブル作成

```
Create table table_name (column_name1 column_type, column_name2 column_type, …);
```

mysqlとけっこう違う。普段mysqlばっかりなんだけど、ポスグレも覚えたいし、慣れたらこっちのほうが早そう。 
