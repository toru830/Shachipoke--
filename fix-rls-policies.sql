-- Supabase RLSポリシー修正SQL
-- このSQLをSupabaseダッシュボードのSQL Editorで実行してください

-- 既存のポリシーを削除
DROP POLICY IF EXISTS "Users can view own profile" ON profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON profiles;
DROP POLICY IF EXISTS "Users can insert own profile" ON profiles;

-- 新しいポリシーを作成
-- ユーザーは自分のプロフィールを表示可能
CREATE POLICY "Users can view own profile" ON profiles
  FOR SELECT USING (auth.uid() = id);

-- ユーザーは自分のプロフィールを更新可能
CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE USING (auth.uid() = id);

-- ユーザーは自分のプロフィールを挿入可能（新規作成時）
CREATE POLICY "Users can insert own profile" ON profiles
  FOR INSERT WITH CHECK (auth.uid() = id);

-- game_savesテーブルのポリシーも確認
DROP POLICY IF EXISTS "Users can view own saves" ON game_saves;
DROP POLICY IF EXISTS "Users can insert own saves" ON game_saves;
DROP POLICY IF EXISTS "Users can update own saves" ON game_saves;

-- 新しいポリシーを作成
CREATE POLICY "Users can view own saves" ON game_saves
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own saves" ON game_saves
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own saves" ON game_saves
  FOR UPDATE USING (auth.uid() = user_id);
