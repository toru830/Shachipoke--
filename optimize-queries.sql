-- Phase 2-2: 高度なクエリ最適化
-- パフォーマンス向上のための追加インデックスとクエリ最適化

-- ============================================
-- 1. 追加インデックスの作成
-- ============================================

-- profilesテーブルの最適化
-- メールアドレスでの検索を高速化
CREATE INDEX IF NOT EXISTS idx_profiles_email ON profiles(email);

-- 作成日時でのソートを高速化
CREATE INDEX IF NOT EXISTS idx_profiles_created_at ON profiles(created_at);

-- 更新日時でのソートを高速化
CREATE INDEX IF NOT EXISTS idx_profiles_updated_at ON profiles(updated_at);

-- game_savesテーブルの最適化
-- ゲーム名での検索を高速化
CREATE INDEX IF NOT EXISTS idx_game_saves_game_name ON game_saves(game_name);

-- バージョンでの検索を高速化
CREATE INDEX IF NOT EXISTS idx_game_saves_version ON game_saves(version);

-- 作成日時でのソートを高速化（既存のupdated_atと併用）
CREATE INDEX IF NOT EXISTS idx_game_saves_created_at ON game_saves(created_at);

-- 複合インデックス（よく使われる組み合わせ）
-- ユーザーID + ゲーム名での検索を高速化
CREATE INDEX IF NOT EXISTS idx_game_saves_user_game ON game_saves(user_id, game_name);

-- ユーザーID + 更新日時での検索を高速化
CREATE INDEX IF NOT EXISTS idx_game_saves_user_updated ON game_saves(user_id, updated_at);

-- ============================================
-- 2. 既存インデックスの確認
-- ============================================

-- 作成されたインデックスを確認
SELECT 
    schemaname,
    tablename,
    indexname,
    indexdef
FROM pg_indexes 
WHERE tablename IN ('profiles', 'game_saves')
ORDER BY tablename, indexname;

-- ============================================
-- 3. インデックス使用状況の確認
-- ============================================

-- インデックスのサイズを確認
SELECT 
    schemaname,
    tablename,
    indexname,
    pg_size_pretty(pg_relation_size(indexname::regclass)) as index_size
FROM pg_indexes 
WHERE tablename IN ('profiles', 'game_saves')
ORDER BY pg_relation_size(indexname::regclass) DESC;

-- ============================================
-- 4. テーブル統計情報の更新
-- ============================================

-- 統計情報を更新してクエリプランナーの精度を向上
ANALYZE profiles;
ANALYZE game_saves;

-- ============================================
-- 5. 最適化されたクエリ例
-- ============================================

-- ユーザーの最新のゲームセーブデータを取得（最適化版）
-- EXPLAIN ANALYZE を付けて実行計画を確認可能
/*
EXPLAIN ANALYZE
SELECT 
    gs.id,
    gs.game_name,
    gs.version,
    gs.updated_at,
    p.email
FROM game_saves gs
JOIN profiles p ON gs.user_id = p.id
WHERE gs.user_id = auth.uid()
ORDER BY gs.updated_at DESC
LIMIT 1;
*/

-- 特定のゲームの全ユーザーセーブデータを取得（管理者用）
-- 注意: このクエリはRLSにより制限される
/*
EXPLAIN ANALYZE
SELECT 
    gs.user_id,
    p.email,
    gs.version,
    gs.updated_at
FROM game_saves gs
JOIN profiles p ON gs.user_id = p.id
WHERE gs.game_name = 'shachipoke2'
ORDER BY gs.updated_at DESC;
*/
