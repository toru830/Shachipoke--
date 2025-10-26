-- Phase 2-5: セキュリティ監査
-- データベースのセキュリティ設定を包括的にチェック

-- ============================================
-- 1. RLS（Row Level Security）の確認
-- ============================================

-- RLSが有効になっているテーブルの確認
SELECT 
    schemaname,
    tablename,
    rowsecurity as rls_enabled,
    CASE 
        WHEN rowsecurity THEN '✅ 有効' 
        ELSE '❌ 無効' 
    END as security_status
FROM pg_tables 
WHERE tablename IN ('profiles', 'game_saves')
ORDER BY tablename;

-- RLSポリシーの詳細確認
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd as operation,
    qual as using_expression,
    with_check as with_check_expression
FROM pg_policies 
WHERE tablename IN ('profiles', 'game_saves')
ORDER BY tablename, policyname;

-- ============================================
-- 2. 認証とアクセス制御の確認
-- ============================================

-- 認証されたユーザーの権限確認
SELECT 
    rolname as role_name,
    rolsuper as is_superuser,
    rolinherit as can_inherit,
    rolcreaterole as can_create_roles,
    rolcreatedb as can_create_databases,
    rolcanlogin as can_login
FROM pg_roles 
WHERE rolname = current_user;

-- テーブルへのアクセス権限確認
SELECT 
    schemaname,
    tablename,
    privilege_type,
    is_grantable
FROM information_schema.table_privileges 
WHERE table_name IN ('profiles', 'game_saves')
AND grantee = current_user
ORDER BY table_name, privilege_type;

-- ============================================
-- 3. データの機密性チェック
-- ============================================

-- 機密データの存在確認
SELECT 
    'profiles' as table_name,
    COUNT(*) as total_records,
    COUNT(CASE WHEN email IS NOT NULL THEN 1 END) as records_with_email,
    COUNT(CASE WHEN display_name IS NOT NULL THEN 1 END) as records_with_display_name,
    COUNT(CASE WHEN avatar_url IS NOT NULL THEN 1 END) as records_with_avatar
FROM profiles
UNION ALL
SELECT 
    'game_saves' as table_name,
    COUNT(*) as total_records,
    COUNT(CASE WHEN save_data ? 'selectedCharacter' THEN 1 END) as records_with_character,
    COUNT(CASE WHEN save_data ? 'shachi' THEN 1 END) as records_with_currency,
    COUNT(CASE WHEN save_data ? 'stats' THEN 1 END) as records_with_stats
FROM game_saves;

-- ============================================
-- 4. 外部アクセスの可能性チェック
-- ============================================

-- 外部テーブルやビューの確認
SELECT 
    schemaname,
    tablename,
    tableowner,
    hasindexes,
    hasrules,
    hastriggers
FROM pg_tables 
WHERE schemaname = 'public'
AND tablename IN ('profiles', 'game_saves');

-- 外部関数の確認
SELECT 
    n.nspname as schema_name,
    p.proname as function_name,
    pg_get_function_result(p.oid) as return_type,
    pg_get_function_arguments(p.oid) as arguments
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE n.nspname = 'public'
AND p.proname LIKE '%auth%';

-- ============================================
-- 5. データベース接続のセキュリティ
-- ============================================

-- 現在の接続情報
SELECT 
    pid as process_id,
    usename as username,
    application_name,
    client_addr as client_ip,
    client_port,
    backend_start,
    state,
    query_start,
    query
FROM pg_stat_activity 
WHERE datname = current_database()
AND state = 'active';

-- ============================================
-- 6. 監査ログの確認（可能な場合）
-- ============================================

-- 最近のテーブル変更履歴（統計情報から）
SELECT 
    schemaname,
    tablename,
    n_tup_ins as total_inserts,
    n_tup_upd as total_updates,
    n_tup_del as total_deletes,
    last_vacuum,
    last_autovacuum,
    last_analyze,
    last_autoanalyze
FROM pg_stat_user_tables 
WHERE relname IN ('profiles', 'game_saves')
ORDER BY n_tup_ins + n_tup_upd + n_tup_del DESC;

-- ============================================
-- 7. セキュリティ推奨事項の確認
-- ============================================

-- パスワードポリシーの確認（PostgreSQL 14+）
SELECT 
    name,
    setting,
    unit,
    context
FROM pg_settings 
WHERE name LIKE '%password%'
OR name LIKE '%ssl%'
OR name LIKE '%auth%';

-- SSL接続の確認
SELECT 
    name,
    setting,
    context
FROM pg_settings 
WHERE name LIKE '%ssl%';

-- ============================================
-- 8. セキュリティチェックリスト
-- ============================================

-- セキュリティチェック結果のサマリー
WITH security_check AS (
    SELECT 
        'RLS Enabled' as check_item,
        CASE 
            WHEN EXISTS (
                SELECT 1 FROM pg_tables 
                WHERE tablename IN ('profiles', 'game_saves') 
                AND rowsecurity = true
            ) THEN '✅ PASS'
            ELSE '❌ FAIL'
        END as result
    UNION ALL
    SELECT 
        'Policies Exist' as check_item,
        CASE 
            WHEN EXISTS (
                SELECT 1 FROM pg_policies 
                WHERE tablename IN ('profiles', 'game_saves')
            ) THEN '✅ PASS'
            ELSE '❌ FAIL'
        END as result
    UNION ALL
    SELECT 
        'Constraints Exist' as check_item,
        CASE 
            WHEN EXISTS (
                SELECT 1 FROM pg_constraint 
                WHERE conrelid IN ('profiles'::regclass, 'game_saves'::regclass)
            ) THEN '✅ PASS'
            ELSE '❌ FAIL'
        END as result
    UNION ALL
    SELECT 
        'Indexes Exist' as check_item,
        CASE 
            WHEN EXISTS (
                SELECT 1 FROM pg_indexes 
                WHERE tablename IN ('profiles', 'game_saves')
            ) THEN '✅ PASS'
            ELSE '❌ FAIL'
        END as result
)
SELECT * FROM security_check ORDER BY check_item;
