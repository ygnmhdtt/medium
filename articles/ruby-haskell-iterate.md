---
title: rubyでHaskellのiterate
date: '2016-11-27T18:00:00+09:00'
tags:
- Ruby
- tools
- Haskell
---
Haskellのiterateが便利なので、rubyで書いてみた。

<!--more-->

mapを使えばよかったのだろうか。

```
def iterate(init, &block)
  Enumerator.new do |y|
    loop do
      y << init
      init = block.call(init)
    end
  end
end
```

```
p iterate(1, $:succ).take(10)
[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
```

便利．標準であるべき．
