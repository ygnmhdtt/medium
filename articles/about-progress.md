---
title: "進捗を可視化するスクリプトを作った"
date: 2017-02-01T18:00:00+09:00
tags:
- tools
- bash
- slack
- remote-work
---

スクリプトを作った。

<!--more-->

働き方についてはもう少しやったらいい感じに書きたいと思います。

さて、リモートワークは自己管理が大切です、一人で悩んでいても誰も気づいてくれず、時間の無駄になってしまう。

```
#!/bin/bash
URL=''https://hooks.slack.com/services/token''
MSG=''''
USERNAME=''test''
CHANNEL=''channel_test''
ICON='':bird:''
MSG=`cat task.txt`

payload="payload={
  "channel\": \"${CHANNEL}\",
  "username\": \"${USERNAME}\",
  "text\": \"\`\`\`${MSG}\`\`\`\",
  :icon_emoji\": \"${ICON}\",
}
curl -X POST --data-urlencode "${payload}" $URL
```

webhookの仕様そのままなので、こんな感じです、
進捗は、いろいろ考えたけど、テキストベースで十分、あんまり凝ると辛くなりそう。

そして、これだけだとあれというか、このシェルを毎回実行するのは微妙、コピペすればいいでしょ、という話なので、cronを設定しましょう。
macのcron初めて使った。

```
$ crontab -e
```

でviで

```
* 16 * * 1-5 task.sh
```

2/2 追記↓が正しいです、↑だと16時から17時まで毎分実行される。

0 16 * * 1-5 task.sh

これで平日16時にいい感じにシェルが走って進捗がSlackに連携されます。
毎日やることほどいい感じに手間なくしたい。
