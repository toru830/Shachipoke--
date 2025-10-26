-- Phase 2-3: データ整合性の最終確認と制約強化
-- データの整合性を保つための制約とバリデーション

-- ============================================
-- 1. 既存の制約を確認
-- ============================================

-- profilesテーブルの制約を確認
SELECT 
    conname as constraint_name,
    contype as constraint_type,
    pg_get_constraintdef(oid) as constraint_definition
FROM pg_constraint 
WHERE conrelid = 'profiles'::regclass;

-- game_savesテーブルの制約を確認
SELECT 
    conname as constraint_name,
    contype as constraint_type,
    pg_get_constraintdef(oid) as constraint_definition
FROM pg_constraint 
WHERE conrelid = 'game_saves'::regclass;

-- ============================================
-- 2. 追加制約の作成
-- ============================================

-- profilesテーブルの制約強化
-- メールアドレスの形式チェック
ALTER TABLE profiles 
ADD CONSTRAINT chk_profiles_email_format 
CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');

-- 表示名の長さ制限
ALTER TABLE profiles 
ADD CONSTRAINT chk_profiles_display_name_length 
CHECK (LENGTH(display_name) <= 100);

-- アバターURLの形式チェック
ALTER TABLE profiles 
ADD CONSTRAINT chk_profiles_avatar_url_format 
CHECK (avatar_url IS NULL OR avatar_url ~* '^https?://');

-- game_savesテーブルの制約強化
-- ゲーム名の長さ制限
ALTER TABLE game_saves 
ADD CONSTRAINT chk_game_saves_game_name_length 
CHECK (LENGTH(game_name) <= 50);

-- バージョン形式のチェック（セマンティックバージョニング）
ALTER TABLE game_saves 
ADD CONSTRAINT chk_game_saves_version_format 
CHECK (version ~* '^\d+\.\d+\.\d+$');

-- JSONBデータの基本構造チェック
ALTER TABLE game_saves 
ADD CONSTRAINT chk_game_saves_save_data_structure 
CHECK (
    save_data ? 'selectedCharacter' AND
    save_data ? 'shachi' AND
    save_data ? 'level' AND
    save_data ? 'stats'
);

-- ============================================
-- 3. トリガー関数の作成
-- ============================================

-- 更新日時の自動更新関数
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- profilesテーブルの更新日時自動更新トリガー
DROP TRIGGER IF EXISTS update_profiles_updated_at ON profiles;
CREATE TRIGGER update_profiles_updated_at
    BEFORE UPDATE ON profiles
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- game_savesテーブルの更新日時自動更新トリガー
DROP TRIGGER IF EXISTS update_game_saves_updated_at ON game_saves;
CREATE TRIGGER update_game_saves_updated_at
    BEFORE UPDATE ON game_saves
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- 4. データ整合性チェック関数
-- ============================================

-- ゲームデータの整合性をチェックする関数
CREATE OR REPLACE FUNCTION validate_game_save_data(save_data JSONB)
RETURNS BOOLEAN AS $$
BEGIN
    -- 必須フィールドの存在チェック
    IF NOT (save_data ? 'selectedCharacter' AND 
            save_data ? 'shachi' AND 
            save_data ? 'level' AND 
            save_data ? 'stats') THEN
        RETURN FALSE;
    END IF;
    
    -- シャチの値が数値で0以上かチェック
    IF NOT (save_data->>'shachi' ~ '^\d+$' AND 
            (save_data->>'shachi')::INTEGER >= 0) THEN
        RETURN FALSE;
    END IF;
    
    -- レベルの値が数値で1以上かチェック
    IF NOT (save_data->>'level' ~ '^\d+$' AND 
            (save_data->>'level')::INTEGER >= 1) THEN
        RETURN FALSE;
    END IF;
    
    -- ステータスの構造チェック
    IF NOT (save_data->'stats' ? 'stress' AND 
            save_data->'stats' ? 'knowledge' AND 
            save_data->'stats' ? 'physical' AND 
            save_data->'stats' ? 'communication') THEN
        RETURN FALSE;
    END IF;
    
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- 5. データ整合性チェック制約
-- ============================================

-- ゲームセーブデータの整合性チェック制約
ALTER TABLE game_saves 
ADD CONSTRAINT chk_game_saves_data_validity 
CHECK (validate_game_save_data(save_data));

-- ============================================
-- 6. 既存データの整合性チェック
-- ============================================

-- 既存のプロフィールデータの整合性チェック
SELECT 
    'profiles' as table_name,
    COUNT(*) as total_records,
    COUNT(CASE WHEN email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$' THEN 1 END) as valid_emails,
    COUNT(CASE WHEN LENGTH(display_name) <= 100 THEN 1 END) as valid_display_names
FROM profiles;

-- 既存のゲームセーブデータの整合性チェック
SELECT 
    'game_saves' as table_name,
    COUNT(*) as total_records,
    COUNT(CASE WHEN validate_game_save_data(save_data) THEN 1 END) as valid_save_data,
    COUNT(CASE WHEN version ~* '^\d+\.\d+\.\d+$' THEN 1 END) as valid_versions
FROM game_saves;
