---
name: discover
description: 既存のプロジェクトを読み取り、.devteam の architecture・product・project 系ドキュメントを埋めてキャッチアップ可能な状態にします。
disable-model-invocation: true
---

# devteam:discover

現在のプロジェクトを分析し、新しいセッションでも素早くキャッチアップできるように `.devteam/` を更新します。

## 目的

コードベース理解を durable な文書へ変換し、推測で埋めずに unknowns を明示すること。

## 必須の動作

1. `.devteam/` の存在を確認する。無ければ先に初期化する。
2. ローカル repository 構造と主要ファイルを読む。対象には少なくとも以下を含める。
   - root README and docs
   - package manifests
   - framework config
   - docker and environment examples
   - source entrypoints
   - major modules
   - tests
3. まず以下のファイルを優先的に更新する。
   - `architecture/system-overview.md`
   - `architecture/module-map.md`
   - `architecture/dependencies.md`
   - `architecture/constraints.md`
   - `architecture/unknowns.md`
   - `product/current-spec.md`
   - `project/current-workset.md`
   - `pm/current-task.md`
   - `shared/session-handoff.md`
4. frontend / backend / monorepo などの構造は、事前質問ではなくコードベースから推定する。
5. まだ曖昧な点は `architecture/unknowns.md` に残す。
6. 最後に、次のセッションで最初に着手すべき1タスクを `pm/current-task.md` に書く。

## 実行手順

### Step 1: 入口ファイルの読込

まず `.devteam/` 側の入口を確認する。

- `shared/workflow.md`
- `shared/session-handoff.md`
- `pm/current-task.md`

これにより、既存の運用ルールと現在地を把握する。

### Step 2: project 基本情報の読込

次に、project root の主要ファイルを読む。

- `README.md`
- `docs/` 配下の代表的なドキュメント
- `package.json`, `pyproject.toml`, `go.mod`, `Cargo.toml` など
- framework / build / lint / test の設定ファイル
- `docker-compose.yml`, `compose.yml`, `.env.example` など

目的は「この project が何者か」を短く把握すること。

### Step 3: repository 構造の把握

- 主要ディレクトリを列挙する
- monorepo なら app / package / service ごとの責務を推定する
- frontend / backend / worker / infra などの境界を推定する
- この結果を `architecture/module-map.md` へ反映する

### Step 4: 主要エントリと主要モジュールの読解

- entrypoint 付近
- routing / controller / page / feature 入口
- domain ロジックの中心
- database / API client / state 管理の中心
- 既存テスト

ここでは、全ファイルを読むことよりも「構造の中心」を見つけることを優先する。

### Step 5: architecture 文書の更新

少なくとも以下を更新する。

- `architecture/system-overview.md`
- `architecture/module-map.md`
- `architecture/dependencies.md`
- `architecture/constraints.md`
- `architecture/unknowns.md`

必要があれば以下も更新する。

- `architecture/data-flow.md`
- `architecture/coding-standards.md`
- `architecture/patterns.md`
- `architecture/anti-patterns.md`

### Step 6: product / project 文書の更新

実装や docs から読み取れる範囲で以下を更新する。

- `product/current-spec.md`
- `project/current-workset.md`

ただし、明確な根拠がない仕様は推測で確定しない。

### Step 7: 次アクションの設定

- `pm/current-task.md` に次の1タスクを書く
- そのタスクは曖昧な巨大調査ではなく、着手可能な具体タスクにする
- 例:
  - `authentication flow の構造を整理する`
  - `X endpoint の入出力契約を確認する`
  - `frontend の loading/error 分岐を点検する`

### Step 8: handoff の更新

- `shared/session-handoff.md` を discover 後の状態に合わせて更新する
- 次セッションがそのまま入れる状態にする

## unknowns の扱い

- 分からないことを隠さない
- 推測で埋めるより `unknowns.md` に残す方を優先する
- unknown は次の3分類で書くとよい
  - 未確認の構造
  - 未確認の仕様
  - 未確認の運用ルール

## どこまで読むか

- 全ファイル精読は不要
- まずは「全体像」「主要境界」「次の作業に必要な部分」を優先する
- project が大きい場合は、最初の discover で全理解を目指さず、次タスクに必要な理解までで止めてよい

## 出力時の期待内容

- 何を読んで何を理解したかを簡潔に要約する。
- 主に更新したドキュメントを示す。
- 次に取るべき行動を1つ明示する。

## 出力例の方針

- 長い調査レポートではなく、要点だけ返す
- 例:
  - project 構造の要点
  - 更新した architecture 文書
  - 残った unknowns の有無
  - 次の 1 タスク

## やってはいけないこと

- 不明点を分かったふりで埋めること
- 全コードを無差別に読み、要点を失うこと
- `pm/current-task.md` に巨大で曖昧なタスクを書くこと
- 監査や実装修正まで一気に抱え込むこと

## 注意

- 不明なことを分かったふりで埋めない。
- 長文の感想ではなく、短く durable な要約を優先する。
