-- RLSテスト用SQL
-- 認証されたユーザーで実行してRLSが正しく動作するかテスト

-- ============================================
-- テスト1: 自分のデータへのアクセステスト
-- ============================================

-- 現在のユーザーIDを確認
SELECT auth.uid() as current_user_id;

-- 自分のプロフィールを確認
SELECT * FROM profiles WHERE id = auth.uid();

-- 自分のゲームセーブデータを確認
SELECT 
    id,
    game_name,
    version,
    created_at,
    updated_at,
    jsonb_pretty(save_data) as save_data_preview
FROM game_saves 
WHERE user_id = auth.uid();

-- ============================================
-- テスト2: 他のユーザーのデータへのアクセステスト
-- ============================================

-- 他のユーザーのプロフィールにアクセスしようとする（エラーになるはず）
-- SELECT * FROM profiles WHERE id != auth.uid() LIMIT 1;

-- 他のユーザーのゲームセーブデータにアクセスしようとする（エラーになるはず）
-- SELECT * FROM game_saves WHERE user_id != auth.uid() LIMIT 1;

-- ============================================
-- テスト3: データ操作テスト
-- ============================================

-- プロフィール更新テスト（成功するはず）
UPDATE profiles 
SET updated_at = NOW() 
WHERE id = auth.uid();

-- ゲームセーブデータ更新テスト（成功するはず）
UPDATE game_saves 
SET updated_at = NOW() 
WHERE user_id = auth.uid() AND game_name = 'shachipoke2';

-- ============================================
-- テスト4: 不正なデータ操作テスト
-- ============================================

-- 他のユーザーのプロフィールを更新しようとする（エラーになるはず）
-- UPDATE profiles SET updated_at = NOW() WHERE id != auth.uid() LIMIT 1;

-- 他のユーザーのゲームセーブデータを更新しようとする（エラーになるはず）
-- UPDATE game_saves SET updated_at = NOW() WHERE user_id != auth.uid() LIMIT 1;
