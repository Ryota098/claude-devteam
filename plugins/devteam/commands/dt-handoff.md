---
description: 現在のセッション内容を圧縮し、次のセッション用に .devteam handoff を更新する
---

次のセッションが最小限の読込で再開できるように `.devteam/` を更新してください。

更新対象:
- `shared/session-handoff.md`

必要に応じて更新:
- `pm/current-task.md`
- `project/current-workset.md`
- `backend/current-feature.md`
- `frontend/current-feature.md`
- `biz/current-brief.md`

`shared/session-handoff.md` には少なくとも以下を含める:
- Current Goal
- Current State
- Files Touched
- Open Issues
- Next Step
- Warnings

ルール:
- handoff は短く保つ
- 理想は 1 画面で読める長さ
- 会話全文を貼り付けない
- 感想ではなく、durable な要点だけ残す
- `Next Step` は次セッションで最初にやる 1 アクションに絞る
- command 名の案内は `/devteam:dt-handoff` に合わせる

出力:
- handoff を更新したこと
- 関連して更新した current ファイル
- 次セッションの最初の 1 アクション
