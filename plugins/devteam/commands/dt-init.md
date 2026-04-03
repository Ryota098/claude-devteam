---
description: 現在のプロジェクトに .devteam ワークスペースを初期化する
---

この command は `.devteam/` を会話ベースで再生成しません。

初期化は deterministic に shell script で行います。ユーザーに次を案内してください。

```bash
sh ~/.claude/plugins/marketplaces/claude-devteam/scripts/init-devteam.sh <project-root>
```

現在の project root で実行しているなら、通常は次でよいことも案内してください。

```bash
sh ~/.claude/plugins/marketplaces/claude-devteam/scripts/init-devteam.sh .
```

もし現在の project root にすでに `.devteam/` がある場合は、
- 初期化済みであること
- 既存案件なら次に `/devteam:dt-discover`
- セッション切り替え時は `/devteam:dt-handoff`

を短く案内してください。

`.devteam/` がまだ無い場合は、
- shell script で初期化すること
- 初期化後に既存案件なら `/devteam:dt-discover`
- 新規案件なら `product/current-spec.md` から壁打ち開始

を案内してください。
