-- RLS状況確認SQL
-- Supabase SQL Editorで実行して現在の状況を確認

-- テーブルのRLS状況を確認
SELECT 
    schemaname,
    tablename,
    rowsecurity as rls_enabled,
    CASE 
        WHEN rowsecurity THEN '有効' 
        ELSE '無効' 
    END as status
FROM pg_tables 
WHERE tablename IN ('profiles', 'game_saves')
ORDER BY tablename;

-- 既存のポリシーを確認
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual,
    with_check
FROM pg_policies 
WHERE tablename IN ('profiles', 'game_saves')
ORDER BY tablename, policyname;
