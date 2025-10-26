-- Supabase RLS一時無効化SQL
-- このSQLをSupabaseダッシュボードのSQL Editorで実行してください

-- profilesテーブルのRLSを一時的に無効化
ALTER TABLE profiles DISABLE ROW LEVEL SECURITY;

-- game_savesテーブルのRLSを一時的に無効化
ALTER TABLE game_saves DISABLE ROW LEVEL SECURITY;

-- 確認用クエリ
SELECT 
    schemaname, 
    tablename, 
    rowsecurity 
FROM pg_tables 
WHERE tablename IN ('profiles', 'game_saves');
