# Cloudflare Pages クイックスタート

## 5分でデプロイ！

### ステップ1: GitHubにプッシュ（2分）

```bash
# まだGitリポジトリでない場合
git init
git add .
git commit -m "Initial commit"

# GitHubでリポジトリを作成後
git remote add origin https://github.com/あなたのユーザー名/リポジトリ名.git
git branch -M main
git push -u origin main
```

### ステップ2: Cloudflare Pagesで接続（2分）

1. https://dash.cloudflare.com にログイン
2. 左サイドバー → **Pages** → **Create a project**
3. **Connect to Git** → GitHubを選択
4. リポジトリを選択
5. 設定：
   - **ビルドコマンド**: （空欄）
   - **ビルド出力ディレクトリ**: `/`
6. **Save and Deploy** をクリック

### ステップ3: Supabase設定（1分）

1. https://supabase.com/dashboard にログイン
2. プロジェクトを選択
3. **Authentication** → **URL Configuration**
4. **Redirect URLs**に追加：
   ```
   https://あなたのプロジェクト名.pages.dev/*
   ```
5. **Site URL**を更新：
   ```
   https://あなたのプロジェクト名.pages.dev
   ```

### 完了！

デプロイが完了すると、以下のようなURLが生成されます：
```
https://あなたのプロジェクト名.pages.dev
```

このURLにアクセスして、ゲームが動作することを確認してください！

## トラブルシューティング

### デプロイが失敗する
- ビルドログを確認（Cloudflare PagesのDeploymentsタブ）
- すべてのファイルがGitにコミットされているか確認

### 認証が動作しない
- SupabaseのRedirect URLsに正しいURLが設定されているか確認
- ブラウザのコンソールでエラーを確認

### 画像が表示されない
- ファイルパスが正しいか確認
- ファイルがGitにコミットされているか確認

詳細は `CLOUDFLARE_DEPLOYMENT_GUIDE.md` を参照してください。

