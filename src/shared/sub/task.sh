# 指定のタスクを実行する
function call_task() {
    local task_name=$1
    info "${task_name} タスクの実行を開始しました。"
    local task_path="${script_root_dir}/tasks/${task_name}/main.sh"
    disable_on_error
    (
      enable_on_error
      set_script_this_paths ${task_path}
      source ${task_path}
    )
    enable_on_error
    # source ${task_path}
    success "${task_name} タスクの実行が完了しました。"
}


