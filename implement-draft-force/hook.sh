#!/usr/bin/env bash
# implement-draft運用のガード: AIの書き込みを .draft/ とAI編集許可の列挙先に限定するPreToolUse hook。
# 入力はClaude Code（tool_input.file_path）とCodex（apply_patchのtool_input.command）の両形式に対応する。
set -euo pipefail
set -f

input=$(cat)

repo_root=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0

# 対象ファイル一覧を組み立てる（Claude Codeは1件、Codexはパッチ内の全対象）
files=$(printf '%s' "$input" | jq -r '.tool_input.file_path // .tool_input.notebook_path // empty')
if [ -z "$files" ]; then
  files=$(printf '%s' "$input" | jq -r '.tool_input.command // .tool_input.patch // empty' \
    | sed -n 's/^\*\*\* \(Add File\|Update File\|Delete File\|Move to\): //p')
fi
[ -z "$files" ] && exit 0

# 「AI編集許可:」行（CLAUDE.md / AGENTS.md の存在する方）に列挙されたパス・ファイル形式は許可
allow=$(grep -h '^AI編集許可:' "$repo_root/CLAUDE.md" "$repo_root/AGENTS.md" 2>/dev/null | head -1 \
  | sed 's/^AI編集許可:[[:space:]]*//' | sed 's/、/ /g; s/,/ /g; s/`//g' || true)

while IFS= read -r file; do
  [ -z "$file" ] && continue
  case "$file" in
    "$repo_root"/*) rel=${file#"$repo_root"/} ;;
    /*) continue ;; # リポジトリ外は対象外
    *) rel=$file ;;
  esac

  # .draft/ は許可
  case "$rel" in .draft/*) continue ;; esac

  ok=""
  if [ -n "$allow" ] && [ "$allow" != "なし" ]; then
    base=$(basename "$rel")
    for p in $allow; do
      case "$p" in
        */) case "$rel" in "$p"*) ok=1 ;; esac ;;
        *) case "$rel" in $p) ok=1 ;; esac
           case "$base" in $p) ok=1 ;; esac ;;
      esac
    done
  fi
  [ -n "$ok" ] && continue

  echo "implement-draft運用: プロジェクトファイルはAIが直接編集しない（$rel）。implement-draftで .draft/ に手順書を作り、実装は人間が行う" >&2
  exit 2
done <<EOF
$files
EOF

exit 0
