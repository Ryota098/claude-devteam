# claude-devteam

`claude-devteam` は、Claude Code 上で `.devteam/` を使った開発運用を始めるための plugin です。

これは「AI が自律的に開発する plugin」ではなく、**開発用ドキュメント基盤を揃え、更新しやすくする plugin** です。

- 初期化では、少数の共通テンプレートを `.devteam/` に配置します
- `discover` では、既存コードや docs を読んで `.devteam/` を更新します
- `handoff` では、次セッション向けに状態を圧縮して残します
- 実装、調査、監査の実行自体は、ユーザーが Claude に依頼して進めます

<br>

# 目次

- [できること](#できること)
- [インストール](#インストール)
- [クイックスタート](#クイックスタート)
- [最小構成](#最小構成)
- [3つの command](#3つの-command)
- [日常運用フロー](#日常運用フロー)
- [Claude への頼み方](#claude-への頼み方)
- [運用ルール](#運用ルール)
- [ライセンス](#ライセンス)

<br>

# できること

- `.devteam/` の deterministic な初期構成を shell script で作る
- 既存案件の理解を `.devteam/` の少数ファイルへ整理する
- セッション切替時に handoff を残す
- 監査用の summary prompt / audit prompt を共通化する

<br>

# インストール

Claude Code で以下を実行します。

```text
/plugin marketplace add Ryota098/claude-devteam
```

```text
/plugin install devteam@claude-devteam
```

```text
/reload-plugins
```

`/plugin install` 直後は、そのセッションで plugin command を使えるようにするため `/reload-plugins` が必要です。

scope の目安:

- `user scope`
  - 自分の複数プロジェクトで使う通常運用向け
- `project scope`
  - その repository の共同開発者にも同じ plugin を前提化したい時
- `local scope`
  - その repository だけで試す時

通常運用では `user scope`、動作確認では `local scope` を推奨します。

<br>

# クイックスタート

## 1. 初期化

対象プロジェクト配下で Claude Code を起動し、次を実行します。

```bash
sh ~/.claude/plugins/marketplaces/claude-devteam/scripts/init-devteam.sh .
```

`~/.claude/plugins/marketplaces/claude-devteam/` は plugin install 後に Claude Code が保持する marketplace の標準配置先です。

既存の `.devteam/` を新しい構成へ入れ替えたい場合は、古い内容を消して再生成します。

```bash
sh ~/.claude/plugins/marketplaces/claude-devteam/scripts/init-devteam.sh . --clean
```

plugin 側の template や script を更新した直後に古い構成が生成される場合は、Claude Code が旧 marketplace cache を使っている可能性があります。その場合は以下を実行して plugin を入れ直してください。

```text
/plugin uninstall devteam
/plugin marketplace remove claude-devteam
/plugin marketplace add Ryota098/claude-devteam
/plugin install devteam@claude-devteam
/reload-plugins
```

その後、あらためて以下を実行します。

```bash
sh ~/.claude/plugins/marketplaces/claude-devteam/scripts/init-devteam.sh . --clean
```

## 2. 既存案件なら discover

既存コードや docs の把握が必要なら、続けてこれを実行します。

```text
/devteam:dt-discover
```

新規案件や、まだ実装がほぼ無い段階では通常不要です。

## 3. セッション切替時は handoff

作業を切り替える前にこれを実行します。

```text
/devteam:dt-handoff
```

<br>

# 最小構成

この plugin は、まず以下の少数ファイルを中心に回す想定です。

```text
.devteam/
├── README.md
├── CLAUDE.md
├── current/
│   ├── spec.md
│   ├── task.md
│   └── handoff.md
├── context/
│   ├── project.md
│   ├── decisions.md
│   └── research.md
├── review/
│   ├── api-summary-prompt.md
│   ├── frontend-summary-prompt.md
│   ├── api-audit-prompt.md
│   ├── frontend-audit-prompt.md
│   ├── implementation-summary.md
│   └── audit.md
└── archive/
    └── notes.md
```

日常的に主に見るのは以下です。

- `current/spec.md`
- `current/task.md`
- `current/handoff.md`
- `review/audit.md`

<br>

# 3つの command

- `/devteam:dt-init`
  - shell script 初期化を案内する補助 command
- `/devteam:dt-discover`
  - 既存 docs とソースコードを読み、`context/project.md` と `current/*` を更新する command
- `/devteam:dt-handoff`
  - 現在の状態を `current/handoff.md` に圧縮して残す command

<br>

# 日常運用フロー

## 1. 壁打ち・調査

- 主に使うファイル
  - `current/spec.md`
  - `context/research.md`
  - `context/decisions.md`
- Claude への依頼例
  - 「この機能の目的、利用者、成功条件を整理して `.devteam/current/spec.md` にまとめて」
  - 「競合や参考実装を調べて `.devteam/context/research.md` に整理して」
  - 「重要な判断だけ `.devteam/context/decisions.md` に残して」

## 2. ドキュメント更新

- 主に使うファイル
  - `current/spec.md`
  - `context/decisions.md`
- Claude への依頼例
  - 「今の壁打ち結果を反映して、必要な `.devteam` を更新して」
  - 「仕様変更があれば `.devteam/current/spec.md` と `.devteam/context/decisions.md` を更新して」

## 3. タスク出し

- 主に使うファイル
  - `current/task.md`
  - `current/spec.md`
- Claude への依頼例
  - 「この仕様を実装タスクへ分解して `.devteam/current/task.md` に反映して」
  - 「今やる 1 タスクだけ明確にして」

## 4. 実装 / テスト / 検証

- 主に使うファイル
  - `current/spec.md`
  - `current/task.md`
  - 必要なら `context/decisions.md`
- Claude への依頼例
  - 「このタスクを実装して。必要なら関連 docs も更新して」
  - 「テストまで追加して、必要なら `.devteam/current/spec.md` も更新して」

## 5. 実装後のサマリ作成

- API 実装後
  - `review/api-summary-prompt.md`
- Frontend 実装後
  - `review/frontend-summary-prompt.md`
- 保存先
  - `review/implementation-summary.md`
- Claude への依頼例
  - 「`.devteam/review/api-summary-prompt.md` に従って仕様サマリを作り、`.devteam/review/implementation-summary.md` に保存して」
  - 「`.devteam/review/frontend-summary-prompt.md` に従って仕様サマリを作り、`.devteam/review/implementation-summary.md` に保存して」

## 6. 監査

- API 監査
  - `review/api-audit-prompt.md`
- Frontend 監査
  - `review/frontend-audit-prompt.md`
- 保存先
  - `review/audit.md`
- Claude への依頼例
  - 「`.devteam/review/api-audit-prompt.md` に従って監査して。結果を `.devteam/review/audit.md` にまとめて」
  - 「`.devteam/review/frontend-audit-prompt.md` に従って監査して。結果を `.devteam/review/audit.md` にまとめて」

## 7. 修正

- 主に使うファイル
  - `review/audit.md`
  - 必要なら `review/implementation-summary.md`
- Claude への依頼例
  - 「`.devteam/review/audit.md` の指摘を反映して修正して」
  - 「修正後に必要なら `.devteam/review/implementation-summary.md` を更新して」

## 8. セッション切り替え

- 主に使うファイル
  - `current/handoff.md`
  - 必要なら `current/task.md`
- Claude への依頼例
  - 「`/devteam:dt-handoff` を実行して次セッション向けに整理して」

<br>

# Claude への頼み方

普段はファイル名を細かく指定しなくて構いません。必要な保存先は Claude が `.devteam/` 内で判断する前提です。

- そのまま使える依頼例
  - 「この機能の要件を整理して、必要な `.devteam` を更新して」
  - 「今やるべきタスクをまとめて、必要な `.devteam` を更新して」
  - 「実装してテストして、必要なら docs も更新して」
  - 「監査に回せる状態にして」
  - 「次セッション向けに `.devteam` を整理して」

slash command を使うのは定型処理だけです。

- `/devteam:dt-discover`
  - 既存案件の理解を一気に進めたい時
- `/devteam:dt-handoff`
  - セッションを切り替えたい時

<br>

# 運用ルール

- 会話セッションは使い捨て
- `.devteam/` は継続状態
- ユーザーは原則、保存先ファイルを毎回指定しなくてよい
- Claude は依頼内容を見て `.devteam/` の適切なファイルを選んで更新する
- 細かいメモや一時情報は `archive/notes.md` に寄せる
- まずは少数ファイルで回し、必要なら後から拡張する

<br>

# ライセンス

MIT
