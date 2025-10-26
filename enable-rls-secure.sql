-- Phase 2-1: RLSの再有効化とポリシー修正
-- このSQLをSupabase SQL Editorで実行してください

-- ============================================
-- 1. 既存のポリシーを削除（安全に再作成するため）
-- ============================================

-- profilesテーブルの既存ポリシーを削除
DROP POLICY IF EXISTS "Users can view own profile" ON profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON profiles;
DROP POLICY IF EXISTS "Users can insert own profile" ON profiles;

-- game_savesテーブルの既存ポリシーを削除
DROP POLICY IF EXISTS "Users can view own saves" ON game_saves;
DROP POLICY IF EXISTS "Users can insert own saves" ON game_saves;
DROP POLICY IF EXISTS "Users can update own saves" ON game_saves;
DROP POLICY IF EXISTS "Users can delete own saves" ON game_saves;

-- ============================================
-- 2. 新しいRLSポリシーを作成
-- ============================================

-- profilesテーブルのポリシー
-- ユーザーは自分のプロフィールのみ閲覧可能
CREATE POLICY "Users can view own profile" ON profiles
    FOR SELECT 
    USING (auth.uid() = id);

-- ユーザーは自分のプロフィールのみ更新可能
CREATE POLICY "Users can update own profile" ON profiles
    FOR UPDATE 
    USING (auth.uid() = id)
    WITH CHECK (auth.uid() = id);

-- 認証されたユーザーは自分のプロフィールを作成可能
CREATE POLICY "Users can insert own profile" ON profiles
    FOR INSERT 
    WITH CHECK (auth.uid() = id);

-- game_savesテーブルのポリシー
-- ユーザーは自分のセーブデータのみ閲覧可能
CREATE POLICY "Users can view own saves" ON game_saves
    FOR SELECT 
    USING (auth.uid() = user_id);

-- ユーザーは自分のセーブデータのみ挿入可能
CREATE POLICY "Users can insert own saves" ON game_saves
    FOR INSERT 
    WITH CHECK (auth.uid() = user_id);

-- ユーザーは自分のセーブデータのみ更新可能
CREATE POLICY "Users can update own saves" ON game_saves
    FOR UPDATE 
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- ユーザーは自分のセーブデータのみ削除可能
CREATE POLICY "Users can delete own saves" ON game_saves
    FOR DELETE 
    USING (auth.uid() = user_id);

-- ============================================
-- 3. RLSを有効化
-- ============================================

-- profilesテーブルのRLSを有効化
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- game_savesテーブルのRLSを有効化
ALTER TABLE game_saves ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 4. 確認クエリ
-- ============================================

-- RLSが有効になったか確認
SELECT 
    schemaname,
    tablename,
    rowsecurity as rls_enabled,
    CASE 
        WHEN rowsecurity THEN '✅ 有効' 
        ELSE '❌ 無効' 
    END as status
FROM pg_tables 
WHERE tablename IN ('profiles', 'game_saves')
ORDER BY tablename;

-- 作成されたポリシーを確認
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    cmd as operation,
    CASE 
        WHEN cmd = 'r' THEN 'SELECT'
        WHEN cmd = 'a' THEN 'INSERT'
        WHEN cmd = 'w' THEN 'UPDATE'
        WHEN cmd = 'd' THEN 'DELETE'
        ELSE cmd
    END as operation_name
FROM pg_policies 
WHERE tablename IN ('profiles', 'game_saves')
ORDER BY tablename, policyname;
