---
name: handoff
description: 現在のセッション内容を圧縮し、次のセッションがすぐ再開できるよう .devteam の handoff を更新します。
disable-model-invocation: true
---

# devteam:handoff

次のセッションが最小限の読込で再開できるように `.devteam/` を更新します。

## 目的

会話メモリを、短く構造化された handoff 文書へ置き換えること。

## 必須の動作

1. `shared/session-handoff.md` を更新し、少なくとも以下を含める。
   - current goal
   - current state
   - major files touched
   - open issues
   - next step
   - warnings
2. handoff は短く保つ。理想は1画面で読める長さとする。
3. 現在タスクや done criteria が変わった場合は `pm/current-task.md` も更新する。
4. 今回触る範囲が変わった場合は `project/current-workset.md` も更新する。
5. このセッションで current feature の理解が大きく変わった場合は、必要に応じて以下も更新する。
   - `backend/current-feature.md`
   - `frontend/current-feature.md`
   - `biz/current-brief.md`
6. 会話全文を `.devteam/` に貼り付けない。

## 実行手順

### Step 1: 現在の作業状態を整理

まず、このセッションで行ったことを以下の観点で整理する。

- 何を目標にしていたか
- 何が終わったか
- 何がまだ終わっていないか
- どのファイルを見たか / 触ったか
- 次に何をすべきか
- 次回の注意点は何か

### Step 2: `shared/session-handoff.md` の更新

少なくとも以下の節を最新状態に更新する。

- `Current Goal`
- `Current State`
- `Files Touched`
- `Open Issues`
- `Next Step`
- `Warnings`

このファイルは履歴ではなく、最新 handoff として上書きする。

### Step 3: 関連する current ファイルの整合

必要に応じて以下も更新する。

- `pm/current-task.md`
  - 現在タスクや done criteria が変わった場合
- `project/current-workset.md`
  - 今回触る範囲や cross-layer impact が変わった場合
- `backend/current-feature.md`
  - backend 側の現在理解が変わった場合
- `frontend/current-feature.md`
  - frontend 側の現在理解が変わった場合
- `biz/current-brief.md`
  - biz 向け説明内容に影響が出た場合

### Step 4: 次セッションの入口を明確化

- `Next Step` には、次セッションで最初にやるべき 1 アクションだけを書く
- 曖昧な表現ではなく、着手可能な粒度で書く
- 例:
  - `X endpoint の 400/409 分岐を実装してテスト追加`
  - `frontend の loading/error 表示を仕様に合わせて修正`
  - `auth flow の unknowns を architecture/unknowns.md から解消`

## handoff の長さ

- 理想は 1 画面で読める長さ
- 目安は 10〜25 行程度
- 長くても 40 行未満
- 長文化しそうなら、詳細は他の current / history ファイルへ分離し、handoff には要点だけ残す

## handoff に書くべきでないもの

- 会話全文
- 感想だけの文章
- 根拠のない推測
- 大量のコード断片
- すでに他ファイルにある詳細仕様の重複貼り付け

## どういう時に実行するか

- セッションが重くなった時
- 実装が一区切りついた時
- 監査セッションへ渡す前
- 別の役割のセッションへ切り替える前

## 出力時の期待内容

- handoff を更新したことを簡潔に伝える。
- 次セッションの最初の1アクションを示す。

## 出力例の方針

- 3〜6行程度でよい
- 例:
  - handoff を更新したこと
  - 関連して更新した current ファイル
  - 次の 1 アクション

## やってはいけないこと

- handoff を長い作業日誌にすること
- `current-task.md` と矛盾した内容を残すこと
- 未確定事項を確定事項のように書くこと
- 次ステップを複数並べて焦点をぼかすこと

## 注意

- 保存すべきなのは会話履歴ではなく、durable な要点である。
