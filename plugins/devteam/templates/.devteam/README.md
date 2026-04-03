# .devteam

この project は `claude-devteam` の `.devteam/` ワークスペースで運用します。

## 最初に確認するファイル
- `shared/session-handoff.md`
- `pm/current-task.md`
- 必要なら `project/current-workset.md`

## よく使う command
- `/devteam:dt-discover`
  - 既存コードと docs の理解を更新したい時
- `/devteam:dt-handoff`
  - セッションを切り替える前に状態を残したい時

## 初期化
`.devteam/` の初期化は project root で次を実行します。

```bash
sh ~/.claude/plugins/marketplaces/claude-devteam/scripts/init-devteam.sh .
```

## 詳細ガイド
詳細な運用フロー、Claude への頼み方、監査フロー、各ファイルの意味は `claude-devteam` repository の `README.md` を参照してください。
