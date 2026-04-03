---
description: 現在のプロジェクトに .devteam ワークスペースを初期化する
---

現在のプロジェクトに `.devteam/` ディレクトリを初期化してください。

必ず以下の方針で実行してください。

## 実行方針

- `init` は会話ベースで内容を再生成しない
- `plugins/devteam/templates/.devteam/` を source of truth とする
- template にあるファイルは、現在の project root 配下の `.devteam/` に同じパスで揃える
- README、workflow、prompt、audit contract も含めて template をそのまま使う
- 既存 `.devteam/` がある場合は壊さず、不足分だけ追加する
- project 固有の理解や要約は `init` では書かない
- project 理解は次の `/devteam:dt-discover` で行う

## 実行手順

1. 現在の project root に `.devteam/` があるか確認する
2. Bash を使って `plugins/devteam/scripts/init_devteam.sh` を current working directory に対して実行する
3. script 実行後、`.devteam/` に以下が揃っているか確認する
   - `README.md`
   - `shared/workflow.md`
   - `shared/session-handoff.md`
   - `backend/summary-prompt.md`
   - `frontend/summary-prompt.md`
   - `qa/api-audit-prompt.md`
   - `qa/frontend-audit-prompt.md`
4. template にあるのに欠けているファイルがあれば、不足分だけ追加する
5. 内容は template をそのまま使い、要約や書き換えをしない

## 初期化後の案内

- 既存案件なら次に `/devteam:dt-discover`
- 新規案件なら `product/current-spec.md` から壁打ち開始

## 出力

- `.devteam/` を新規作成したか、既存内容へ追加したか
- template から揃えた主要ファイル
- 次にやる 1 アクション
