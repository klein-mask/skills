---
name: implement-draft-eli5
description: implement-draftのeli5版。手順書を .draft/<id>.md ではなく、絵が主役・言葉最小限の単一HTML（.draft/<id>.html）として生成・更新する。
disable-model-invocation: true
---

# implement-draft-eli5

implement-draft と同じ運用（AIは手順書だけを書き、人間が写経する）で、手順書の見た目だけを eli5 スタイルにする。絵→言葉の順、言葉は最小限、ただしコードは完全。

## 手順

1. [../implement-draft/SKILL.md](../implement-draft/SKILL.md) を読み、その原則と手順にすべて従う
2. ただし手順書の出力を差し替える: `.draft/<id>.md` ではなく `.draft/<id>.html` を、[format.md](format.md) に従って書く（既にあれば更新する）
3. コード・テストの中身に関する規則（red→green の対、完全コード、意図コメント、日本語のテスト名、ステップ順序等）は [../implement-draft/format.md](../implement-draft/format.md) の「書き方の規則」にそのまま従う。format.md が置き換えるのは見た目（Markdown→HTML）だけ
