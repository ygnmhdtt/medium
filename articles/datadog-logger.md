---
title: "Datadog専用のLoggerをGoで作った"
date: 2017-10-23T20:32:26+09:00
tags:
- tools
- Golang
- Datadog
---
Datadogのログ監視用にloggerを作った。

<!--more-->

[ddlog_go](https://github.com/ygnmhdtt/ddlog_go)にソースがある。

Datadogのログフォーマットは

```
metric unix_timestamp value [attribute1=v1 attributes2=v2 ...]
```


こんな感じでないといけない。もしこのフォーマットでないログを監視したいときは、自分でカスタムパーサを書く必要がある。しかし、この世のほとんどのログはこのフォーマットになってないと思う。(たぶん)
なので、はじめからこのフォーマットでログを出しとけばいいじゃん！という用途に使う。

READMEの通り、

```
package main

import (
  "os"
  "github.com/ygnmhdtt/ddlog_go
)

func main() {
  // You can specify metric_name and where to output
  ddl := ddlog_go.NewddLogger("test.metric", os.Stderr)

  // Set attributes
  ddl.Attr("env", "production")

  // This line prints "test.metric 967809600 1 loglevel=INFO env=production"
  ddl.INFO("1") 
  // This line prints "test.metric 967809601 2 loglevel=WARN env=production"
  ddl.WARN("2")

  // ClearAttr clears all attributes
  ddl.ClearAttr()

  // This line prints "test.metric 967809600 1 loglevel=INFO env=production hoge=fuga"
  ddl.Attr("env", "production").Attr("hoge", "fuga").INFO("1")
}
```

こんなふうに使う。