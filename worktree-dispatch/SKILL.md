---
name: worktree-dispatch
description: Dispatch a scoped implementation task to an isolated herdr worktree with a fresh agent, instead of editing files in the current working tree. Use the moment a task turns from discussion into a concrete, buildable unit of work — a tracked issue, a PRD sub-issue, or an agreed plan — while HERDR_ENV=1, and before writing or editing any implementation file for it.
---

# worktree-dispatch

`HERDR_ENV=1` が前提。未設定ならこのスキルは適用外——通常通りその場で実装する。

## いつ発火するか

設計や要件のすり合わせが続いている間は発火しない。次の状態に切り替わった**瞬間**に発火する。

- 実装対象のスコープが一文で言える
- 対応するissue（Linear/GitHubなど）が存在する、またはこの場で作れる

このタイミングを逃すと、そのまま今のワーキングツリーで編集を始めてしまう。「まず1ファイル試しに書いてみる」も対象——1行でも実装ファイルを編集する前にこのスキルを経由する。

## 手順

1. **プロジェクト固有フローの確認**: リポジトリのCLAUDE.md/AGENTS.mdにworktree運用の指示（ブランチ命名規則・ラベル・投入するコマンド・完了条件など）があれば、それに従う。以下はプロジェクトが何も定義していない場合のデフォルト手順。

2. **作業単位の確定**: 対応するissueを確認または作成する。並行着手できる単位（例: ブロッカーが解消済みの複数サブissue）があれば、単位ごとに1 worktreeを作る前提で数える。

3. **worktreeを作る**（CLI詳細はherdr skill参照）。ローカルのデフォルトブランチは古い可能性があるため、必ず `git fetch` してから `--base origin/<デフォルトブランチ>` を明示する。ローカルブランチ基点で作らない:
   ```
   git -C <repo root> fetch origin
   herdr worktree create --cwd <repo root> --branch <branch> --base origin/main --label "<label>" --no-focus --json
   ```
   作成後、worktree の `git log --oneline -1` が origin/main の先端コミットと一致することを確認してから投入する。ブロッカーissueのマージ直後は特に注意——そのマージが基点に含まれていなければ意味がない。

4. **投入する**: 新しいworktreeのroot paneでエージェントを起動し、そのプロジェクトの実装コマンド（例: `/implement`）またはタスクの説明をそのまま渡す。`claude`を素で起動するとherdr経由ではユーザーのデフォルトモデル設定が反映されないことがあるため、`--model`で明示的に指定する（省略しない）:
   ```
   herdr pane run <root_pane_id> "claude --model sonnet '<command-or-prompt>'"
   ```
   どのモデルを使うべきか不明な場合は、コーディネーター自身が使っているモデルに合わせる。

5. **発火確認して手放す**: `herdr pane read <root_pane_id>` で正しいタスクに着手したことだけ確認する。完了まで同期的に待たない——PR作成以降のステータス更新（In Review等）は、そのプロジェクトの規約に従って投入先のエージェントが担う。

6. **issueを In Progress にする**: 着手確認できたら、対応するissueのステータスをトラッカー上の「作業中」（Linear なら In Progress）に更新する。投入先エージェント任せにしない——エージェントによっては更新しないまま実装を進めるため、dispatch した側が worktree 作成の時点で確実に反映する。

7. **報告**: どのworktree/ブランチ/paneが何を実行中かを一言で伝える。
