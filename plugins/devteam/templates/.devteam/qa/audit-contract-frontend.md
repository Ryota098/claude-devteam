# Frontend Audit Contract

## Goal
- 動いているように見えて本番で壊れる状態を検出する

## Rules
- 推測で OK と言わない
- OK なら必ず根拠を示す
- 根拠が出せないものは未網羅扱いにする
- 提示されていないコードやファイルに基づく判断は禁止
- 監査対象は仕様サマリの PUBLIC API / RULES / BRANCHES のみ

## C1 Definition
- 主要な分岐（if/switch/三項演算子/早期return/条件付きレンダリング/エラーハンドリング）の各枝を最低1回通すこと

## Audit Output Order
1. 仕様→実装対応表
2. C1（分岐）網羅表
3. 状態管理の懸念
4. 非同期・ライフサイクルの懸念
5. コンポーネント間連携の懸念
6. 型安全性の懸念
7. 仕様自体の欠陥
8. 追加すべき最小検証項目
9. すり抜けリスク

## Required Risk Checks
- loading / error / empty / normal の4状態を扱っているか
- 二重送信防止があるか
- アンマウント後の state 更新が考慮されているか
- APIレスポンスの schema 検証があるか
- エラーメッセージが適切か
- 外部API失敗・タイムアウト時のUI挙動があるか
- 認証切れ・未認証時の挙動があるか
- race 条件が未考慮でないか
- global store 変更が意図せず波及していないか
- useEffect の dependency 配列が整合しているか
