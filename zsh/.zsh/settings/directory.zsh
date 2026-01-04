# directory stack の設定
DIRSTACKSIZE=100
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

autoload -Uz compinit && compinit

zstyle ':completion:*' menu select
zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*:descriptions' format '%BCompleting%b %U%d%u'

alias d=`dirs -v`
alias dc='dirs -c && print -P "%F{green}directory stack cleared!%f"'
