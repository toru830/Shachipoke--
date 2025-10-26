# Supabase Phase 1 実装ガイド

## 🎯 Phase 1: 基本設定とGoogle認証

### Step 1: Supabaseプロジェクト作成

1. **Supabaseにアクセス**
   - https://supabase.com にアクセス
   - 「Start your project」をクリック
   - GitHubアカウントでログイン

2. **新しいプロジェクト作成**
   - 「New Project」をクリック
   - プロジェクト名: `shachipoke2`
   - データベースパスワード: 強力なパスワードを設定
   - リージョン: `Northeast Asia (Tokyo)` を選択

3. **プロジェクト設定を取得**
   - プロジェクトダッシュボードで以下を確認:
     - Project URL
     - Project API Key (anon/public)

### Step 2: Google認証設定

1. **Google Cloud Console設定**
   - https://console.cloud.google.com にアクセス
   - 新しいプロジェクト作成: `shachipoke2-auth`
   - 「APIとサービス」→「認証情報」
   - 「認証情報を作成」→「OAuth 2.0 クライアント ID」

2. **OAuth設定**
   - アプリケーションの種類: `ウェブアプリケーション`
   - 承認済みのリダイレクト URI:
     ```
     https://your-project.supabase.co/auth/v1/callback
     ```

3. **SupabaseでGoogle認証有効化**
   - Supabaseダッシュボード → Authentication → Providers
   - Google を有効化
   - Client ID と Client Secret を入力

### Step 3: データベース設計

```sql
-- ユーザープロフィールテーブル
CREATE TABLE profiles (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  display_name TEXT,
  avatar_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ゲームセーブデータテーブル
CREATE TABLE game_saves (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  game_name TEXT NOT NULL DEFAULT 'shachipoke2',
  save_data JSONB NOT NULL,
  version TEXT DEFAULT '1.0.0',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, game_name)
);

-- セキュリティ設定
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE game_saves ENABLE ROW LEVEL SECURITY;

-- ユーザーは自分のデータのみアクセス可能
CREATE POLICY "Users can view own profile" ON profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can view own saves" ON game_saves
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own saves" ON game_saves
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own saves" ON game_saves
  FOR UPDATE USING (auth.uid() = user_id);
```

### Step 4: 環境変数設定

`.env.local` ファイルを作成:
```env
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
```

### Step 5: 依存関係インストール

```bash
npm install @supabase/supabase-js
```

## 📋 次のステップ

Phase 1完了後、Phase 2でフロントエンド実装に進みます。
