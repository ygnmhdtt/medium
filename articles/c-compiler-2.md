---
title: "Cコンパイラ 2 ASTの実装"
date: 2018-03-25T22:42:20+09:00
tags:
- C
- compiler
- AST
---

抽象構文木を実装した。

<!--more-->

[こんな感じ](https://github.com/ygnmhdtt/rocket/commit/6c53d61c5b7c52d645084a718f4460318cc398f1)で実装した。

Astをtypedefで実装。

```
typedef struct Ast {
  char type; //
  union {
    int ival;
    char *sval;
    struct {
      struct Ast *left;
      struct Ast *right;
    };
  };
} Ast;
```

使用している箇所のロジックは[この辺](https://github.com/ygnmhdtt/rocket/commit/6c53d61c5b7c52d645084a718f4460318cc398f1#diff-2045016cb90d1e65d71c2407a2570927R98)。
乗算/除算のときはASTの作る順番を変える必要があるとか、そういうのの実装が難しい。
Cじゃなかったらもっといい感じに書けるよなあ、、と思いつつ、セルフコンパイルしたいので頑張る。

まだ8ccをなぞっている感じだけど、ASTを使えるようになって色々構造化できそうなので、頑張りたい。気が済むまでは続けていく。
