# Supabase設定ファイル

## 🔧 環境変数設定

`.env.local` ファイルを作成して以下の内容を設定してください：

```env
# Supabase設定
NEXT_PUBLIC_SUPABASE_URL=https://your-project-id.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key-here

# Google OAuth設定（オプション）
GOOGLE_CLIENT_ID=your-google-client-id
GOOGLE_CLIENT_SECRET=your-google-client-secret
```

## 📋 設定手順

### 1. Supabaseプロジェクト設定
1. https://supabase.com にアクセス
2. 新しいプロジェクトを作成
3. プロジェクト名: `shachipoke2`
4. データベースパスワードを設定
5. リージョン: `Northeast Asia (Tokyo)`

### 2. Google認証設定
1. https://console.cloud.google.com にアクセス
2. 新しいプロジェクトを作成: `shachipoke2-auth`
3. 「APIとサービス」→「認証情報」
4. 「認証情報を作成」→「OAuth 2.0 クライアント ID」
5. アプリケーションの種類: `ウェブアプリケーション`
6. 承認済みのリダイレクト URI:
   ```
   https://your-project-id.supabase.co/auth/v1/callback
   ```

### 3. SupabaseでGoogle認証有効化
1. Supabaseダッシュボード → Authentication → Providers
2. Google を有効化
3. Client ID と Client Secret を入力

### 4. データベーステーブル作成
SupabaseダッシュボードのSQL Editorで以下を実行：

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

## 🚀 次のステップ

Phase 1完了後、以下のファイルを更新してください：

1. `supabase-auth.html` の `YOUR_SUPABASE_URL` と `YOUR_SUPABASE_ANON_KEY` を実際の値に置き換え
2. `auth-callback.html` の同様の値を更新
3. 認証フローをテスト

Phase 2では、既存のゲームにSupabase認証とクラウド保存機能を統合します。
