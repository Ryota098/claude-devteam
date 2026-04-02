---
name: init
description: 現在のプロジェクトに .devteam ワークスペースを初期化し、役割別ディレクトリと主要テンプレートを作成します。
disable-model-invocation: true
---

# devteam:init

現在のプロジェクトに `.devteam/` ディレクトリを初期化します。

## 目的

空のディレクトリではなく、すぐに運用できるワークスペースを作ること。

## 必須の動作

1. 現在のプロジェクトに `.devteam/` が既に存在するか確認する。
2. 存在しない場合は、合意済みの `.devteam/` ディレクトリ構成を作成する。
3. 次の主要ファイルには初期テンプレートを入れて作成する。
   - `README.md`
   - `CLAUDE.md`
   - `shared/workflow.md`
   - `shared/session-handoff.md`
   - `architecture/coding-standards.md`
   - `pm/current-task.md`
   - `project/current-workset.md`
   - `product/current-spec.md`
   - `backend/implementation-summary.md`
   - `frontend/implementation-summary.md`
   - `qa/audit-contract-api.md`
   - `qa/audit-contract-frontend.md`
   - `biz/current-brief.md`
4. それ以外の合意済みディレクトリと補助ファイルも作成する。
5. setup 質問は原則しない。repository 構造が本当に曖昧で、ローカル確認でも判断不能な場合のみ例外とする。
6. frontend / backend / monorepo などの構成は、ユーザーに聞く前にローカルファイルとディレクトリから推定する。
7. `.devteam/` が既に存在する場合、ユーザー作成内容を無条件に上書きしない。不足分を追加し、既存ファイルは残したうえで状況を報告する。

## 実行手順

### Step 1: 現在地の確認

- 現在の作業ディレクトリが project root として妥当か確認する
- 少なくとも以下のどれかがあるかを見る
  - `.git/`
  - `package.json`
  - `pyproject.toml`
  - `go.mod`
  - `Cargo.toml`
  - `README.md`
- 完全に空で project root と判断できない場合でも、ユーザーがそこで実行したならその場所を対象にする

### Step 2: 既存 `.devteam/` の確認

- `.devteam/` が無ければ新規作成モード
- `.devteam/` があれば更新モード
- 更新モードでは既存ファイルを読み、壊さずに不足分だけ追加する

### Step 3: project 形状の軽い推定

- 初期化の段階では深く読まなくてよい
- ただし以下は軽く確認する
  - frontend がありそうか
  - backend がありそうか
  - monorepo っぽいか
  - 既存 docs があるか
- この段階では確定しなくてよい
- 曖昧なら後続の `/devteam:discover` に委ねる

### Step 4: ディレクトリ作成

以下のディレクトリを作成する。

```text
.devteam/
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

### Step 5: 主要テンプレート作成

以下のファイルは必ず作成または補完する。

- `README.md`
- `CLAUDE.md`
- `shared/workflow.md`
- `shared/session-handoff.md`
- `architecture/coding-standards.md`
- `pm/current-task.md`
- `project/current-workset.md`
- `product/current-spec.md`
- `backend/implementation-summary.md`
- `frontend/implementation-summary.md`
- `qa/audit-contract-api.md`
- `qa/audit-contract-frontend.md`
- `biz/current-brief.md`

### Step 6: 補助ファイル作成

- 合意済みの補助ファイル群も作る
- ただし既に存在する場合は内容を消さない
- 空ファイルにせず、最低限の見出しは入れる

### Step 7: 初期案内

- 初期化完了後、次に何をすべきかを案内する
- 既存案件なら `/devteam:discover`
- 新規案件なら `product/current-spec.md` から壁打ち開始

## テンプレートの扱い

- ファイル名とディレクトリ名は英語で作る
- 本文は日本語で作る
- `current-*` は最新状態のためのファイルとして作る
- 履歴系ファイルには、追記前提で使うことが分かる最小説明を入れる

## 既存 `.devteam/` がある場合のルール

- 既存の `README.md`, `workflow.md`, `current-task.md` などを消さない
- 不足しているファイルだけ追加する
- 明らかに古い空ファイルしかない場合でも、無断で全文置換しない
- 既存ファイルと新しいテンプレートに差があっても、まずは追加と報告を優先する

## 出力時の期待内容

- `.devteam/` を新規作成したのか、既存内容へ追加したのかを簡潔に伝える。
- 主要ファイルとして何を作成したかを示す。
- 既存案件なら次に `/devteam:discover` を実行するとよいことを案内する。

## 出力例の方針

- 長い変更ログではなく、3〜8行程度で要点を返す
- 例:
  - 新規作成か更新か
  - 主に作成したファイル
  - 次にやる 1 アクション

## やってはいけないこと

- `.devteam/` 既存内容を無確認で全面上書きすること
- project のコードや docs をこの段階で勝手に大きく書き換えること
- `discover` の仕事まで抱え込んで過剰に長文化すること
- 設定質問を乱発すること

## 注意

- 会話セッションは使い捨てであり、継続状態は `.devteam/` に持たせる。
- 生成される `.devteam/` は durable な project state である。
- `current-*` 系ファイルは「最新状態を表す文書」として扱う。
