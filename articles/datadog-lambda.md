---
title: "DatadogからLambdaを叩く"
date: 2017-09-22T18:01:35+09:00
tags:
- Datadog
- Python2.7
- AWS Lambda
- Twilio
---
DatadogからLambdaをたたくまで、まあまあ苦労したのでまとめておく。

<!--more-->

今日、弊社ブログで[こういう記事](https://blog.mmmcorp.co.jp/blog/2017/06/02/starting-datadog/)を書いた。
システム監視の一環で、DDからアラートが上がった時に担当者にに電話をかけたい、というのがやりたいこと。
これは内部的な仕組みとして、DDのアラートがWebhookを飛ばす -> CloudFront -> API Gateway -> Lambda という流れになっている。

# CloudFrontを使う

こちらを参考に、CloudFrontを使ってAPI Gatewayを叩いている。
DDのWebhookは暗号化プロトコルにSSLv3を使っているので、(イケてない)API Gatewayを直接叩くことができない。
そのため、API Gatewayの前段にCloudFrontをかませている。

# 日本語を送る

日本語の送信で、色々ハマってしまった。試行錯誤の結果、以下のようなやり方を取った。
* DD側でURLエンコーディングしてフックする
* Lambda側でデコードして日本語を使う

# DD側でURLエンコーディング

これは簡単で、 Integrations Webhook からエンコーディングにチェックを入れる。

# Lambdaでの扱い方

API Gatewayのログ(Request Body)を見ると以下のような感じになっていた。

```
event_type=query_alert_monitor&alert_id=XXXXXXXX&alert_transition=Recovered&date=1505904673000&alert_title=%E3%83%87%E3%82%A3%E3%82%B9%E3
```

URLエンコーディングしてなければJSONでポストされ、Pythonではdict型で扱える。
しかし、URLのクエリパラメータとして来る場合は、以下のようにすると扱いやすい。(Python2.7です。)

```
import urlparse
import urllib

def handle(event, context):
    // この時点ではeventはdict
    request = str(event[''body''])
    // クエリパラメータをパース
    params = urlparse.parse_qs(request)
    event_type_encoding = params[''event_type''][0]
    // デコード
    event_type_decoded = urllib.unquote(event_type_encoding)
```

こうするとデコードして、日本語がされることを日本語として扱える。
Pythonの符号化方式周りはハマることが多くてつらい。
