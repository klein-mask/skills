---
name: implement-draft-force
description: プロジェクトをimplement-draft運用にopt-inする（CLAUDE.md / AGENTS.mdへ規約文を追記し、ガードhookと .gitignore の .draft/ を設置する）。
disable-model-invocation: true
---

# implement-draft-force

対象プロジェクトをimplement-draft運用（AIは手順書のみ、実装は人間）にopt-inする。すべてgit管理下の変更なので、適用後は人間がレビューしてコミットする。

## 対象ツールの確認

引数に対象ツール（Claude Code / Codex / 両方）の指定がなければ、**どれを対象にするかユーザーに確認してから**進める。推測で選ばない。

## 共通の設置物

1. [rule.md](rule.md) の内容を、マーカーで囲んで規約ファイルの末尾に追記する。追記先はClaude Code対象なら `CLAUDE.md`、Codex対象なら `AGENTS.md`（無ければ新規作成、両方対象なら両方）:

   ```markdown
   <!-- implement-draft:start -->
   （rule.md の内容）
   <!-- implement-draft:end -->
   ```

   既にマーカーがある場合はブロックの中身を最新のrule.mdで置き換える（冪等）

2. 初回のみ、終了マーカーの直後に次の1行を追記する。この行はプロジェクト側のカスタマイズ領域（AIの直接編集を許可するパス・ファイル形式。変更は implement-draft-allow skillで行う）なので、再実行では触らない:

   ```markdown
   AI編集許可: なし
   ```

3. `.gitignore` に `.draft/` を1行追記する（既にあれば何もしない）

4. [hook.sh](hook.sh) を `.agents/hooks/implement-draft-guard.sh` にコピーし、実行権限を付ける（要jq。両ツール共通の1本で、`AI編集許可:` 行を実行時に読むため許可の変更でhookの改修は不要）

## Claude Codeを対象にするとき

`.claude/settings.json` のPreToolUseに登録する（既存のhooks設定があればマージする）:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|Write|NotebookEdit",
        "hooks": [
          { "type": "command", "command": "\"$CLAUDE_PROJECT_DIR/.agents/hooks/implement-draft-guard.sh\"" }
        ]
      }
    ]
  }
}
```

## Codexを対象にするとき

`.codex/hooks.json` を作成する（既にあればマージする）:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "^apply_patch$",
        "hooks": [
          { "type": "command", "command": "bash .agents/hooks/implement-draft-guard.sh" }
        ]
      }
    ]
  }
}
```

適用後、ユーザーにCodex上で `/hooks` を実行してプロジェクトローカルhookを信頼してもらう（初回と、hook変更のたびに必要）。

## 補足

- 天井: ガードが縛るのはEdit / Write / apply_patchによるファイル編集。Bash経由の書き込み（`sed -i` 等）は規約文（ファイルを変更するコマンドは実行しない）の守備範囲
- プロジェクトのポリシーやhookでAIによる直接編集ができない場合は、設置物の内容をそのまま `.draft/force.md` に書き出して人間に渡す
- 規約文を改訂するときは、rule.mdを直してから各プロジェクトで本skillを再実行する
