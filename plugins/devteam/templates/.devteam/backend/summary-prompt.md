# Backend Summary Prompt

今回の実装とテストを前提に、監査AIへ渡す「仕様サマリ」を作って下さい。

## 制約

- 12行以内
- Public API（関数/ルート）、入力、出力、主要分岐（境界値）、エラー時挙動だけを書く
- テストで観測可能な外部挙動のみを書く（ステータス/レスポンス/副作用）
- "実装詳細"は書かない（private/内部関数名は極力出さない）
- 元の仕様と実装で食い違いがあれば [DEVIATION] に記載
- 書式は以下テンプレを厳守

## 書式

[TITLE]
[PUBLIC API]
[RULES]
[BRANCHES]
[ERRORS]
[ASSUMPTIONS]
[DEVIATION]
