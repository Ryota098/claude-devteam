# .devteam

このディレクトリは、短命セッション前提で開発・調査・監査・biz資料作成を継続するための共有記録です。

## 使い始め方
1. プロジェクト配下で Claude Code を起動する
2. `/dt-init` を実行する
3. 既存案件なら `/dt-discover` を実行する
4. 新しいセッションではまず以下を読む
   - `shared/workflow.md`
   - `shared/session-handoff.md`
   - `pm/current-task.md`

## 主な使い方
- プロジェクト理解: `/dt-discover`
- セッション引き継ぎ: `/dt-handoff`
- 実装開始前: `product/current-spec.md` と `project/current-workset.md` を確認
- 実装後: `backend/implementation-summary.md` または `frontend/implementation-summary.md` を更新
- biz向け整理: `biz/current-brief.md` を更新

## 実装後の監査フロー

### API
- 実装後に `backend/summary-prompt.md` を使って仕様サマリを作る
- サマリは `backend/implementation-summary.md` に保存する
- 監査時は `qa/api-audit-prompt.md` と一緒に、実装コードとテストコードを監査 AI へ渡す
- 監査結果は `qa/latest-audit.md` と `qa/uncovered-items.md` に残す

### Frontend
- 実装後に `frontend/summary-prompt.md` を使って仕様サマリを作る
- サマリは `frontend/implementation-summary.md` に保存する
- 監査時は `qa/frontend-audit-prompt.md` と一緒に、実装コードを監査 AI へ渡す
- 監査結果は `qa/latest-audit.md` と `qa/uncovered-items.md` に残す

## ディレクトリの役割
- `shared/`: 共通ルール、意思決定、引き継ぎ
- `research/`: 市場調査、競合調査、外部情報
- `architecture/`: 既存コード理解、構造把握、実装ルール
- `product/`: 要件、仕様、受け入れ条件
- `pm/`: タスク分解、優先順位、今やること
- `project/`: バック/フロント横断の実行管理
- `backend/`: API/サーバ観点
- `frontend/`: UI/クライアント観点
- `qa/`: 監査、未網羅、品質リスク
- `biz/`: 非技術者向け説明、提案、資料

## 重要ファイルの意味
- `shared/session-handoff.md`: 次セッションに渡す要点
- `pm/current-task.md`: 今やる1タスク
- `product/current-spec.md`: 現在有効な仕様
- `project/current-workset.md`: 今回触る範囲
- `biz/current-brief.md`: biz向け説明内容の最新版

## 更新ルール
- `current-*` は最新状態で上書きする
- `decisions.md`, `source-log.md`, `deviations.md`, `latest-audit.md` は履歴として残す
- 会話全文は残さず、決定事項・未解決事項・差分のみ記録する

## ファイル名について
- ファイル名は英語で統一する
- ただし本文は日本語で書いてよい
- このディレクトリは、人間が読みやすく、Claude も参照しやすい形を優先する
