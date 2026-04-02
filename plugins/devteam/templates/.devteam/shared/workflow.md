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

## よく使う command
- 初期化: `/devteam:dt-init`
- 既存理解: `/devteam:dt-discover`
- 引き継ぎ: `/devteam:dt-handoff`

## 実装から監査までの流れ

### API 実装フロー

1. 実装 AI が機能実装とテストを行う
2. `backend/summary-prompt.md` を使って仕様サマリを作る
3. 仕様サマリは `backend/implementation-summary.md` に保存する
4. 監査 AI に以下を渡す
   - `qa/api-audit-prompt.md`
   - `backend/implementation-summary.md`
   - 実装コード
   - テストコード
5. 監査結果は `qa/latest-audit.md` や `qa/uncovered-items.md` に残す
6. 実装 AI が指摘を反映する
7. 必要なら summary → audit を再実行する

### Frontend 実装フロー

1. 実装 AI が UI / ロジックを実装する
2. `frontend/summary-prompt.md` を使って仕様サマリを作る
3. 仕様サマリは `frontend/implementation-summary.md` に保存する
4. 監査 AI に以下を渡す
   - `qa/frontend-audit-prompt.md`
   - `frontend/implementation-summary.md`
   - 実装コード
5. 監査結果は `qa/latest-audit.md` や `qa/uncovered-items.md` に残す
6. 実装 AI が指摘を反映する
7. 必要なら summary → audit を再実行する

## 記録ルール
- `current-*`: 最新状態に保つ
- `decisions`, `source-log`, `deviations`, `audit`: 履歴を残す
- 未解明点は `unknowns.md` に残す
- 推測は事実と分けて書く
