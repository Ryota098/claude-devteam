---
description: 既存プロジェクトを読み取り .devteam の architecture と project 理解を更新する
---

現在のプロジェクトを分析し、新しいセッションでも素早くキャッチアップできるように `.devteam/` を更新してください。

要件:
- `.devteam/` が無ければ先に初期化する
- まず `.devteam` 側の入口を読む
  - `shared/workflow.md`
  - `shared/session-handoff.md`
  - `pm/current-task.md`
- 次に project root の主要ファイルを読む
  - `README.md`
  - `docs/` 配下の代表的なドキュメント
  - package / framework / test / docker などの設定
- repository 構造を把握する
  - monorepo なら app / package / service ごとの責務を推定する
  - frontend / backend / worker / infra などの境界を推定する
- 主要エントリ、主要モジュール、既存テストを読み、全体像の中心を把握する

まず更新するファイル:
- `architecture/system-overview.md`
- `architecture/module-map.md`
- `architecture/dependencies.md`
- `architecture/constraints.md`
- `architecture/unknowns.md`
- `product/current-spec.md`
- `project/current-workset.md`
- `pm/current-task.md`
- `shared/session-handoff.md`

ルール:
- 不明な点は `architecture/unknowns.md` に残す
- 推測で確定しない
- 全ファイル精読は不要
- まずは全体像、主要境界、次の作業に必要な部分を優先する
- 最後に、次のセッションで最初に着手すべき 1 タスクを `pm/current-task.md` に書く
- command 名の案内は `/devteam:dt-discover` に合わせる

出力:
- 何を読んで何を理解したか
- 主に更新したドキュメント
- 次に取るべき 1 アクション
