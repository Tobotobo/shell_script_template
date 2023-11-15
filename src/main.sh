#!/bin/bash
source ./shared/setup_root_script.sh

# 実行確認
if ask_yes_no "${script_root_filename} を実行します。よろしいですか？ [y/n]: "; then
  # yes の場合
  : # 処理継続
else
  # no の場合
  warn "${script_root_filename} の処理を中断しました。"
  exit 0
fi

##############################################################
# 処理開始
info "${script_root_filename} の処理を開始しました。"

# .env ファイルの読込
load_env_file

# 一時フォルダを作成
create_temp_dir

# hello_world タスクを実行
source ${script_root_dir}/tasks/hello_world.sh

# 一時フォルダを削除
remove_temp_dir

##############################################################
# 処理正常終了
success "${script_root_filename} の処理が完了しました。"
