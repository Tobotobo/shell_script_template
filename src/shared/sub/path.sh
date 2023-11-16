# 指定されたパスの絶対パスを返す
function get_fullname() {
  echo $(cd $(dirname $1); pwd)/$(basename "$1")
}

# 指定されたパスからフォルダパスを返す
function get_dir() {
  echo $(dirname "$1")
}

# 指定されたパスからファイル名を返す
function get_filename() {
  echo $(basename "$1")
}

# 指定されたパスからファイル名(拡張子無し)を返す
function get_filename_without_ext() {
  echo $(basename "${1%.*}")
}

# 呼び出し元のスクリプトのフルパスを取得する
function get_caller_script_fullname() {
  echo "$(get_fullname "${BASH_SOURCE[0]}")"
}

# 指定のパスを各 script_this_XXXX に設定する
function set_script_this_paths() {
  local path="$1"

  # 呼び出し元のスクリプトのフルパス
  script_this_fullname=$(get_fullname "${path}")

  # 呼び出し元のスクリプトがあるフォルダのフルパス
  script_this_dir=$(get_dir "${script_this_fullname}")

  # 呼び出し元のスクリプトファイル名
  script_this_filename=$(get_filename "${script_this_fullname}")

  # 呼び出し元のスクリプトファイル名（拡張子を除く）
  script_this_filename_without_ext=$(get_filename_without_ext "${script_this_fullname}")
}

#################################################################################

# root スクリプトのフルパス
readonly script_root_fullname=$(get_fullname "$0")

# root スクリプトがあるフォルダのフルパス
readonly script_root_dir=$(get_dir "${script_root_fullname}")

# root スクリプトファイル名
readonly script_root_filename=$(get_filename "${script_root_fullname}")

# root スクリプトファイル名（拡張子を除く）
readonly script_root_filename_without_ext=$(get_filename_without_ext "${script_root_fullname}")
