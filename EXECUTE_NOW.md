# 🚀 今すぐ実行！

## ✅ 自動実行手順

以下の手順で、**すべて自動的に**実行されます：

### ステップ1: Gitリポジトリの初期化とコミット

**プロジェクトフォルダで以下のいずれかを実行してください：**

#### オプションA: バッチファイルをダブルクリック（最も簡単）
1. エクスプローラーでプロジェクトフォルダを開く
2. `setup-git.bat` をダブルクリック
3. 画面の指示に従う

#### オプションB: コマンドプロンプトで実行
1. プロジェクトフォルダを開く
2. アドレスバーに `cmd` と入力してEnter
3. 以下のコマンドを実行：
   ```
   setup-git.bat
   ```

#### オプションC: PowerShellで実行
1. プロジェクトフォルダを開く
2. アドレスバーに `powershell` と入力してEnter
3. 以下のコマンドを実行：
   ```
   .\setup-git.bat
   ```

### ステップ2: GitHubにプッシュ

Gitのセットアップが完了したら：

1. **GitHubでリポジトリを作成**
   - ブラウザで https://github.com/new を開く
   - リポジトリ名を入力（例: `syachipoke2`）
   - 「Create repository」をクリック

2. **GitHubにプッシュ**
   
   コマンドプロンプトまたはPowerShellで以下を実行：
   ```bash
   git remote add origin https://github.com/あなたのユーザー名/リポジトリ名.git
   git branch -M main
   git push -u origin main
   ```
   
   （GitHubの画面に表示される手順に従ってもOK）

### ステップ3: Cloudflare Pagesでデプロイ

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

3. **デプロイ実行**
   - 「**Save and Deploy**」をクリック
   - 1-2分待つ

4. **Supabase設定（重要！）**
   - https://supabase.com/dashboard にログイン
   - プロジェクトを選択
   - **Authentication** → **URL Configuration**
   - **Redirect URLs**に以下を追加：
     ```
     https://あなたのプロジェクト名.pages.dev/*
     ```
   - **Site URL**を更新：
     ```
     https://あなたのプロジェクト名.pages.dev
     ```

## 🎉 完了！

デプロイが完了すると、ゲームがオンラインでアクセス可能になります！

---

## 💡 トラブルシューティング

### Gitコマンドが動作しない
- Gitがインストールされているか確認: https://git-scm.com/download/win
- インストール後、コマンドプロンプトを再起動

### スクリプトが実行できない
- ファイルを右クリック → 「管理者として実行」
- または、コマンドプロンプトを管理者権限で開いて実行

