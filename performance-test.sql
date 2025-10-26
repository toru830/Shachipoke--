-- Phase 2-4: パフォーマンステスト
-- データベースのパフォーマンスを測定し、最適化を確認

-- ============================================
-- 1. テーブルサイズと統計情報の確認
-- ============================================

-- テーブルサイズの確認
SELECT 
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as total_size,
    pg_size_pretty(pg_relation_size(schemaname||'.'||tablename)) as table_size,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename) - pg_relation_size(schemaname||'.'||tablename)) as index_size
FROM pg_tables 
WHERE tablename IN ('profiles', 'game_saves')
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;

-- テーブルの行数と統計情報
SELECT 
    schemaname,
    tablename,
    n_tup_ins as inserts,
    n_tup_upd as updates,
    n_tup_del as deletes,
    n_live_tup as live_tuples,
    n_dead_tup as dead_tuples,
    last_vacuum,
    last_autovacuum,
    last_analyze,
    last_autoanalyze
FROM pg_stat_user_tables 
WHERE relname IN ('profiles', 'game_saves')
ORDER BY n_live_tup DESC;

-- ============================================
-- 2. インデックス使用状況の確認
-- ============================================

-- インデックスの使用統計
SELECT 
    schemaname,
    tablename,
    indexname,
    idx_tup_read as tuples_read,
    idx_tup_fetch as tuples_fetched,
    CASE 
        WHEN idx_tup_read > 0 THEN 
            ROUND((idx_tup_fetch::NUMERIC / idx_tup_read::NUMERIC) * 100, 2)
        ELSE 0 
    END as hit_ratio_percent
FROM pg_stat_user_indexes 
WHERE schemaname = 'public' 
AND tablename IN ('profiles', 'game_saves')
ORDER BY idx_tup_read DESC;

-- ============================================
-- 3. クエリパフォーマンステスト
-- ============================================

-- テスト1: ユーザープロフィール取得（認証済みユーザーで実行）
-- EXPLAIN ANALYZE
SELECT 
    id,
    email,
    display_name,
    created_at,
    updated_at
FROM profiles 
WHERE id = auth.uid();

-- テスト2: ゲームセーブデータ取得（認証済みユーザーで実行）
-- EXPLAIN ANALYZE
SELECT 
    id,
    game_name,
    version,
    updated_at,
    jsonb_pretty(save_data) as save_data_preview
FROM game_saves 
WHERE user_id = auth.uid() 
ORDER BY updated_at DESC;

-- テスト3: 特定ゲームのセーブデータ取得（認証済みユーザーで実行）
-- EXPLAIN ANALYZE
SELECT 
    id,
    version,
    updated_at
FROM game_saves 
WHERE user_id = auth.uid() 
AND game_name = 'shachipoke2'
ORDER BY updated_at DESC
LIMIT 1;

-- ============================================
-- 4. 書き込みパフォーマンステスト
-- ============================================

-- テスト4: プロフィール更新（認証済みユーザーで実行）
-- EXPLAIN ANALYZE
UPDATE profiles 
SET updated_at = NOW() 
WHERE id = auth.uid();

-- テスト5: ゲームセーブデータ更新（認証済みユーザーで実行）
-- EXPLAIN ANALYZE
UPDATE game_saves 
SET 
    save_data = jsonb_set(save_data, '{lastUpdated}', to_jsonb(NOW())),
    updated_at = NOW()
WHERE user_id = auth.uid() 
AND game_name = 'shachipoke2';

-- ============================================
-- 5. 複雑なクエリのパフォーマンステスト
-- ============================================

-- テスト6: JOINクエリ（認証済みユーザーで実行）
-- EXPLAIN ANALYZE
SELECT 
    p.email,
    p.display_name,
    gs.game_name,
    gs.version,
    gs.updated_at,
    gs.save_data->>'level' as game_level,
    gs.save_data->>'shachi' as currency
FROM profiles p
JOIN game_saves gs ON p.id = gs.user_id
WHERE p.id = auth.uid()
ORDER BY gs.updated_at DESC;

-- ============================================
-- 6. バックアップとメンテナンス
-- ============================================

-- 統計情報の更新（パフォーマンス向上のため）
ANALYZE profiles;
ANALYZE game_saves;

-- 不要なデータのクリーンアップ（必要に応じて）
-- VACUUM ANALYZE profiles;
-- VACUUM ANALYZE game_saves;

-- ============================================
-- 7. パフォーマンス監視用ビューの作成
-- ============================================

-- パフォーマンス監視用ビュー
CREATE OR REPLACE VIEW performance_monitor AS
SELECT 
    'profiles' as table_name,
    COUNT(*) as total_records,
    pg_size_pretty(pg_total_relation_size('profiles')) as total_size,
    MAX(updated_at) as last_update,
    COUNT(CASE WHEN updated_at > NOW() - INTERVAL '1 day' THEN 1 END) as updates_last_24h
FROM profiles
UNION ALL
SELECT 
    'game_saves' as table_name,
    COUNT(*) as total_records,
    pg_size_pretty(pg_total_relation_size('game_saves')) as total_size,
    MAX(updated_at) as last_update,
    COUNT(CASE WHEN updated_at > NOW() - INTERVAL '1 day' THEN 1 END) as updates_last_24h
FROM game_saves;

-- パフォーマンス監視ビューの確認
SELECT * FROM performance_monitor;
