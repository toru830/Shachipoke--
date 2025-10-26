-- Supabaseデータベース設定SQL（安全版）
-- 既存テーブルがある場合でもエラーにならないように修正

-- 既存テーブルを削除（必要に応じて）
-- DROP TABLE IF EXISTS game_saves CASCADE;
-- DROP TABLE IF EXISTS profiles CASCADE;

-- ユーザープロフィールテーブル（存在しない場合のみ作成）
CREATE TABLE IF NOT EXISTS profiles (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  display_name TEXT,
  avatar_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ゲームセーブデータテーブル（存在しない場合のみ作成）
CREATE TABLE IF NOT EXISTS game_saves (
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

-- ポリシーを削除してから再作成（重複エラーを防ぐ）
DROP POLICY IF EXISTS "Users can view own profile" ON profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON profiles;
DROP POLICY IF EXISTS "Users can view own saves" ON game_saves;
DROP POLICY IF EXISTS "Users can insert own saves" ON game_saves;
DROP POLICY IF EXISTS "Users can update own saves" ON game_saves;

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

-- インデックス作成（パフォーマンス向上）
CREATE INDEX IF NOT EXISTS idx_game_saves_user_id ON game_saves(user_id);
CREATE INDEX IF NOT EXISTS idx_game_saves_updated_at ON game_saves(updated_at);
