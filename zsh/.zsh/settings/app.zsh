# brewのパスを追加
export PATH="/opt/homebrew/bin:$PATH"
# .zsh/settings/app.zsh

function brew() {
    # 本来のbrewを実行
    command brew "$@"
    local exit_code=$?

    local brewfile="$HOME/Brewfile"

    # 成功時のみ & 構成変更っぽい操作のみ
    if [[ $exit_code -eq 0 ]]; then
        case "$1" in
            install|uninstall|remove|tap|untap|reinstall)
                # 親ディレクトリ作成（ないとdumpが失敗する）
                mkdir -p "${brewfile:h}"

                printf "\n\033[1;32m==>\033[0m Updating Brewfile...\n"
                # ラッパーを避けて確実に本物のbrewを呼ぶ
                command brew bundle dump --force --describe --file="$brewfile"
                local dump_code=$?

                if [[ $dump_code -eq 0 ]]; then
                    printf "\033[1;32m==>\033[0m Brewfile updated!\n"
                else
                    # ここで失敗しても、元のbrew成功を“失敗扱いにしない”
                    printf "\033[1;33m==>\033[0m Brewfile update failed (kept brew exit code = %d)\n" "$exit_code" >&2
                fi
                ;;
        esac
    fi

    # 重要：brew本体の終了コードを返す
    return $exit_code
}


# goのパスを追加
export PATH=$PATH:`go env GOPATH`/bin

# nvm(nodejs)のパスを追加
export NVM_DIR="$HOME/.nvm"
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
    [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# condaのパスを追加
__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup

# mise（バージョン管理ツール）のパスを追加
eval "$(mise activate zsh)"

# ezaのaliasを設定
if command -v eza >/dev/null 2>&1; then
    # 基本のls: アイコン付き、グループ化表示
    alias ls='eza --icons --git'

    # 詳細表示 (ll): 詳細(-l), ヘッダー付(+h), Git状況(--git), グリッド表示
    alias l='eza -l --icons --git -h'

    # 全ファイル表示 (la): 隠しファイル含む(-a)
    alias la='eza -la --icons --git -h'

    # ツリー表示 (lt): 深さ2階層まで表示
    alias lt='eza --tree --level=2 --icons'
fi
