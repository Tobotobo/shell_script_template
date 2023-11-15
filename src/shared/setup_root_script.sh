#!/bin/bash

# -e: スクリプト内のコマンドが失敗したとき（終了ステータスが0以外）にスクリプトを直ちに終了する
# -E: '-e'オプションと組み合わせて使用し、サブシェルや関数内でエラーが発生した場合もスクリプトの実行を終了する
# -u: 未定義の変数を参照しようとしたときにエラーメッセージを表示してスクリプトを終了する
# -o pipefail: パイプラインの左辺のコマンドが失敗したときに右辺を実行せずスクリプトを終了する
set -eEuo pipefail
shopt -s inherit_errexit # '-e'オプションをサブシェルや関数内にも適用する

# 文字に色を付ける　※例）echo "${red}あいうえお${reset}"
red=$(printf '\033')[31m     # 赤
green=$(printf '\033')[32m   # 緑
yellow=$(printf '\033')[33m  # 黄
blue=$(printf '\033')[34m    # 青
magenta=$(printf '\033')[35m # マゼンタ
cyan=$(printf '\033')[36m    # シアン
reset=$(printf '\033')[00m   # リセット

# 呼び出し元のスクリプトがあるフォルダのフルパス
script_root_dir=$(cd $(dirname $0); pwd)

# 呼び出し元のスクリプトファイル名
script_root_filename=$(basename "$0")

# 呼び出し元のスクリプトファイル名（拡張子を除く）
script_root_filename_without_ext=$(basename "${0%.*}")

# エラーハンドリング
# https://zenn.dev/liqsuq/articles/99acdab5b02ff5
# https://nikkie-ftnext.hatenablog.com/entry/set-e-and-trap-are-enough-no-need-exit
function on_error() {
    echo "${red}$(date +"%Y/%m/%d %H:%M:%S") [ERROR] ${BASH_SOURCE[1]}:${BASH_LINENO} - '${BASH_COMMAND}'${reset}">&2
}
trap on_error ERR

# エラーを発生させる　※例）error 〇〇の処理に失敗しました。
function error() {
  echo "${red}$(date +"%Y/%m/%d %H:%M:%S") [ERROR] $1${reset}">&2
  return 1
}

# 失敗メッセージを表示する　※表示のみでエラーは発生させない
function ng() {
  echo "${red}$(date +"%Y/%m/%d %H:%M:%S") [NG] $1${reset}"
}

# 警告メッセージを表示する
function warn() {
  echo "${yellow}$(date +"%Y/%m/%d %H:%M:%S") [WARN] $1${reset}"
}

# 成功メッセージを表示する
function success() {
  echo "${green}$(date +"%Y/%m/%d %H:%M:%S") [SUCCESS] $1${reset}"
}

# 成功メッセージを表示する
function ok() {
  echo "${green}$(date +"%Y/%m/%d %H:%M:%S") [OK] $1${reset}"
}

# 情報メッセージを表示する
function info() {
  echo "${cyan}$(date +"%Y/%m/%d %H:%M:%S") [INFO] $1${reset}"
}

# ログを表示する　※装飾無し用
function log() {
  echo "$(date +"%Y/%m/%d %H:%M:%S") $1"
}

# 指定の文言で y/n の入力を取得する
# 戻り値: y = 0, n = 1
# y/n 以外の入力は再入力を求める
function ask_yes_no {
  while true; do
    echo -n "${magenta}$(date +"%Y/%m/%d %H:%M:%S") [ASK] $*${reset}"
    read ans
    case $ans in
      [Yy]*)
        return 0
        ;;
      [Nn]*)
        return 1
        ;;
      *)
        echo "${red}y または n を入力してください。${reset}"
        ;;
    esac
  done
}

# 呼び出し元のスクリプトの直下にある .env を読み込む
function load_env_file() {
  info ".env の読み込みを開始しました。"

  env_file_path=${script_root_dir}/.env
  if [[ -f "${env_file_path}" ]]; then
    $(source "${env_file_path}")
    success ".env の読み込みが完了しました。"
  else
    warn ".env が見つかりません。.env の読み込みをスキップしました。"
  fi
}

# 一時フォルダパスの初期化　※create_temp_dir()で設定
temp_dir=

# /tmp 内に一時フォルダを作成する
function create_temp_dir() {
  info "一時フォルダの作成を開始しました。"

  if [ -d "$temp_dir" ]; then
    warn "既に作成済みです。"
  else
    temp_dir=$(mktemp -d /tmp/${script_root_filename_without_ext}.XXXXXX)
    echo $temp_dir
    success "一時フォルダの作成が完了しました。"
  fi
}

# 一時フォルダを削除する
function remove_temp_dir() {
  if [ -d "$temp_dir" ]; then
    info "一時フォルダの削除を開始しました。"
    echo $temp_dir
    rm -r "$temp_dir"
    if [ $? -eq 0 ]; then
        success "一時フォルダの削除が完了しました。"
    else
        error "一時フォルダの削除に失敗しました。"
    fi
  fi
}

# 一時フォルダを作成していた場合は終了時に削除
trap remove_temp_dir EXIT




