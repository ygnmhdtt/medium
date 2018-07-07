---
title: "何行コード書いたかを可視化するシェルスクリプト"
date: 2017-01-09T18:00:00+09:00
tags:
- tools
- bash
- git
---
タイトルのものを作りました。

<!--more-->

### 何行コード書いたかを可視化しよう

流行りの見える化です
参考URL

作ったもの

https://github.com/ygnmhdtt/countStep

### 中身

````
#!/bin/bash
author=''gitのusername''
today=`date ''+%F''`
month=`date ''+%Y-%m-01''`
year=`date ''+%Y-01-01''`
stepToday=`git log --since=$today --until=$today --author="$author" --oneline --numstat --no-merges --pretty=format:"" | cut -f1 | awk ''BEGIN {sum=0} {sum+=$1} END {print sum}''`
stepMonth=`git log --since=$month --until=$today --author="$author" --oneline --numstat --no-merges --pretty=format:"" | cut -f1 | awk ''BEGIN {sum=0} {sum+=$1} END {print sum}''`
stepYear=`git log --since=$year --until=$today --author="$author" --oneline --numstat --no-merges --pretty=format:"" | cut -f1 | awk ''BEGIN {sum=0} {sum+=$1} END {print sum}''`
```

```
echo "$author は 本日 $stepToday 行書きました。"
echo "今月は合計 $stepMonth 行、今年は合計 $stepYear 行書きました。"
```

authorにはusername(git logしたときに出るやつ)を入れてください。
