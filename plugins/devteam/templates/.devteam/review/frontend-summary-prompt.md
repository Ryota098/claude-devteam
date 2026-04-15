今回の実装を前提に、監査AIへ渡す「仕様サマリ」を作って下さい。

制約:
- 15行以内
- Public API（コンポーネント/hooks/公開関数）、入力（props/引数/型）、出力（表示内容/発火イベント/副作用）、主要分岐、エラー時挙動だけを書く
- テストで観測可能な外部挙動のみ（DOM変化/コールバック/state変化/副作用）
- 実装詳細は書かない（内部state名・private関数名は極力出さない）
- 元の仕様と実装で食い違いがあれば [DEVIATION] に記載
- 書式は以下テンプレを厳守

[TITLE]
[PUBLIC API]
[PROPS/ARGS]
[RENDER/OUTPUT]
[STATE/SIDE EFFECT]
[BRANCHES]
[ERRORS]
[COMPONENT DEPS]
[ASSUMPTIONS]
[DEVIATION]
