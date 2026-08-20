---
name: implement-draft-allow
description: implement-draft運用の許可設定（AIが直接編集してよいパス・ファイル形式を列挙する `AI編集許可:` 行）を追加・変更する。
disable-model-invocation: true
---

# implement-draft-allow

opt-in済みプロジェクトの `AI編集許可:` 行（AIが直接編集してよいパス・ファイル形式の列挙）を、引数の指示に沿って更新する。

1. `CLAUDE.md` と `AGENTS.md`（存在する方）の規約ブロック（`<!-- implement-draft:end -->` の直後）にある `AI編集許可:` 行を探す。どちらにも見つからなければ未opt-inなので、implement-draft-force を先に実行するよう案内して終了する
2. 引数の指示（例: 「`docs/` を追加」「`*.md` を外す」）を反映した新しい行を作る。全て外す場合は `AI編集許可: なし` に戻す
3. **行を持つ全ファイルを同じ値に更新する**。git管理下の変更なので、適用後は人間がレビューしてコミットする

プロジェクトのポリシーやhookでAIによる直接編集ができない場合は、更新後の行をそのまま `.draft/allow.md` に書き出して人間に渡す。
