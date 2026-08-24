# 手順書のフォーマット（eli5 HTML版）

`.draft/<id>.html` として書く。単一ファイル・外部リソース読み込み禁止（CDN・外部フォント・画像ファイル不可）。人間はブラウザで `file://` で開く。

## eli5 の原則

- **絵→言葉の順**。まず全体像の絵（inline SVG）で「何がどう繋がるか」を見せ、言葉は絵の補足に留める
- **言葉は最小限・平易に**。「なぜ」「確認」は1文。長くなる説明は `<details>` に畳む
- **コードだけは省略しない**。写す単位で完全に載せる（implement-draft/format.md の規則どおり）

## 構成（上から順に）

1. **タイトルとゴール**: `<id>: 何を作るか一言` + ゴール1文（🏁カード）
2. **全体像**: inline SVG 1枚。箱=ファイル、矢印=呼び出し/データの流れ、箱や矢印に Step 番号を添える。ラベルは単語レベルに絞る
3. **ステップマップ**: Step チップの横並び（`<nav class="map">`）。各チップは対応ステップへのアンカーリンクで、red/green の色と完了✅を持つ。目次の代わり
4. **既存の不具合**: ⚠️カード（`.warn`）。無ければセクションごと省く
5. **ステップカード**（`<section class="step">` × N）: 各カードは
   - 見出し: `Step N` + `RED`/`GREEN` バッジ + 何をするか一言
   - 対象: 📄 ファイルパス +（新規 or 修正）
   - なぜ: 1文（差分から読み取れない判断だけ）
   - コード: `<pre><code>` に完全コード。`&` `<` `>` は必ずHTMLエスケープする
   - 確認: ▶ コマンド + 期待結果（❌失敗すればOK / ✅通ればOK）を red/green の色で
6. **最終確認**: 🏁カード。人間がローカルで実行する全テスト・型チェック等のコマンド

更新時: 実装済みステップはチップとカードに `done` クラスと ✅ を付けて残し、これからの部分だけを最新化する。

## テンプレート

このスケルトンをそのまま使う（CSS・JSは変更せずコピー。ステップ数に応じて中身だけ増やす）:

```html
<!doctype html>
<html lang="ja">
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>PROJ-123: ログイン機能</title>
<style>
  :root { --red:#e5484d; --green:#30a46c; --ink:#1c2024; --muted:#6b7280; }
  body { font-family: system-ui, sans-serif; color:var(--ink); background:#f4f5f7; margin:0; line-height:1.7; }
  main { max-width:860px; margin:0 auto; padding:24px 16px 80px; }
  h1 { font-size:1.4rem; } h2 { font-size:1.1rem; margin-top:0; }
  .card { background:#fff; border-radius:12px; padding:16px 20px; margin:16px 0; box-shadow:0 1px 3px rgba(0,0,0,.06); }
  .goal { border-left:4px solid var(--green); }
  .warn { border-left:4px solid #f59e0b; background:#fff7ed; }
  .overview svg { width:100%; height:auto; }
  .overview figcaption { color:var(--muted); font-size:.85rem; text-align:center; }
  .map { display:flex; gap:8px; flex-wrap:wrap; margin:16px 0; }
  .map a { text-decoration:none; padding:6px 14px; border-radius:999px; background:#fff; border:2px solid #ddd; color:var(--ink); font-size:.85rem; }
  .map a.red { border-color:var(--red); } .map a.green { border-color:var(--green); }
  .map a.done, section.done { opacity:.55; }
  .badge { display:inline-block; padding:1px 10px; border-radius:999px; color:#fff; font-size:.72rem; font-weight:700; vertical-align:middle; }
  .badge.red { background:var(--red); } .badge.green { background:var(--green); }
  .target { font-family:ui-monospace,monospace; font-size:.85rem; color:var(--muted); margin:4px 0; }
  pre { position:relative; background:#0f1214; color:#e8e8e8; padding:16px; border-radius:8px; overflow-x:auto; font-size:.84rem; line-height:1.5; }
  pre code { font-family:ui-monospace,Menlo,monospace; }
  pre .copy { position:absolute; top:8px; right:8px; border:0; border-radius:6px; padding:4px 10px; font-size:.75rem; cursor:pointer; background:#2a2f35; color:#ccc; }
  .check { border-left:4px solid; padding:8px 12px; border-radius:6px; background:#fafafa; font-size:.9rem; }
  .check.red { border-color:var(--red); } .check.green { border-color:var(--green); }
  .check code { background:#eee; padding:1px 6px; border-radius:4px; }
  details { margin:8px 0; } details summary { cursor:pointer; color:var(--muted); }
</style>
<main>

<h1>PROJ-123: ログイン機能をつくる</h1>
<p class="card goal">🏁 <b>ゴール:</b> メールとパスワードでログインでき、全テストが通る</p>

<figure class="card overview">
  <svg viewBox="0 0 600 180" role="img" aria-label="全体像">
    <!-- 箱=ファイル、矢印=流れ。Step番号を添える -->
  </svg>
  <figcaption>ブラウザ → ルーティング → コントローラ → モデル の順に流れる</figcaption>
</figure>

<nav class="map">
  <a href="#s1" class="red done">✅ 1. テストを書く</a>
  <a href="#s2" class="green">2. 実装して通す</a>
</nav>

<div class="card warn">⚠️ <b>既存の不具合:</b> どこで何が壊れているか → 今回どう扱うか</div>

<section class="card step done" id="s1">
  <h2>✅ Step 1 <span class="badge red">RED</span> ログインAPIのテストを書く</h2>
  <p class="target">📄 spec/requests/login_spec.rb（新規）</p>
  <p><b>なぜ:</b> 期待する振る舞いを先に固定するため（1文）</p>
  <pre><code># 完全コード。&amp; &lt; &gt; はエスケープ</code></pre>
  <p class="check red">▶ <code>bundle exec rspec spec/requests/login_spec.rb</code> → ❌ 失敗すればOK</p>
</section>

<section class="card step" id="s2">
  <h2>Step 2 <span class="badge green">GREEN</span> 実装して通す</h2>
  ...
  <p class="check green">▶ <code>bundle exec rspec</code> → ✅ 通ればOK</p>
</section>

<section class="card goal">
  <h2>🏁 最終確認</h2>
  <pre><code>bundle exec rspec
bundle exec rubocop</code></pre>
</section>

</main>
<script>
document.querySelectorAll('pre').forEach(pre => {
  const b = document.createElement('button');
  b.className = 'copy'; b.textContent = 'copy';
  b.onclick = () => navigator.clipboard.writeText((pre.querySelector('code') ?? pre).innerText)
    .then(() => { b.textContent = '✓'; setTimeout(() => b.textContent = 'copy', 1200); });
  pre.appendChild(b);
});
</script>
</html>
```
