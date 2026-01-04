HISTSIZE=10000
SAVEHIST=10000
# WSL で HISTFILE が正しく設定されないため明示的に設定
# WSL 以外の環境では設定しなくても問題ない
HISTFILE="$HOME/.zsh_history"

# .zsh_hisroty に追記する設定
# 複数の zsh を同時に使う時など HISTFILE に上書きせず追加する
# default on
# setopt append_history

# コマンドの実行時刻を記録する
setopt extended_history

# いつ append するのか
# inc_append_history: 実行時に HISTFILE に追加
# inc_append_history_time: 実行終了時に実行時間と共に HISTFILE に追加
# share_history: inc_append_history + 他ターミナルでの実行を即座に反映
# が排他的な設定
# terminal 毎に履歴が残った方が嬉しいこともある + 実行時間は知りたいため inc_append_history_time
setopt inc_append_history_time

# 履歴の数が上限に達した時、古いもの以前に重複しているものを削除する
setopt hist_expire_dups_first

# 重複するコマンドは新しい方のみを記録する
setopt hist_ignore_all_dups

# 重複するコマンドは新しい方のみを HISTFILE に保存する
# 直前のコマンドをパッと使いたいケースが多いので設定しない
# setopt hist_save_no_dups

# history 参照コマンドを履歴として残さない
setopt hist_no_store

# スペースで始まるコマンド行は履歴として残さない
setopt hist_ignore_space

# search history の 関数
function h() {
    if [ -n "$1" ]; then
        # 引数がある場合: その文字で grep 検索
        history -i 0 | grep "$@"
    else
        # 引数がない場合: 履歴全体を表示
        history -i 0
    fi
}
