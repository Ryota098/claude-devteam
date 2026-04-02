---
description: 現在のプロジェクトに .devteam ワークスペースを初期化する
---

現在のプロジェクトに `.devteam/` ディレクトリを初期化してください。

要件:
- 現在のプロジェクトに `.devteam/` が既に存在するか確認する
- 存在しない場合は、合意済みの `.devteam/` ディレクトリ構成を作成する
- 存在する場合は既存内容を壊さず、不足分だけ追加する
- frontend / backend / monorepo などの構成は、ユーザーに聞く前にローカルファイルとディレクトリから軽く推定する
- setup 質問は原則しない
- `plugins/devteam/templates/.devteam/` を source of truth として扱い、そこにあるファイルは `.devteam/` 側にも同じパスで揃える
- prompt ファイルや補助ファイルも含めて、template 一式の不足分を補完する

作成対象:
- `.devteam/README.md`
- `.devteam/CLAUDE.md`
- `.devteam/shared/workflow.md`
- `.devteam/shared/session-handoff.md`
- `.devteam/architecture/coding-standards.md`
- `.devteam/pm/current-task.md`
- `.devteam/project/current-workset.md`
- `.devteam/product/current-spec.md`
- `.devteam/backend/implementation-summary.md`
- `.devteam/frontend/implementation-summary.md`
- `.devteam/qa/audit-contract-api.md`
- `.devteam/qa/audit-contract-frontend.md`
- `.devteam/biz/current-brief.md`
- `.devteam/backend/summary-prompt.md`
- `.devteam/frontend/summary-prompt.md`
- `.devteam/qa/api-audit-prompt.md`
- `.devteam/qa/frontend-audit-prompt.md`
- そのほか合意済みの補助ファイル群

テンプレート方針:
- `plugins/devteam/templates/.devteam/` を source of truth として扱う
- ファイル名とディレクトリ名は英語で作る
- 本文は日本語で作る
- `current-*` は最新状態のためのファイルとして作る
- command 名の案内は `/devteam:dt-init` `/devteam:dt-discover` `/devteam:dt-handoff` に合わせる

初期化後の案内:
- 既存案件なら次に `/devteam:dt-discover`
- 新規案件なら `product/current-spec.md` から壁打ち開始

出力:
- `.devteam/` を新規作成したか、既存内容へ追加したか
- 主に作成したファイル
- 次にやる 1 アクション
