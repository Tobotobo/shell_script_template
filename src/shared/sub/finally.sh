exit_status=""
finally_function=""
last_exit_status=0

# 指定された関数が終了時に呼び出されるよう登録する
function set_finally_function() {
  finally_function=$1
}

# 終了時の処理を登録
function on_exit() {
  last_exit_status=$?

  # 実行自体がキャンセルされた場合は終了処理も実行せず終了する
  if [[ "$exit_status" == "CANCEL" ]]; then
    info "${script_root_filename} の処理を中断しました。"
    exit 0
  fi

  # 処理開始メッセージ
  info "${script_root_filename} の終了処理を開始しました。"

  # サブシェルから exit_status を書き換えられないため終了コードで補完
  if [[ "$exit_status" == "" ]] && (( last_exit_status != 0 )); then
    exit_status=ERR
  fi

  # 終了時に呼び出される関数に登録がある場合は当該関数を実行
  if [[ "$finally_function" != "" ]]; then
    $finally_function
  fi

  # 一時フォルダを削除
  remove_temp_dir

  ## 処理終了メッセージ
  success "${script_root_filename} の終了処理が完了しました。"

  # 完了メッセージを表示
  case $exit_status in
    ERR)
      ng "${script_root_filename} の処理中にエラーが発生しました。"
      ;;
    SIGINT)
      warn "${script_root_filename} の処理を中断しました。"
      ;;
    SIGQUIT)
      warn "${script_root_filename} の処理を中断しました。"
      ;;
    "")
      success "${script_root_filename} の処理が完了しました。"
      ;;
    *)
      warn "${script_root_filename} は exit_status=${exit_status} により処理を中断しました。"
      ;;
  esac

  exit $last_exit_status
}
trap on_exit EXIT

# プロセスに再起動を通知する。デーモンのリセットに使用される。
function on_sigiup() {
  exit_status=SIGHUP
  exit 0
}
trap on_sigiup SIGHUP

# プロセスに割り込みを通知する。Ctrl+Cを押したときに発生する。
function on_sigint() {
  exit_status=SIGINT
  exit 0
}
trap on_sigint SIGINT

# プロセスに終了を通知する。Ctrl+\ を押したときに発生する。
function on_sigquit() {
  exit_status=SIGQUIT
  exit 0
}
trap on_sigquit SIGQUIT

# プロセスに終了を通知する。killコマンドはデフォルトでこのシグナルを指定している。
function on_sigterm() {
  exit_status=SIGTERM
  exit 0
}
trap on_sigterm SIGTERM
