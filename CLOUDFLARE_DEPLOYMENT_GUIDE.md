# Cloudflare Pages デプロイガイド

このガイドでは、シャチポケ２をCloudflare Pagesでオンライン公開する手順を説明します。

## 前提条件

- Cloudflareアカウント（無料で作成可能）
- GitHubアカウント（またはGitLab、Bitbucket）
- プロジェクトがGitリポジトリとして管理されていること

## デプロイ手順

### ステップ1: プロジェクトをGitリポジトリにプッシュ

1. **Gitリポジトリの初期化（まだの場合）**
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   ```

2. **GitHubにリポジトリを作成**
   - GitHubにログイン
   - 新しいリポジトリを作成（例: `syachipoke2`）
   - リポジトリをプライベートまたはパブリックに設定

3. **ローカルリポジトリをGitHubにプッシュ**
   ```bash
   git remote add origin https://github.com/あなたのユーザー名/syachipoke2.git
   git branch -M main
   git push -u origin main
   ```

### ステップ2: Cloudflare Pagesでプロジェクトを接続

1. **Cloudflareダッシュボードにアクセス**
   - https://dash.cloudflare.com にログイン

2. **Pagesセクションに移動**
   - 左サイドバーから「**Pages**」を選択
   - または「**BUILD**」→「**Pages**」をクリック

3. **新しいプロジェクトを作成**
   - 「**Create a project**」または「**接続する**」ボタンをクリック
   - 「**Connect to Git**」を選択

4. **Gitリポジトリを接続**
   - GitHub（またはGitLab/Bitbucket）を選択
   - 認証を許可
   - 作成したリポジトリを選択

### ステップ3: ビルド設定

Cloudflare Pagesの設定画面で以下を設定：

**プロジェクト名**: `syachipoke2`（任意の名前）

**プロダクションブランチ**: `main`

**ビルドコマンド**: （空欄のまま - 静的サイトなので不要）

**ビルド出力ディレクトリ**: `/`（ルートディレクトリ）

**ルートディレクトリ**: （空欄のまま）

**環境変数**: （後で設定）

### ステップ4: 環境変数の設定（オプション）

Supabaseのキーなどを環境変数として設定する場合：

1. プロジェクト設定の「**Environment variables**」セクションに移動
2. 以下の変数を追加（必要に応じて）：
   - `VITE_SUPABASE_URL`（Supabase URL）
   - `VITE_SUPABASE_ANON_KEY`（Supabase Anon Key）

**注意**: 現在のコードではSupabaseのキーが直接HTMLに記述されている可能性があります。セキュリティのため、環境変数を使用することを推奨します。

### ステップ5: デプロイの実行

1. 「**Save and Deploy**」をクリック
2. デプロイが完了するまで待機（通常1-2分）
3. デプロイが完了すると、自動的にURLが生成されます
   - 例: `https://syachipoke2.pages.dev`

### ステップ6: カスタムドメインの設定（オプション）

独自ドメインを使用する場合：

1. プロジェクトの「**Custom domains**」セクションに移動
2. 「**Set up a custom domain**」をクリック
3. ドメイン名を入力（例: `syachipoke.life`）
4. CloudflareのDNS設定に従って設定を完了

## 自動デプロイの設定

GitHubにプッシュするたびに自動的にデプロイされるように設定されます（デフォルトで有効）。

- `main`ブランチへのプッシュ → プロダクション環境にデプロイ
- その他のブランチへのプッシュ → プレビュー環境にデプロイ

## トラブルシューティング

### デプロイが失敗する場合

1. **ビルドログを確認**
   - プロジェクトの「**Deployments**」タブでログを確認

2. **ファイルパスの確認**
   - すべてのファイルが正しくコミットされているか確認
   - `.gitignore`で必要なファイルが除外されていないか確認

3. **Supabaseの設定確認**
   - SupabaseのURLとキーが正しく設定されているか確認
   - CORS設定でCloudflare Pagesのドメインが許可されているか確認

### 画像や動画が表示されない場合

1. **ファイルパスの確認**
   - 相対パスが正しいか確認（例: `./10_社畜アイコン/001.png`）
   - 大文字小文字を区別する環境では注意が必要

2. **ファイルサイズの確認**
   - Cloudflare Pagesの無料プランでは100MBまでのファイルサイズ制限があります
   - 大きな動画ファイルがある場合は、外部ストレージ（Cloudflare R2など）の使用を検討

### CORSエラーが発生する場合

Supabaseのダッシュボードで以下を設定：

1. **Authentication** → **URL Configuration**
2. **Redirect URLs**に以下を追加：
   - `https://あなたのプロジェクト名.pages.dev/*`
   - `https://あなたのカスタムドメイン/*`
   - `https://あなたのプロジェクト名.pages.dev/auth-callback.html`
   - `https://あなたのカスタムドメイン/auth-callback.html`

3. **Site URL**も更新：
   - `https://あなたのプロジェクト名.pages.dev`
   - または `https://あなたのカスタムドメイン`

**重要**: 現在のコードではSupabaseのURLとAnon Keyが直接HTMLに記述されています。これは動作しますが、環境変数を使用することを推奨します。

## パフォーマンス最適化

Cloudflare Pagesは自動的に以下を提供します：

- **CDN配信**: 世界中のエッジサーバーから高速配信
- **自動HTTPS**: SSL証明書の自動設定
- **キャッシュ最適化**: 静的アセットの自動キャッシュ

## Supabase設定の確認

デプロイ前に、Supabaseの設定を確認してください：

1. **Supabaseダッシュボードにログイン**
   - https://supabase.com/dashboard

2. **プロジェクト設定を確認**
   - 現在のSupabase URL: `https://uvrzanksalwjnxoreijl.supabase.co`
   - このURLとAnon Keyが正しく動作しているか確認

3. **認証設定を更新**
   - **Authentication** → **URL Configuration**
   - **Redirect URLs**にCloudflare PagesのURLを追加
   - **Site URL**を更新

## 次のステップ

1. **カスタムドメインの設定**: より覚えやすいURLに変更
2. **Analyticsの設定**: Cloudflare Analyticsでアクセス解析
3. **セキュリティ設定**: Cloudflareのセキュリティ機能を有効化
4. **環境変数の使用**: Supabaseのキーを環境変数に移行（オプション）

## 参考リンク

- [Cloudflare Pages ドキュメント](https://developers.cloudflare.com/pages/)
- [Cloudflare Pages 料金プラン](https://pages.cloudflare.com/)

