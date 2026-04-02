# Workflow

## 基本方針
- Claude のセッションは短命で使い捨てにする
- 継続状態は `.devteam/` に保存する
- 新セッションでは必要なファイルだけ読む
- 会話全文ではなく、決定事項・未解決事項・次アクションを記録する

## セッション開始時
1. `shared/session-handoff.md` を読む
2. `pm/current-task.md` を読む
3. 必要に応じて関連ファイルを追加で読む
   - 構造理解: `architecture/system-overview.md`
   - 仕様確認: `product/current-spec.md`
   - 実装範囲確認: `project/current-workset.md`

## セッション終了時
1. `shared/session-handoff.md` を更新する
2. 必要に応じて `pm/current-task.md` を更新する
3. 仕様変更があれば `product/current-spec.md` に反映する
4. 重要判断は `shared/decisions.md` に残す

## 記録ルール
- `current-*`: 最新状態に保つ
- `decisions`, `source-log`, `deviations`, `audit`: 履歴を残す
- 未解明点は `unknowns.md` に残す
- 推測は事実と分けて書く
