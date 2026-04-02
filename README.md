# claude-devteam

`claude-devteam` は、Claude Code でプロジェクトごとの `.devteam/` ワークスペースを作るための plugin です。

目的は、長い 1 セッションに依存せず、調査・要件整理・実装・監査・biz 向け資料作成を、短命セッション前提で継続できるようにすることです。

## この plugin でできること

- `.devteam/` の初期構成を作る
- 既存コードベースを読んで、構造理解用ドキュメントを埋める
- セッション終了時に handoff を残す
- backend / frontend / qa / biz などの役割ごとの記録場所を統一する

## インストール

Claude Code で以下を実行します。

```text
/plugin marketplace add Ryota098/claude-devteam
/plugin install devteam@claude-devteam
```

## クイックスタート

対象プロジェクト配下で Claude Code を起動し、以下を実行します。

```text
/devteam:dt-init
```

これでプロジェクト内に `.devteam/` が作られます。

既存案件の理解を進めたい場合は、続けて以下を実行します。

```text
/devteam:dt-discover
```

セッションを切り替える前は以下を実行します。

```text
/devteam:dt-handoff
```

## `.devteam/` の構成

`/devteam:dt-init` で、プロジェクト内に次のような構成を作る想定です。

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

## 2つの初期化方法の違い

- 現在の初期化方法は `/devteam:dt-init` のみです
- plugin を install したうえで Claude Code から実行する前提です
- ユーザーがこの repository を自分で clone して持つ必要はありません
- `.devteam/` の生成は Claude Code plugin 経由の 1 ルートに統一します

## 3つの command

- `/devteam:dt-init`
  - `.devteam/` のディレクトリ、README、主要テンプレートを作る command
- `/devteam:dt-discover`
  - 既存 docs とソースコードを読んで、architecture や project 系のドキュメントを埋める command
- `/devteam:dt-handoff`
  - 現在の状態を次セッション向けに圧縮して `shared/session-handoff.md` へ残す command

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
2. 対象 project root で `/devteam:dt-init`
3. 壁打ちをしながら `product/current-spec.md` を埋める
4. `pm/current-task.md` と `project/current-workset.md` を整える
5. 実装を進める
6. セッションを切り替える前に `/devteam:dt-handoff`

### 既存プロジェクト

1. Claude Code で plugin を install する
2. 対象 project root で `/devteam:dt-init`
3. 続けて `/devteam:dt-discover`
4. `architecture/*` と `product/current-spec.md` を確認する
5. `pm/current-task.md` の次タスクから着手する
6. セッションを切り替える前に `/devteam:dt-handoff`

### 監査前後

1. 実装後に `backend/implementation-summary.md` または `frontend/implementation-summary.md` を更新する
2. 監査セッションへ渡す前に `/devteam:dt-handoff`
3. 監査結果は `qa/*` に残す
4. 修正後に必要なら再度 `/devteam:dt-handoff`

## ライセンス

MIT
