-- Phase 2-6: データベーススキーマの拡張
-- ゲーム機能拡張に対応したテーブル設計

-- ============================================
-- 1. キャラクター個別データテーブル
-- ============================================

-- ユーザーが所有するキャラクターの詳細データ
CREATE TABLE IF NOT EXISTS user_characters (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    character_id TEXT NOT NULL, -- CHARACTERS配列のID
    level INTEGER DEFAULT 1 CHECK (level >= 1),
    experience INTEGER DEFAULT 0 CHECK (experience >= 0),
    stats JSONB NOT NULL DEFAULT '{"stress": 0, "knowledge": 0, "physical": 0, "communication": 0}',
    acquired_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    last_used_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, character_id)
);

-- ============================================
-- 2. イベント履歴テーブル
-- ============================================

-- ユーザーが参加したイベントの履歴
CREATE TABLE IF NOT EXISTS event_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    event_id TEXT NOT NULL, -- EVENTS配列のID
    event_type TEXT NOT NULL, -- 'stress', 'knowledge', 'physical', 'communication'
    choice_made INTEGER NOT NULL CHECK (choice_made >= 0), -- 選択した選択肢のインデックス
    rewards JSONB NOT NULL DEFAULT '{}', -- 獲得した報酬
    stats_change JSONB NOT NULL DEFAULT '{}', -- ステータス変化
    shachi_earned INTEGER DEFAULT 0 CHECK (shachi_earned >= 0),
    completed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- 3. アイテム購入履歴テーブル
-- ============================================

-- ユーザーが購入したアイテムの履歴
CREATE TABLE IF NOT EXISTS purchase_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    item_id TEXT NOT NULL, -- SHOP_ITEMS配列のID
    item_name TEXT NOT NULL,
    item_cost INTEGER NOT NULL CHECK (item_cost >= 0),
    quantity INTEGER DEFAULT 1 CHECK (quantity >= 1),
    stats_effect JSONB NOT NULL DEFAULT '{}', -- ステータス効果
    purchased_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- 4. アチーブメントテーブル
-- ============================================

-- ユーザーのアチーブメント達成状況
CREATE TABLE IF NOT EXISTS user_achievements (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    achievement_id TEXT NOT NULL, -- アチーブメントのID
    achievement_name TEXT NOT NULL,
    achievement_description TEXT,
    achievement_type TEXT NOT NULL, -- 'level', 'event', 'purchase', 'time', 'stat'
    target_value INTEGER NOT NULL CHECK (target_value >= 0),
    current_value INTEGER DEFAULT 0 CHECK (current_value >= 0),
    is_completed BOOLEAN DEFAULT FALSE,
    completed_at TIMESTAMP WITH TIME ZONE,
    reward JSONB DEFAULT '{}', -- 報酬内容
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, achievement_id)
);

-- ============================================
-- 5. パーティー編成テーブル
-- ============================================

-- ユーザーのパーティー編成
CREATE TABLE IF NOT EXISTS user_parties (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    party_name TEXT DEFAULT 'メインパーティー',
    party_slots JSONB NOT NULL DEFAULT '[null, null, null, null]', -- 4つのスロット
    is_active BOOLEAN DEFAULT FALSE, -- アクティブなパーティーか
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, party_name)
);

-- ============================================
-- 6. ゲーム統計テーブル
-- ============================================

-- ユーザーの詳細なゲーム統計
CREATE TABLE IF NOT EXISTS user_game_stats (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    total_play_days INTEGER DEFAULT 0 CHECK (total_play_days >= 0),
    total_play_time INTEGER DEFAULT 0 CHECK (total_play_time >= 0), -- 秒単位
    total_events_completed INTEGER DEFAULT 0 CHECK (total_events_completed >= 0),
    total_items_purchased INTEGER DEFAULT 0 CHECK (total_items_purchased >= 0),
    total_characters_owned INTEGER DEFAULT 0 CHECK (total_characters_owned >= 0),
    total_shachi_earned INTEGER DEFAULT 0 CHECK (total_shachi_earned >= 0),
    total_shachi_spent INTEGER DEFAULT 0 CHECK (total_shachi_spent >= 0),
    highest_level_reached INTEGER DEFAULT 1 CHECK (highest_level_reached >= 1),
    last_play_date DATE,
    streak_days INTEGER DEFAULT 0 CHECK (streak_days >= 0), -- 連続プレイ日数
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id)
);

-- ============================================
-- 7. セッションログテーブル
-- ============================================

-- ユーザーのセッション情報（監視・分析用）
CREATE TABLE IF NOT EXISTS user_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    session_start TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    session_end TIMESTAMP WITH TIME ZONE,
    session_duration INTEGER, -- 秒単位
    actions_count INTEGER DEFAULT 0 CHECK (actions_count >= 0),
    screen_views JSONB DEFAULT '{}', -- 画面遷移履歴
    device_info JSONB DEFAULT '{}', -- デバイス情報
    browser_info JSONB DEFAULT '{}', -- ブラウザ情報
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- 8. インデックスの作成
-- ============================================

-- user_charactersテーブルのインデックス
CREATE INDEX IF NOT EXISTS idx_user_characters_user_id ON user_characters(user_id);
CREATE INDEX IF NOT EXISTS idx_user_characters_character_id ON user_characters(character_id);
CREATE INDEX IF NOT EXISTS idx_user_characters_level ON user_characters(level);
CREATE INDEX IF NOT EXISTS idx_user_characters_last_used ON user_characters(last_used_at);

-- event_historyテーブルのインデックス
CREATE INDEX IF NOT EXISTS idx_event_history_user_id ON event_history(user_id);
CREATE INDEX IF NOT EXISTS idx_event_history_event_type ON event_history(event_type);
CREATE INDEX IF NOT EXISTS idx_event_history_completed_at ON event_history(completed_at);
CREATE INDEX IF NOT EXISTS idx_event_history_user_type ON event_history(user_id, event_type);

-- purchase_historyテーブルのインデックス
CREATE INDEX IF NOT EXISTS idx_purchase_history_user_id ON purchase_history(user_id);
CREATE INDEX IF NOT EXISTS idx_purchase_history_item_id ON purchase_history(item_id);
CREATE INDEX IF NOT EXISTS idx_purchase_history_purchased_at ON purchase_history(purchased_at);

-- user_achievementsテーブルのインデックス
CREATE INDEX IF NOT EXISTS idx_user_achievements_user_id ON user_achievements(user_id);
CREATE INDEX IF NOT EXISTS idx_user_achievements_achievement_type ON user_achievements(achievement_type);
CREATE INDEX IF NOT EXISTS idx_user_achievements_completed ON user_achievements(is_completed);
CREATE INDEX IF NOT EXISTS idx_user_achievements_user_type ON user_achievements(user_id, achievement_type);

-- user_partiesテーブルのインデックス
CREATE INDEX IF NOT EXISTS idx_user_parties_user_id ON user_parties(user_id);
CREATE INDEX IF NOT EXISTS idx_user_parties_active ON user_parties(is_active);

-- user_game_statsテーブルのインデックス
CREATE INDEX IF NOT EXISTS idx_user_game_stats_user_id ON user_game_stats(user_id);
CREATE INDEX IF NOT EXISTS idx_user_game_stats_last_play ON user_game_stats(last_play_date);

-- user_sessionsテーブルのインデックス
CREATE INDEX IF NOT EXISTS idx_user_sessions_user_id ON user_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_user_sessions_start ON user_sessions(session_start);
CREATE INDEX IF NOT EXISTS idx_user_sessions_duration ON user_sessions(session_duration);

-- ============================================
-- 9. RLSポリシーの設定
-- ============================================

-- RLSを有効化
ALTER TABLE user_characters ENABLE ROW LEVEL SECURITY;
ALTER TABLE event_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE purchase_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_achievements ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_parties ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_game_stats ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_sessions ENABLE ROW LEVEL SECURITY;

-- user_charactersテーブルのポリシー
CREATE POLICY "Users can view own characters" ON user_characters
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own characters" ON user_characters
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own characters" ON user_characters
    FOR UPDATE USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own characters" ON user_characters
    FOR DELETE USING (auth.uid() = user_id);

-- event_historyテーブルのポリシー
CREATE POLICY "Users can view own event history" ON event_history
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own event history" ON event_history
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- purchase_historyテーブルのポリシー
CREATE POLICY "Users can view own purchase history" ON purchase_history
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own purchase history" ON purchase_history
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- user_achievementsテーブルのポリシー
CREATE POLICY "Users can view own achievements" ON user_achievements
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own achievements" ON user_achievements
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own achievements" ON user_achievements
    FOR UPDATE USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- user_partiesテーブルのポリシー
CREATE POLICY "Users can view own parties" ON user_parties
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own parties" ON user_parties
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own parties" ON user_parties
    FOR UPDATE USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own parties" ON user_parties
    FOR DELETE USING (auth.uid() = user_id);

-- user_game_statsテーブルのポリシー
CREATE POLICY "Users can view own game stats" ON user_game_stats
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own game stats" ON user_game_stats
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own game stats" ON user_game_stats
    FOR UPDATE USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- user_sessionsテーブルのポリシー
CREATE POLICY "Users can view own sessions" ON user_sessions
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own sessions" ON user_sessions
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own sessions" ON user_sessions
    FOR UPDATE USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- ============================================
-- 10. トリガー関数の追加
-- ============================================

-- 更新日時の自動更新トリガー
CREATE TRIGGER update_user_characters_updated_at
    BEFORE UPDATE ON user_characters
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_achievements_updated_at
    BEFORE UPDATE ON user_achievements
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_parties_updated_at
    BEFORE UPDATE ON user_parties
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_game_stats_updated_at
    BEFORE UPDATE ON user_game_stats
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- 11. 確認クエリ
-- ============================================

-- 作成されたテーブルを確認
SELECT 
    schemaname,
    tablename,
    rowsecurity as rls_enabled,
    CASE 
        WHEN rowsecurity THEN '✅ 有効' 
        ELSE '❌ 無効' 
    END as status
FROM pg_tables 
WHERE tablename IN (
    'user_characters', 
    'event_history', 
    'purchase_history', 
    'user_achievements', 
    'user_parties', 
    'user_game_stats', 
    'user_sessions'
)
ORDER BY tablename;

-- 作成されたインデックスを確認
SELECT 
    schemaname,
    tablename,
    indexname
FROM pg_indexes 
WHERE tablename IN (
    'user_characters', 
    'event_history', 
    'purchase_history', 
    'user_achievements', 
    'user_parties', 
    'user_game_stats', 
    'user_sessions'
)
ORDER BY tablename, indexname;
