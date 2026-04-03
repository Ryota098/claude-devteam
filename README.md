# claude-devteam

`claude-devteam` は、Claude Code でプロジェクトごとの `.devteam/` ワークスペースを作るための plugin です。

目的は、長い 1 セッションに依存せず、調査・要件整理・実装・監査・biz 向け資料作成を、短命セッション前提で継続できるようにすることです。

## 目次

- [この plugin でできること](#この-plugin-でできること)
- [インストール](#インストール)
- [クイックスタート](#クイックスタート)
- [`.devteam/` の構成](#devteam-の構成)
- [各ディレクトリの役割](#各ディレクトリの役割)
- [主に使うファイル](#主に使うファイル)
- [3つの command](#3つの-command)
- [`discover` と `handoff` の使い所](#discover-と-handoff-の使い所)
- [command と役割ディレクトリの違い](#command-と役割ディレクトリの違い)
- [ファイル名と言語について](#ファイル名と言語について)
- [リポジトリモデル](#リポジトリモデル)
- [公開前の確認項目](#公開前の確認項目)
- [運用の考え方](#運用の考え方)
- [今後の想定](#今後の想定)
- [実際の利用フロー](#実際の利用フロー)
- [日常運用フロー](#日常運用フロー)
- [Claude への頼み方](#claude-への頼み方)
- [ライセンス](#ライセンス)

## この plugin でできること

- `.devteam/` の deterministic な初期構成を作るための shell script を提供する
- 既存コードベースを読んで、構造理解用ドキュメントを埋める
- セッション終了時に handoff を残す
- backend / frontend / qa / biz などの役割ごとの記録場所を統一する

## インストール

Claude Code で以下を実行します。

```text
/plugin marketplace add Ryota098/claude-devteam
```
```text
/plugin install devteam@claude-devteam
```

install 時に Claude Code の標準 UI で scope 選択が表示されます。

- `Install for you (user scope)`
  - 個人の標準ツールとして複数プロジェクトで使う時の推奨設定
- `Install for all collaborators on this repository (project scope)`
  - その repository の共同開発者にも同じ plugin を前提化したい時
- `Install for you, in this repo only (local scope)`
  - 検証や一時利用向け

通常運用では `user scope`、動作確認では `local scope` を推奨します。

## クイックスタート

### 1. 初期化は shell script で行う

この plugin は、対象プロジェクト配下で Claude Code を起動して使う前提です。`.devteam/` の初期化は shell script を使うのが正式ルートです。これにより、README / workflow / prompt 群まで全メンバーで同一内容になります。

```bash
sh ~/.claude/plugins/marketplaces/claude-devteam/scripts/init-devteam.sh .
```

手順はこれだけです。

1. 対象プロジェクト配下で Claude Code を起動する
2. そのまま次を実行する

```bash
sh ~/.claude/plugins/marketplaces/claude-devteam/scripts/init-devteam.sh .
```

`~/.claude/plugins/marketplaces/claude-devteam/` は plugin install 後に Claude Code が保持する marketplace の標準配置先です。ユーザーごとにホームディレクトリは異なっても、`~/.claude/...` で書けばそのまま使えます。

### 2. 初期化後に Claude Code command を使う

`.devteam/` 作成後に、対象プロジェクト配下で Claude Code を起動します。

既存案件の理解を進めたい場合は以下を実行します。新規案件ならここは不要です。

```text
/devteam:dt-discover
```

`dt-handoff` は初回セットアップではなく、作業後にセッションを切り替える時に使います。

```text
/devteam:dt-handoff
```

使い分け:

- 初回セットアップ
  - `scripts/init-devteam.sh`
- 既存案件の把握
  - `scripts/init-devteam.sh` の後に `/devteam:dt-discover`
- セッション切り替え前
  - `/devteam:dt-handoff`

## `.devteam/` の構成

`scripts/init-devteam.sh` で、プロジェクト内に次のような構成を作る想定です。

```text
.devteam/
├── README.md
├── CLAUDE.md
├── shared/
├── research/
├── architecture/
├── product/
├── pm/
├── project/
├── backend/
├── frontend/
├── qa/
└── biz/
```

## 各ディレクトリの役割

- `shared/`
  - 共通ルール、意思決定、セッション引き継ぎを置く場所
- `research/`
  - 市場調査、競合調査、参考事例、外部情報を整理する場所
- `architecture/`
  - 既存コード理解、構造把握、依存関係、制約、実装ルールを整理する場所
- `product/`
  - 要件、仕様、スコープ、受け入れ条件を整理する場所
- `pm/`
  - タスク分解、優先順位、現在タスク、ブロッカーを整理する場所
- `project/`
  - backend / frontend をまたぐ作業範囲や統合観点を整理する場所
- `backend/`
  - API、契約、実装方針、実装後サマリを整理する場所
- `frontend/`
  - UI 契約、状態、実装方針、実装後サマリを整理する場所
- `qa/`
  - 監査ルール、監査結果、未網羅、回帰リスクを整理する場所
- `biz/`
  - 非技術者向け仕様書、提案資料、説明用要約を整理する場所

## 主に使うファイル

- `shared/session-handoff.md`
  - 次セッションに渡す要点
- `pm/current-task.md`
  - 今やる 1 タスク
- `product/current-spec.md`
  - 現時点で有効な仕様
- `project/current-workset.md`
  - 今回触る範囲と影響整理
- `biz/current-brief.md`
  - biz 向けに今説明すべき内容

## 3つの command

- `/devteam:dt-init`
  - shell script 初期化を案内する補助 command
- `/devteam:dt-discover`
  - 既存 docs とソースコードを読んで、architecture や project 系のドキュメントを埋める command
- `/devteam:dt-handoff`
  - 現在の状態を次セッション向けに圧縮して `shared/session-handoff.md` へ残す command

`dt-init` は deterministic な初期化を自分で生成する command ではありません。正式な初期化は shell script が行い、project 固有の理解や要約は `dt-discover` が担当します。

## `discover` と `handoff` の使い所

### `/devteam:dt-discover`

次のような時に使います。

- 既存案件に途中参加した時
- セッションを切り替えた後に repo 全体の理解を戻したい時
- monorepo や大きめの repository で、構造を整理したい時
- docs とコードのズレを把握したい時

主に更新されるのは以下です。

- `architecture/system-overview.md`
- `architecture/module-map.md`
- `architecture/dependencies.md`
- `architecture/constraints.md`
- `architecture/unknowns.md`
- `product/current-spec.md`
- `project/current-workset.md`
- `pm/current-task.md`
- `shared/session-handoff.md`

### `/devteam:dt-handoff`

次のような時に使います。

- セッションが長くなって切り替えたい時
- 実装が一区切りついた時
- 監査セッションへ渡す前
- backend / frontend / biz など別観点のセッションへ渡す前

主に更新されるのは以下です。

- `shared/session-handoff.md`
- `pm/current-task.md`
- `project/current-workset.md`
- 必要に応じて backend / frontend 側の current 系ファイル
- 必要に応じて `biz/current-brief.md`

## command と役割ディレクトリの違い

この plugin では、まず `devteam:dt-init / devteam:dt-discover / devteam:dt-handoff` の 3 つを command として持ちます。

- command
  - Claude Code に何をさせるかの入口
  - 例: `/devteam:dt-init`
- 役割ディレクトリ
  - 調査、設計、実装、監査、biz などの知識や記録の置き場
  - 例: `research/`, `architecture/`, `backend/`, `qa/`, `biz/`

つまり今の構成では、

- `init / discover / handoff` = 実行コマンド
- `backend / frontend / qa / biz ...` = ドキュメントの保存場所

です。

## ファイル名と言語について

この plugin では、

- ファイル名とディレクトリ名は英語
- ファイルの中身は日本語中心

を前提にしています。

理由は以下です。

- ファイル名は英語の方が安定しやすい
- Claude や各種ツールから参照しやすい
- ただし実際の運用内容は日本語の方が理解しやすい

そのため、`current-task.md` や `session-handoff.md` のような英語ファイル名でも、中の見出しや説明は日本語で運用します。

## リポジトリモデル

- この repository は plugin 本体です
- 実際の利用者は、自分の案件 repository 内で plugin を使います
- plugin は対象プロジェクトに `.devteam/` を作ります
- `.devteam/` はその案件 repository の一部として Git 管理して構いません
- ただし秘密情報は入れない前提です

## 公開前の確認項目

- GitHub repository 名が `claude-devteam` であること
- owner が `Ryota098` であること
- `README.md` の install 例が実 repository と一致していること
- `.claude-plugin/marketplace.json` の `owner`, `author`, `repository` が実値と一致していること
- `plugins/devteam/.claude-plugin/plugin.json` の `name` と version が期待どおりであること
- 公開したくない情報が `.devteam` テンプレートや README に入っていないこと
- plugin install 後の想定コマンドが次の 3 つであること
  - `/devteam:dt-init`
  - `/devteam:dt-discover`
  - `/devteam:dt-handoff`

## 運用の考え方

- 会話セッションは使い捨て
- `.devteam/` は継続状態
- `current-*` は最新状態に上書きする
- `decisions`, `source-log`, `deviations`, `audit` などは履歴として残す
- 会話全文ではなく、決定事項・未解決事項・次アクションだけを残す

## 今後の想定

最初は以下の 3 command だけで運用を始めます。

- `/devteam:dt-init`
- `/devteam:dt-discover`
- `/devteam:dt-handoff`

必要に応じて今後追加しうる command の例:

- `/devteam:dt-plan`
- `/devteam:dt-audit`
- `/devteam:dt-biz-brief`

## 実際の利用フロー

### 新規プロジェクト

1. Claude Code で plugin を install する
2. 対象 project root で `scripts/init-devteam.sh`
3. 壁打ちをしながら `product/current-spec.md` を埋める
4. `pm/current-task.md` と `project/current-workset.md` を整える
5. 実装を進める
6. セッションを切り替える前に `/devteam:dt-handoff`

### 既存プロジェクト

1. Claude Code で plugin を install する
2. 対象 project root で `scripts/init-devteam.sh`
3. 続けて `/devteam:dt-discover`
4. `architecture/*` と `product/current-spec.md` を確認する
5. `pm/current-task.md` の次タスクから着手する
6. セッションを切り替える前に `/devteam:dt-handoff`

### 監査前後

1. 実装後に `backend/implementation-summary.md` または `frontend/implementation-summary.md` を更新する
2. 監査セッションへ渡す前に `/devteam:dt-handoff`
3. 監査結果は `qa/*` に残す
4. 修正後に必要なら再度 `/devteam:dt-handoff`

## 日常運用フロー

### 1. 壁打ち・調査
- 目的
  - 何を作るか、なぜ必要か、どういう方針で進めるかを整理する
- 主に見るファイル
  - `product/current-spec.md`
  - `biz/current-brief.md`
  - `research/*`
- 主に更新するファイル
  - `product/current-spec.md`
  - `shared/decisions.md`
  - `biz/current-brief.md`
  - 必要なら `research/*`
- Claude への依頼例
  - 「この機能の目的、利用者、成功条件を整理して `product/current-spec.md` にまとめて」
  - 「競合や参考実装を調べて `research/market-research.md` に整理して」
  - 「参考URLを `research/source-log.md` に残して」
  - 「非技術者向けに `biz/current-brief.md` に要点を書いて」

### 2. 既存コードの把握
- 既存案件なら `/devteam:dt-discover` を実行する
- 主に埋まるファイル
  - `architecture/system-overview.md`
  - `architecture/module-map.md`
  - `architecture/constraints.md`
  - `architecture/unknowns.md`
  - `project/current-workset.md`
  - `pm/current-task.md`
- Claude への依頼例
  - 「`/devteam:dt-discover` を実行して既存コードと docs を整理して」
  - 「実行後に `architecture/system-overview.md` と `pm/current-task.md` を前提に、今どこから着手すべきか要約して」

### 3. タスク化
- 目的
  - 仕様を、実装できる単位のタスクへ落とす
- 主に見るファイル
  - `product/current-spec.md`
  - `architecture/*`
- 主に更新するファイル
  - `pm/current-task.md`
  - `pm/task-breakdown.md`
  - `project/current-workset.md`
- Claude への依頼例
  - 「この仕様を実装タスクへ分解して `pm/task-breakdown.md` に書いて」
  - 「次にやる1タスクだけ `pm/current-task.md` に反映して」
  - 「今回触る範囲を `project/current-workset.md` に整理して」

### 4. 実装
- 実装前に確認
  - `architecture/coding-standards.md`
  - `product/current-spec.md`
  - `pm/current-task.md`
  - `project/current-workset.md`
- 実装中に必要なら更新
  - `product/current-spec.md`
  - `shared/decisions.md`
  - `project/current-workset.md`
- Claude への依頼例
  - 「`architecture/coding-standards.md` を守ってこのタスクを実装して。必要なら関連 docs も更新して」
  - 「実装しながら必要なら `product/current-spec.md` と `shared/decisions.md` も更新して」
  - 「今回の変更範囲が広がったら `project/current-workset.md` に追記して」

### 5. 実装後のサマリ作成
- API 実装後
  - `backend/summary-prompt.md` を使って仕様サマリを作る
  - 結果を `backend/implementation-summary.md` に保存する
- Frontend 実装後
  - `frontend/summary-prompt.md` を使って仕様サマリを作る
  - 結果を `frontend/implementation-summary.md` に保存する
- Claude への依頼例
  - API: 「`backend/summary-prompt.md` に従って仕様サマリを作り、`backend/implementation-summary.md` に保存して」
  - Frontend: 「`frontend/summary-prompt.md` に従って仕様サマリを作り、`frontend/implementation-summary.md` に保存して」

### 6. 監査
- API 監査
  - `qa/api-audit-prompt.md`
  - `backend/implementation-summary.md`
  - 実装コード
  - テストコード
  を監査 AI に渡す
- Frontend 監査
  - `qa/frontend-audit-prompt.md`
  - `frontend/implementation-summary.md`
  - 実装コード
  を監査 AI に渡す
- 主に更新するファイル
  - `qa/latest-audit.md`
  - `qa/uncovered-items.md`
- Claude への依頼例
  - API: 「`qa/api-audit-prompt.md` に従って監査して。仕様サマリは `backend/implementation-summary.md`、対象は今回の実装コードとテストコードです。結果を `qa/latest-audit.md` にまとめて」
  - Frontend: 「`qa/frontend-audit-prompt.md` に従って監査して。仕様サマリは `frontend/implementation-summary.md`、対象は今回の実装コードです。結果を `qa/latest-audit.md` にまとめて」

### 7. 修正ループ
- 監査結果を実装 AI に戻して修正する
- 修正後は必要に応じて再度
  - `backend/implementation-summary.md` または `frontend/implementation-summary.md`
  - `qa/latest-audit.md`
  を更新する
- Claude への依頼例
  - 「`qa/latest-audit.md` の指摘を反映して修正して」
  - 「修正後に `backend/implementation-summary.md` または `frontend/implementation-summary.md` を更新して」
  - 「必要なら再監査できる状態まで整えて」

### 8. セッション切り替え
- セッションを切り替える前に `/devteam:dt-handoff` を実行する
- 次セッションではまず以下を読む
  - `shared/session-handoff.md`
  - `pm/current-task.md`
  - 必要なら `project/current-workset.md`
- Claude への依頼例
  - 「`/devteam:dt-handoff` を実行して、次セッション向けに状態を整理して」
  - 「handoff 更新後、次にやる1アクションだけ教えて」

## Claude への頼み方

普段は `/` を打たず、普通に日本語で依頼して構いません。`/devteam:*` は定型処理を呼ぶ時だけ使います。

- 普通に会話で依頼する例
  - 「この機能の要件を整理して `product/current-spec.md` にまとめて」
  - 「競合を調べて `research/market-research.md` に整理して」
  - 「次の実装タスクを `pm/current-task.md` に書いて」
  - 「`architecture/coding-standards.md` を守ってこの機能を実装して」
  - 「`backend/summary-prompt.md` を使って仕様サマリを作って」
  - 「`qa/api-audit-prompt.md` に従って監査して」
  - 「この内容を非技術者向けに `biz/current-brief.md` にまとめて」

- `/` を使う例
  - `/devteam:dt-discover`
    - 既存案件の理解を一気に進めたい時
  - `/devteam:dt-handoff`
    - セッションを切り替えたい時

## ライセンス

MIT
