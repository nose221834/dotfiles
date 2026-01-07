# brewのパスを追加
export PATH="/opt/homebrew/bin:$PATH"
# .zsh/settings/app.zsh

function brew() {
    # 1. コミットメッセージ用に実行コマンド全体を文字列として取得
    local commit_msg="brew $*"

    # 本来のbrewを実行
    command brew "$@"
    local exit_code=$?

    local brewfile="$HOME/Brewfile"

    if [[ $exit_code -eq 0 ]]; then
        case "$1" in
            install|uninstall|remove|tap|untap|reinstall)
                # シンボリックリンクを解決して、実体のパスを取得 (:A は zsh 特有の修飾子)
                local real_brewfile="${brewfile:A}"
                # 実体のあるディレクトリを取得
                local repo_dir="${real_brewfile:h}"

                # 親ディレクトリ作成 (実体のディレクトリに対して)
                mkdir -p "$repo_dir"

                printf "\n\033[1;32m==>\033[0m Updating Brewfile...\n"

                # 実体のパスに対して dump する
                command brew bundle dump --force --describe --file="$real_brewfile"
                local dump_code=$?

                if [[ $dump_code -eq 0 ]]; then
                    printf "\033[1;32m==>\033[0m Brewfile updated!\n"

                    # --- Git操作ブロック ---
                    # 変更があるか確認 (実体のディレクトリで実行)
                    if [[ -n $(git -C "$repo_dir" status --porcelain "$real_brewfile") ]]; then
                        printf "\033[1;32m==>\033[0m Committing and Pushing to Git...\n"
                        printf "    Repo: %s\n" "$repo_dir"

                        git -C "$repo_dir" add "$real_brewfile"
                        git -C "$repo_dir" commit -m "$commit_msg"
                        # ここでupstreamエラーが出るなら、対症療法として origin main を指定することも可能
                        # git -C "$repo_dir" push origin main
                        git -C "$repo_dir" push origin main

                        printf "\033[1;32m==>\033[0m Done!\n"
                    else
                        printf "\033[1;30m==>\033[0m No changes to commit.\n"
                    fi
                    # --- Git操作ブロック終了 ---

                else
                    printf "\033[1;33m==>\033[0m Brewfile update failed (kept brew exit code = %d)\n" "$exit_code" >&2
                fi
                ;;
        esac
    fi

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

# zoxideの初期化
eval "$(zoxide init zsh --cmd cd)"

# fzfの初期化
source <(fzf --zsh)
