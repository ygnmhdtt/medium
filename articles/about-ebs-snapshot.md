---
title: "EBSのスナップショットについて学んだ"
date: 2017-11-08T21:57:55+09:00
tags:
- AWS
- EBS
- snapshot
- backup
---
EBSのスナップショットの増分とか、リストアについて学んだ。

<!--more-->

こういう問題について考えていた。
```
Which of the following approaches provides the lowest cost for Amazon Elastic Block Store snapshots while giving you the ability to fully restore data?

A. Maintain two snapshots: the original snapshot and the latest incremental snapshot.

B. Maintain a volume snapshot; subsequent snapshots will overwrite one another

C. Maintain a single snapshot the latest snapshot is both Incremental and complete.

D. Maintain the most current snapshot, archive the original and incremental to Amazon Glacier.
```


訳すとこんな感じ。

```
Amazon Elastic Block Storeスナップショットのコストを最小限に抑えながら、データを完全に復元できる次のアプローチはどれか？
A. 元のスナップショットと最新の増分スナップショットの2つのスナップショットを維持する
B. ボリュームスナップショットを維持する。後続のスナップショットは互いに上書きされる
C. 単一のスナップショットを維持する、最新の増分スナップショットが増分であり完全である
D. 最新のスナップショットを維持し、オリジナルと増分をAmazon Glacierにアーカイブする
```

この問題、結論としては答えはCなんだけど、最新のスナップショットだけでいいのか？と疑問に思った。
というのは、EBSは基本的に2回目以降のスナップショットの取得は増分になる。
例えば、50GBあるEBSのスナップショットを取る時、初回は50GBぶんのスナップショットを取る。
その後5GB増えた時、次のスナップショットは増分の5GBのみとなる。
だから、最新のスナップショットだけ残していては、途中のスナップショットが歯抜的にバックアップできないのでは？と考えてしまった。

# 仕組みについて

そもそも、ドキュメントに以下のような記述がある。

```
スナップショットの保存は増分ベースで行われるものの、最新のスナップショットさえあればボリュームを復元できるようにスナップショット削除プロセスは設計されています。
```

仕組みがこちらに書いてあった。

S3に実際に保存されているスナップショットと、我々ユーザから見えているスナップショット(概念)は実は異なっていることがわかる。
実際にS3に保存されているのは文字通り 増分 であるが、概念としてのスナップショットでは各時点での 全分 が保存されている。
スナップショットの削除 という行為は、S3からのファイル削除ではなく、 概念 の削除を行っている。(そもそもS3を見てもスナップショットは見られないようになっている。)
そして、概念を削除しても、別の時点での概念にその増分が必要とされている場合、S3からは削除されない。(図中 A のように、必要とされていないデータは本当に消える。)
逆に言うと、スナップショットを削除したつもりでも、S3への保管のコストがなくなるとは限らない、ということ。(だからEBSスナップショットは安い)

# まとめ

Cのように、最新のスナップショット(概念)さえあれば、全部元に戻せる。

# ちなみに

Dのように、Glacierに明示的に保存することはできない。内部で勝手にS3に保管される。
