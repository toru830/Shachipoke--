# デプロイ実行手順

## ✅ 準備完了！

以下のファイルが準備されました：
- ✅ `index.html` - working-game.htmlにリダイレクト
- ✅ `_redirects` - Cloudflare Pages用リダイレクト設定
- ✅ `wrangler.toml` - Cloudflare設定ファイル（オプション）

## 🚀 次のステップ

### ステップ1: Gitリポジトリの初期化とコミット

プロジェクトフォルダで以下のコマンドを実行：

```bash
# Gitリポジトリを初期化（まだの場合）
git init

# すべてのファイルを追加
git add .

# 初回コミット
git commit -m "Initial commit: シャチポケ２ ready for Cloudflare Pages"
```

### ステップ2: GitHubにリポジトリを作成

1. https://github.com にログイン
2. 右上の「+」→「New repository」をクリック
3. リポジトリ名を入力（例: `syachipoke2`）
4. **Public** または **Private** を選択
5. 「Create repository」をクリック

### ステップ3: GitHubにプッシュ

GitHubで作成したリポジトリのURLを使って：

```bash
# リモートリポジトリを追加（URLは実際のものに置き換えてください）
git remote add origin https://github.com/あなたのユーザー名/syachipoke2.git

# メインブランチに変更
git branch -M main

# GitHubにプッシュ
git push -u origin main
```

### ステップ4: Cloudflare Pagesで接続

1. https://dash.cloudflare.com にログイン
2. 左サイドバーから「**Pages**」を選択
3. 「**Create a project**」または「**接続する**」をクリック
4. 「**Connect to Git**」を選択
5. GitHubを選択して認証
6. 作成したリポジトリ（`syachipoke2`）を選択
7. プロジェクト設定：
   - **Project name**: `syachipoke2`（任意）
   - **Production branch**: `main`
   - **Build command**: （空欄のまま）
   - **Build output directory**: `/`（スラッシュのみ）
8. 「**Save and Deploy**」をクリック

### ステップ5: Supabase設定（重要！）

1. https://supabase.com/dashboard にログイン
2. プロジェクトを選択
3. 左サイドバー → **Authentication** → **URL Configuration**
4. **Redirect URLs**に以下を追加：
   ```
   https://syachipoke2.pages.dev/*
   https://syachipoke2.pages.dev/auth-callback.html
   ```
   （実際のプロジェクト名に合わせて変更してください）
5. **Site URL**を更新：
   ```
   https://syachipoke2.pages.dev
   ```
6. 「**Save**」をクリック

### ステップ6: 確認

デプロイ完了後（通常1-2分）：
- Cloudflare PagesからURLが提供されます（例: `https://syachipoke2.pages.dev`）
- そのURLにアクセスしてゲームが動作することを確認
- 認証機能もテストしてください

## 📝 トラブルシューティング

### Gitコマンドが動作しない場合
- Gitがインストールされているか確認: `git --version`
- インストール: https://git-scm.com/download/win

### デプロイが失敗する場合
- Cloudflare Pagesの「Deployments」タブでログを確認
- すべてのファイルがGitにコミットされているか確認

### 認証が動作しない場合
- SupabaseのRedirect URLsが正しく設定されているか確認
- ブラウザのコンソール（F12）でエラーを確認

## 🎉 完了！

デプロイが成功すると、ゲームはオンラインでアクセス可能になります！

