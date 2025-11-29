# シャチポケ２ - Netlifyデプロイガイド

## 🎯 デプロイ方法

Netlifyへのデプロイ方法は3つあります。お好みの方法を選んでください。

---

## 方法1: Netlify Drag & Drop（最も簡単）✨

### 手順
1. **Netlifyにアクセス**
   - https://app.netlify.com にアクセス
   - Googleアカウントでログイン（推奨）

2. **サイトを作成**
   - ダッシュボードの「Add new site」→「Deploy manually」
   - ドラッグ&ドロップエリアが表示される

3. **フォルダを圧縮**
   - プロジェクトフォルダ全体をZIPファイルに圧縮
   - **注意**: `.git` フォルダは含めないでください

4. **アップロード**
   - ZIPファイルをNetlifyのドロップエリアにドラッグ&ドロップ
   - デプロイが自動的に開始されます

5. **URLを確認**
   - デプロイ完了後、`https://random-name-xxxxx.netlify.app` のようなURLが表示されます
   - これがあなたのゲームの公開URLです！

---

## 方法2: Netlify CLI（開発者向け）⚙️

### 前提条件
- Node.jsがインストールされていること

### 手順

```bash
# 1. Netlify CLIをインストール
npm install -g netlify-cli

# 2. Netlifyにログイン
netlify login

# 3. プロジェクトディレクトリで実行
cd "C:\10_Cursor\42_シャチポケ２"

# 4. サイトを初期化
netlify init

# 5. デプロイ
netlify deploy --prod
```

### ログイン確認
ブラウザが自動的に開き、Netlifyへの認証が完了します。

---

## 方法3: GitHub連携（自動デプロイ）🚀

### 前提条件
- GitHubアカウント
- Gitがインストールされていること

### 手順

#### Step 1: GitHubリポジトリを作成

```bash
# プロジェクトディレクトリで実行
cd "C:\10_Cursor\42_シャチポケ２"

# Gitを初期化
git init

# ファイルを追加（.sql, .mdは除外推奨）
git add working-game.html characters.html *.html *.css *.js *.json *.xml *.txt 10_社畜アイコン 20_movie 30_差し込み画像 icon-*.png favicon.ico

# 最初のコミット
git commit -m "Initial commit: シャチポケ２"

# GitHubリポジトリを作成（GitHub CLI使用）
gh repo create shachipoke2 --public --source=. --push

# または、GitHubウェブサイトで手動作成してから：
# git remote add origin https://github.com/YOUR_USERNAME/shachipoke2.git
# git push -u origin master
```

#### Step 2: NetlifyでGitHub連携

1. Netlifyダッシュボード →「Add new site」→「Import an existing project」
2. 「GitHub」を選択
3. 作成したリポジトリを選択
4. 設定を確認：
   - **Build command**: 空白（または `echo "Static site"`）
   - **Publish directory**: `.`（現在のディレクトリ）
5. 「Deploy site」をクリック

これで、GitHubにプッシュするたびに自動デプロイされます！

---

## 🎨 デプロイ後の設定

### 1. カスタムドメイン設定（任意）

1. Netlifyダッシュボード →「Domain settings」
2. 「Add custom domain」をクリック
3. ドメイン名を入力
4. DNS設定に従ってドメインネームサーバーを更新

### 2. 環境変数設定（Supabase用）

Supabase認証を使用する場合：

1. Netlifyダッシュボード →「Site settings」→「Environment variables」
2. 以下を追加：
   - `SUPABASE_URL`: SupabaseプロジェクトURL
   - `SUPABASE_ANON_KEY`: Supabase匿名キー

### 3. ビルド設定確認

`netlify.toml` が正しく読み込まれているか確認：

1. Netlifyダッシュボード →「Site settings」→「Build & deploy」→「Deploy settings」
2. 設定ファイルが読み込まれていることを確認

---

## ✅ デプロイ確認チェックリスト

デプロイ後に以下を確認してください：

- [ ] サイトが正しく表示される
- [ ] `working-game.html` がルートURLからアクセスできる
- [ ] `characters.html` が正常に表示される
- [ ] 法的文書ページ（`privacy-policy.html`、`terms-of-service.html`、`commercial-transactions.html`）が表示される
- [ ] Google Analyticsが動作している（Google Analyticsダッシュボードで確認）
- [ ] 画像・動画が正しく読み込まれる
- [ ] モバイル表示が正しい
- [ ] HTTPSが有効になっている

---

## 🐛 トラブルシューティング

### 問題1: デプロイが失敗する

**原因**: ファイルサイズが大きい、または文字エンコーディングの問題

**対処法**:
- 大きなファイル（動画など）を除外してデプロイ
- または、Netlifyの無料プランでは100MBの制限があります

### 問題2: 404エラー

**原因**: `netlify.toml` のリダイレクト設定が効いていない

**対処法**:
- `netlify.toml` の設定を確認
- または、ドメイン設定で「HTTPS」を有効化

### 問題3: Supabase認証が動かない

**原因**: 環境変数が設定されていない、またはCORSエラー

**対処法**:
- Netlifyの環境変数を確認
- SupabaseダッシュボードでリダイレクトURLを追加：
  - `https://YOUR_SITE.netlify.app/auth-callback.html`

---

## 📞 サポート

問題が発生した場合：

1. Netlifyのログを確認：ダッシュボード →「Deploys」→ デプロイログ
2. ブラウザのコンソールを確認（F12キー）
3. `working-game.html` のコンソールログを確認

---

## 🎉 デプロイ完了後

デプロイが成功したら：

1. **共有URLを取得**: NetlifyダッシュボードからURLをコピー
2. **SNSで共有**: Twitter、Facebookなどで宣伝
3. **Google Analyticsで確認**: アクセス数が増えるか監視
4. **ユーザーフィードバック収集**: 改善点を見つける

---

**シャチポケ２を世の中にリリースしましょう！** 🐋💼🎮





