---
title: "ターミナル周りの見た目をかっこよくする"
date: 2018-02-27T17:47:18+09:00
tags:
- tools
- tmux
- vim
- zsh
- prompt
---

かっこよくした。

<!--more-->

### 成果物

* tmuxとzsh

![](/images/prompt-tmux-vim-looking-customize/1.png)

* vim

![](/images/prompt-tmux-vim-looking-customize/2.png)

### 道のり

最初は[powerline](https://github.com/powerline/powerline)を使おうと思ったんだけど、
見た目を返るだけでこれは大げさかな、、と思って辞めた。
ロードアベレージとか天気とか出す必要ないし、このくらいなら自分でなんとかなるだろうと思ってつくってみた。

### zsh

```sh
# git prompt
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{255}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{255}+"
zstyle ':vcs_info:*' formats "%F{255}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
function precmd () { vcs_info }

# zsh prompt
# %K{num}: background color
# %F{num}: characters color
# %f{num}: resetcharacters color
# %k{num}: reset background color
# color sample script:
# for c in {000..255}; do echo -n "\e[38;5;${c}m $c" ; [ $(($c%16)) -eq 15 ] && echo;done;echo
export PROMPT='
%K{099}%F{255} gentoo %f%k'
export PROMPT=$PROMPT'%K{020}%F{099}%f%k'
export PROMPT=$PROMPT'%K{020}%F{051} %~ %f%k'
export PROMPT=$PROMPT'`git_dir_check ${vcs_info_msg_0_} $?`
%F{255} ↬ %f '

function git_dir_check () {
  if [ -e .git ]; then
    local color='002'
    case `echo $1 | sed -E s/.+}// | cut -c 1` in
      "!" ) color='003' ;;
      "+" ) color='001' ;;
    esac
    msg="%K{${color}}%F{020}%f%k"
    msg=$msg"%K{${color}} $1 %k%F{${color}}%f"
  else
    msg='%F{020}%f'
  fi
    echo $msg
}
```

zshの機能を使って、stageしてないファイルがある時や、コミットしてないファイルが有るときなどに色を分けることができる。

### tmux

```
## left
set -g status-left '#[fg=colour255,bg=colour248]#{?client_prefix,#[reverse],} tmux #[default]#[fg=colour248,bg=black]#[default]  '

# right
set -g status-right "#[fg=colour255]%Y-%m-%d(%a) %H:%M#[default]"

# window-status
set-window-option -g window-status-format "#[fg=colour250] #I > #W #[default]"

# current-window-status
set-window-option -g window-status-current-format "#[fg=black,bg=colour039]#[default]#[fg=colour236,bg=colour039] #I > #W #[default]#[fg=colour039,bg=black]#[default]"
```

### vim

[lightline.vim](https://github.com/itchyny/lightline.vim)を使っているだけ。
カラースキーマには `jellybeans` を使っている。

### 所感

こういうのは、そもそもどういうデザインにするかを考えるのが難しい。
見やすく、かっこよく、シンプルで、メンテナンスしやすいものを作るのは大変。
