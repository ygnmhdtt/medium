---
title: "DatadogのAPIをrubyから操作する"
date: 2017-06-24T17:08:08+09:00
tags:
- Ruby
- Datadog
---

Datadogを最近業務で使っている。
コンソールの使い方は大体わかってきたので、APIを使ってみることにした。

<!--more-->

### Downtimeを設定する

https://github.com/ygnmhdtt/datadog_downtimeで作ってみた。

```
def set_downtime()
  api_key = ENV[''DD_API_KEY'']
  app_key = ENV[''DD_APP_KEY'']
  dog = Dogapi::Client.new(api_key, app_key)
  start_ts = Time.now.to_i
  end_ts = start_ts + (3 * 60 * 60)
  end_reccurrence_ts = start_ts + (1 * 7 * 24 * 60 * 60)

  recurrence = {
    ''type'' => ''weeks'',
    ''period'' => 1,
    ''week_days'' => [''Fri''],
    ''until_date'' => end_reccurrence_ts
  }

  # Schedule downtime
  dog.schedule_downtime(''any_tag'', :start => start_ts, :end => end_ts, :recurrence => recurrence)
end
```

Datadog、イケてないところもあるんだけど基本的にはすごい良い。
コードベースでもがっつり利用していきたい。
