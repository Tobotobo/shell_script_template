#!/bin/bash

# ./sub へのフルパス
sub_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/sub"

# エラー処理
source "${sub_dir}/error.sh"

# 終了時の処理
source "${sub_dir}/finally.sh"

# 文字色の定義　※例）echo "${red}あいうえお${reset}"
source "${sub_dir}/font_color.sh"

# ログ関連
source ${sub_dir}/log.sh

# パス関連
source "${sub_dir}/path.sh"

# このスクリプトの各種パスを設定　※例) echo "${script_this_fullname}"
set_script_this_paths $(get_caller_script_fullname)

# Util
source "${sub_dir}/util.sh"

# 一時フォルダ関連
source "${sub_dir}/temp_dir.sh"

# タスク関連
source "${sub_dir}/task.sh"

#########################################################################

# -y オプションで実行確認をスキップ可能に
disabled_ask_yes_no=0
for arg in "$@"; do
  case $arg in
    -y)
      disabled_ask_yes_no=1
      ;;
  esac
done

# 実行確認
if (( ! disabled_ask_yes_no )) && ( ! ask_yes_no "${script_root_filename} を実行します。よろしいですか？ [y/n]: " ); then
  # no の場合
  exit_status="CANCEL"
  exit 0
fi

# 処理開始
info "${script_root_filename} の処理を開始しました。"

# .env ファイルの読込
load_env_file

# 一時フォルダを作成
create_temp_dir
