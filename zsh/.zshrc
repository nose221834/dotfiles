# beep音を無効化
setopt no_beep
setopt nolistbeep

# Sheldon (プラグイン管理)
SHELDON_CONFIG_FILE="$HOME/.config/sheldon/plugins.toml"
eval "$(sheldon source)"

# プロンプトのコマンド置換を有効化
setopt prompt_subst

# 保管を有効にする
# -U: do not override by user defined alias.
# -z: read by zsh rules.
autoload -Uz compinit && compinit
autoload -U +X bashcompinit && bashcompinit

# .zshフォルダの中身を読み込む
for conf in "$HOME/.zsh/settings/"*.zsh; do
    source "${conf}"
done
unset conf

# starshipプロンプトを有効化
eval "$(starship init zsh)"
