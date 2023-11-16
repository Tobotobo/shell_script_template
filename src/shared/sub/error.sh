# -e: スクリプト内のコマンドが失敗したとき（終了ステータスが0以外）にスクリプトを直ちに終了する
# -E: '-e'オプションと組み合わせて使用し、サブシェルや関数内でエラーが発生した場合もスクリプトの実行を終了する
# -u: 未定義の変数を参照しようとしたときにエラーメッセージを表示してスクリプトを終了する
# -o pipefail: パイプラインの左辺のコマンドが失敗したときに右辺を実行せずスクリプトを終了する
set -eEuo pipefail
shopt -s inherit_errexit # '-e'オプションをサブシェルや関数内にも適用する

# エラーハンドリング
# https://zenn.dev/liqsuq/articles/99acdab5b02ff5
# https://nikkie-ftnext.hatenablog.com/entry/set-e-and-trap-are-enough-no-need-exit
# https://gist.github.com/akostadinov/33bb2606afe1b334169dfbf202991d36?permalink_comment_id=4726328#gistcomment-4726328
function on_error() {
    exit_status=ERR

    local err_command=${BASH_COMMAND}
    local -a stack=("")
    local stack_size=${#FUNCNAME[@]}
    local -i i
    for (( i = 1; i < stack_size; i++ )); do
      local func="${FUNCNAME[$i]:-(top level)}"
      local -i line="${BASH_LINENO[$(( i - 1 ))]}"
      local src="${BASH_SOURCE[$i]:-(no file)}"
      stack+=("  at $func $src:$line")
    done
    (IFS=$'\n'; error "${err_command}${stack[*]}")
}

function enable_on_error() {
  trap on_error ERR
}

function disable_on_error() {
  trap - ERR
}



# エラーを発生させる　※例）raise 〇〇の処理に失敗しました。
function raise() {
  error "$1">&2
  # echo "${red}$(date +"%Y/%m/%d %H:%M:%S") [ERROR] $1${reset}">&2
  return 1
}

function has_error() {
  return 0
}

#######################################################################

enable_on_error
