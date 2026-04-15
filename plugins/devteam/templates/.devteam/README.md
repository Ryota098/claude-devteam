# .devteam

この project は `claude-devteam` の `.devteam/` 運用を前提にします。

まず確認するもの:

- `current/handoff.md`
- `current/task.md`
- `current/spec.md`
- 必要なら `review/audit.md`

よく使う command:

- `/devteam:dt-discover`
- `/devteam:dt-handoff`

初期化:

```bash
sh ~/.claude/plugins/marketplaces/claude-devteam/scripts/init-devteam.sh .
```

既存の `.devteam/` を新しい構成へ入れ替える場合:

```bash
sh ~/.claude/plugins/marketplaces/claude-devteam/scripts/init-devteam.sh . --clean
```

詳細な運用フローや依頼例は、`https://github.com/Ryota098/claude-devteam` の README を参照してください。
