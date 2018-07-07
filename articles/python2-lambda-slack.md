---
title: "Python2でAWSLambdaからSlack通知をするための最低限のコード"
date: 2017-06-19T10:22:59+09:00
tags:
- AWS
- AWS Lambda
- Python2.7
- slack
---
検証のために、Lambdaから最低限のコードでSlack通知を行いたかったので、メモ。

<!--more-->

### コード

```
#-*- coding:utf-8 -*-
from urllib import urlencode
from urllib2 import Request, urlopen
import json

SLACK_POST_URL = "https://hooks.slack.com/services/XXXXXXXXXXXXXXXXXXXXXXXXXXXX"

def lambda_handler(event, context):
    post()

def post():
    slack_message = {
        ''channel'': ''test_channel'',
        ''text'': ''test_message'',
        ''username'': ''test_username'',
        ''icon_emoji'': '':smile:''
    }
    req = Request(SLACK_POST_URL, json.dumps(slack_message))
    response = urlopen(req)
```

これで、SLACK_POST_URL と slack_message だけいい感じに変えれば動きます。あとで使いそうな気がしたので、メモ。
