# 🚀 シャチポケ２ - Cloudflare Pages デプロイガイド

## ✅ 準備完了！

デプロイに必要なファイルはすべて準備されました。以下の手順でデプロイできます。

## 📋 デプロイ手順（3ステップ）

### ステップ1: Gitリポジトリのセットアップ（5分）

**方法A: スクリプトを実行（推奨）**

プロジェクトフォルダで以下のいずれかを実行：

- **PowerShell**: `.\setup-git.ps1`
- **コマンドプロンプト**: `setup-git.bat`

**方法B: 手動で実行**

プロジェクトフォルダで以下のコマンドを実行：

```bash
git init
git add .
git commit -m "Initial commit: シャチポケ２ ready for Cloudflare Pages"
```

### ステップ2: GitHubにプッシュ（5分）

1. **GitHubでリポジトリを作成**
   - https://github.com/new にアクセス
   - リポジトリ名を入力（例: `syachipoke2`）
   - **Public** または **Private** を選択
   - 「Create repository」をクリック

2. **GitHubにプッシュ**

   ```bash
   git remote add origin https://github.com/あなたのユーザー名/リポジトリ名.git
   git branch -M main
   git push -u origin main
   ```

   （GitHubで表示される手順に従ってもOK）

### ステップ3: Cloudflare Pagesでデプロイ（10分）

1. **Cloudflare Pagesに接続**
   - https://dash.cloudflare.com にログイン
   - 左サイドバー → **Pages** → **Create a project**
   - **Connect to Git** をクリック
   - **GitHub** を選択して認証
   - 作成したリポジトリを選択

2. **プロジェクト設定**
   - **Project name**: `syachipoke2`（任意）
   - **Production branch**: `main`
   - **Build command**: （空欄のまま）
   - **Build output directory**: `/`（スラッシュのみ）
   - **Root directory**: （空欄のまま）

3. **デプロイ実行**
   - 「**Save and Deploy**」をクリック
   - デプロイ完了を待つ（1-2分）

4. **Supabase設定（重要！）**
   - https://supabase.com/dashboard にログイン
   - プロジェクトを選択
   - **Authentication** → **URL Configuration**
   - **Redirect URLs**に追加：
     ```
     https://あなたのプロジェクト名.pages.dev/*
     https://あなたのプロジェクト名.pages.dev/auth-callback.html
     ```
   - **Site URL**を更新：
     ```
     https://あなたのプロジェクト名.pages.dev
     ```
   - 「Save」をクリック

## 🎉 完了！

デプロイが完了すると、以下のようなURLが表示されます：
```
https://syachipoke2.pages.dev
```

このURLにアクセスして、ゲームが正常に動作することを確認してください！

## 📁 準備されたファイル

- ✅ `index.html` - working-game.htmlにリダイレクト
- ✅ `_redirects` - Cloudflare Pages用リダイレクト設定
- ✅ `wrangler.toml` - Cloudflare設定ファイル（オプション）
- ✅ `setup-git.ps1` / `setup-git.bat` - Gitセットアップスクリプト
- ✅ `DEPLOY_STEPS.md` - 詳細なデプロイ手順
- ✅ `CLOUDFLARE_DEPLOYMENT_GUIDE.md` - 包括的なガイド
- ✅ `CLOUDFLARE_QUICKSTART.md` - クイックスタート

## 🔧 トラブルシューティング

### Gitコマンドが動作しない

- Gitがインストールされているか確認: https://git-scm.com/download/win
- インストール後、コマンドプロンプトを再起動

### デプロイが失敗する

- Cloudflare Pagesの「Deployments」タブでログを確認
- すべてのファイルがGitにコミットされているか確認: `git status`

### 認証が動作しない

- SupabaseのRedirect URLsが正しく設定されているか確認
- ブラウザのコンソール（F12）でエラーを確認
- SupabaseのSite URLが最新のCloudflare Pages URLと一致しているか確認

### 画像や動画が表示されない

- ファイルパスが正しいか確認
- ファイルサイズが100MB以下か確認（Cloudflare Pagesの制限）
- Gitにファイルがコミットされているか確認

## 📚 詳細ドキュメント

- **DEPLOY_STEPS.md** - ステップバイステップの詳細手順
- **CLOUDFLARE_DEPLOYMENT_GUIDE.md** - 包括的なデプロイガイド
- **CLOUDFLARE_QUICKSTART.md** - 5分クイックスタート

## 💡 ヒント

- カスタムドメインを使用する場合は、Cloudflare Pagesの「Custom domains」セクションから設定できます
- GitHubにプッシュするたびに自動的にデプロイされます
- プレビューデプロイも自動的に作成されます（main以外のブランチ）

---

**質問や問題がある場合は、エラーメッセージと一緒に確認してください！**

