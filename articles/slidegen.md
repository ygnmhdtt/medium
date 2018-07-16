---
title: Generate presentation slide on commandline
date: 2018-07-16T21:17:37+09:00
tags:
- tools
- markdown
---

Hi, I'm software developer living in medium, yagi.
We developers sometimes need to create slides for presentation, talking at conferences.
Always, how do you create it? There are several ways, [marp](https://yhatt.github.io/marp/), [remarkjs](https://remarkjs.com/#1), and so on.
If you used to use markdown and commandline, you can try [slidegen](https://github.com/ygnmhdtt/slidegen). Yes, I am an author of it.

---

# Simple and minimal command

![](https://github.com/ygnmhdtt/slidegen/blob/master/samples/demo.gif)

All you have to do is specifying file name just like this.

```sh
$ slidegen your/markdown/file.md
```

Then, you can get output.pdf at your current directory.

---

# Markdown format

All markdown syntaxes are supported that are introduced [here](https://guides.github.com/features/mastering-markdown/).
Delimiter of each page is `---` .

---

# PDF style

The simplest and easiest-to-read markdown style, GFM(github-flavored-markdown) will be applied on your PDF.
Always I need only it, but if you want to use another css, please fork and customize it.

---

# Import from Gist

You can import from Gist URL. Just give `-g` option like

```sh
$ slidegen -g https://gist.github.com/
```

Of course, gist must contain `---` for each page delimiter

---

# Please try

I want you to use it and, if you like, please star it.
If any problems or feedback, please create a [issue](https://github.com/ygnmhdtt/slidegen/issues).
Pull requests are always welcome!

---

# Finally

I created slide from this entry. (PDF cannot be posted on medium, I converted into images.)

![](https://github.com/ygnmhdtt/slidegen/blob/master/medium/1.png)
![](https://github.com/ygnmhdtt/slidegen/blob/master/medium/2.png)
![](https://github.com/ygnmhdtt/slidegen/blob/master/medium/3.png)
![](https://github.com/ygnmhdtt/slidegen/blob/master/medium/4.png)
![](https://github.com/ygnmhdtt/slidegen/blob/master/medium/5.png)

