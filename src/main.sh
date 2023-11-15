#!/bin/bash
source ./shared/setup_root_script.sh

# 実行確認
if ! ask_yes_no "${script_root_filename} を実行します。よろしいですか？ [y/n]: "; then
  # no の場合
  warn "${script_root_filename} の処理を中断しました。"
  exit 0
fi

##############################################################
# 処理開始
info "${script_root_filename} の処理を開始しました。"

# 終了時の処理を登録
function finally() {

  # 一時フォルダを削除
  remove_temp_dir
  err=1
  # 完了メッセージを表示
  if ${err}; then
    error "${script_root_filename} の処理中にエラーが発生しました。"
  else
    success "${script_root_filename} の処理が完了しました。"
  fi
}
trap finally EXIT

# .env ファイルの読込
load_env_file

# 一時フォルダを作成
create_temp_dir

# hello_world タスクを実行
call_task hello_world
# source ${script_root_dir}/tasks/hello_world.sh

