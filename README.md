# shell_script_template

## 概要
Shell スクリプトを作成する際の基本構成を作成する。

- bash
- .env 読み込み
- Logger
- エラーハンドリング
- 一時フォルダの作成・削除
- タスク分割
- 確認メッセージをパラメータ -y で省略可能

## 使い方概要
- tasks フォルダ内に、タスク名でフォルダを作る
- 上記フォルダ内に main.sh を作成し、実行したい処理を記述する  
  ※ ファイル名は main.sh 固定
- src フォルダ直下の main.sh (※ファイル名は任意) から上記タスクを呼び出す  
  ```sh
  #!/bin/bash
  source "$(dirname "$0")/shared/setup_root_script.sh"

  # 各タスクを実行
  call_task hello_world
  ```
- タスクは tasks フォルダ内にいくらでも作れるので、良い感じに分けて作成すること
- 上記のファイルを実行すると以下のようになる  
  ```log
  $ ./main.sh
  2023/11/16 14:30:57 [ASK] main.sh を実行します。よろしいですか？ [y/n]: y
  2023/11/16 14:31:04 [INFO] main.sh の処理を開始しました。
  2023/11/16 14:31:04 [INFO] .env の読み込みを開始しました。
  2023/11/16 14:31:04 [SUCCESS] .env の読み込みが完了しました。
  2023/11/16 14:31:04 [INFO] 一時フォルダの作成を開始しました。
  2023/11/16 14:31:04 /tmp/main.vXaZkw
  2023/11/16 14:31:04 [SUCCESS] 一時フォルダの作成が完了しました。
  2023/11/16 14:31:04 [INFO] hello_world タスクの実行を開始しました。
  2023/11/16 14:31:05 /d/Projects/shell_script_template/src/tasks/hello_world/main.sh
  2023/11/16 14:31:05 Hello World!1
  2023/11/16 14:31:05 東京 太郎
  2023/11/16 14:31:05 Hello World!2
  2023/11/16 14:31:05 [SUCCESS] hello_world タスクの実行が完了しました。
  2023/11/16 14:31:05 [INFO] main.sh の終了処理を開始しました。
  2023/11/16 14:31:05 [INFO] 一時フォルダの削除を開始しました。
  2023/11/16 14:31:05 /tmp/main.vXaZkw
  2023/11/16 14:31:05 [SUCCESS] 一時フォルダの削除が完了しました。
  2023/11/16 14:31:05 [SUCCESS] main.sh の終了処理が完了しました。
  2023/11/16 14:31:05 [SUCCESS] main.sh の処理が完了しました。
  ``` 
- 実行中にエラーが起きた場合は以下のようになる  
  ```log
  $ ./main.sh
  2023/11/16 14:31:44 [ASK] main.sh を実行します。よろしいですか？ [y/n]: y
  2023/11/16 14:31:45 [INFO] main.sh の処理を開始しました。
  2023/11/16 14:31:45 [INFO] .env の読み込みを開始しました。
  2023/11/16 14:31:45 [SUCCESS] .env の読み込みが完了しました。
  2023/11/16 14:31:45 [INFO] 一時フォルダの作成を開始しました。
  2023/11/16 14:31:45 /tmp/main.t72WBC
  2023/11/16 14:31:45 [SUCCESS] 一時フォルダの作成が完了しました。
  2023/11/16 14:31:46 [INFO] hello_world タスクの実行を開始しました。
  2023/11/16 14:31:46 /d/Projects/shell_script_template/src/tasks/hello_world/main.sh
  2023/11/16 14:31:46 Hello World!1
  2023/11/16 14:31:46 [ERROR] false
    at source /d/Projects/shell_script_template/src/tasks/hello_world/main.sh:3
    at call_task /d/Projects/shell_script_template/src/shared/sub/task.sh:10
    at main ./main.sh:5
  2023/11/16 14:31:46 [INFO] main.sh の終了処理を開始しました。
  2023/11/16 14:31:46 [INFO] 一時フォルダの削除を開始しました。
  2023/11/16 14:31:46 /tmp/main.t72WBC
  2023/11/16 14:31:46 [SUCCESS] 一時フォルダの削除が完了しました。
  2023/11/16 14:31:46 [SUCCESS] main.sh の終了処理が完了しました。
  2023/11/16 14:31:46 [NG] main.sh の処理中にエラーが発生しました。
  ```

## TODO
- ちゃんとした使い方の説明
