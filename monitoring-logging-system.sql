-- Phase 2-8: 監視・ログ機能
-- 運用監視とログ機能の実装

-- ============================================
-- 1. システムログテーブル
-- ============================================

-- システム全体のログテーブル
CREATE TABLE IF NOT EXISTS system_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    log_level TEXT NOT NULL CHECK (log_level IN ('DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL')),
    log_category TEXT NOT NULL, -- 'auth', 'game', 'database', 'security', 'performance'
    log_message TEXT NOT NULL,
    log_data JSONB DEFAULT '{}', -- 追加のログデータ
    user_id UUID REFERENCES profiles(id) ON DELETE SET NULL, -- 関連するユーザー（NULL可）
    session_id UUID, -- セッションID
    ip_address INET,
    user_agent TEXT,
    request_id TEXT, -- リクエストID（トレーシング用）
    stack_trace TEXT, -- エラー時のスタックトレース
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- パフォーマンス監視テーブル
CREATE TABLE IF NOT EXISTS performance_metrics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    metric_name TEXT NOT NULL, -- 'query_time', 'response_time', 'memory_usage', 'cpu_usage'
    metric_value NUMERIC NOT NULL,
    metric_unit TEXT NOT NULL, -- 'ms', 'bytes', 'percent', 'count'
    metric_category TEXT NOT NULL, -- 'database', 'api', 'frontend', 'system'
    user_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
    session_id UUID,
    additional_data JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- エラー追跡テーブル
CREATE TABLE IF NOT EXISTS error_tracking (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    error_type TEXT NOT NULL, -- 'javascript', 'database', 'api', 'validation'
    error_code TEXT,
    error_message TEXT NOT NULL,
    error_stack TEXT,
    user_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
    session_id UUID,
    page_url TEXT,
    browser_info JSONB DEFAULT '{}',
    device_info JSONB DEFAULT '{}',
    error_context JSONB DEFAULT '{}', -- エラー発生時のコンテキスト
    is_resolved BOOLEAN DEFAULT FALSE,
    resolved_at TIMESTAMP WITH TIME ZONE,
    resolved_by TEXT, -- 解決者
    resolution_notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ユーザー行動分析テーブル
CREATE TABLE IF NOT EXISTS user_analytics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    event_type TEXT NOT NULL, -- 'page_view', 'button_click', 'game_action', 'navigation'
    event_name TEXT NOT NULL, -- 具体的なイベント名
    event_data JSONB DEFAULT '{}', -- イベントの詳細データ
    page_url TEXT,
    referrer_url TEXT,
    session_id UUID,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- 2. 監視ダッシュボード用ビュー
-- ============================================

-- システムヘルスダッシュボード用ビュー
CREATE OR REPLACE VIEW system_health_dashboard AS
SELECT 
    'system_logs' as table_name,
    COUNT(*) as total_records,
    COUNT(CASE WHEN log_level = 'ERROR' THEN 1 END) as error_count,
    COUNT(CASE WHEN log_level = 'WARN' THEN 1 END) as warning_count,
    COUNT(CASE WHEN created_at > NOW() - INTERVAL '1 hour' THEN 1 END) as recent_records,
    MAX(created_at) as last_activity
FROM system_logs
UNION ALL
SELECT 
    'performance_metrics' as table_name,
    COUNT(*) as total_records,
    COUNT(CASE WHEN metric_name = 'query_time' AND metric_value > 1000 THEN 1 END) as error_count,
    COUNT(CASE WHEN metric_name = 'response_time' AND metric_value > 500 THEN 1 END) as warning_count,
    COUNT(CASE WHEN created_at > NOW() - INTERVAL '1 hour' THEN 1 END) as recent_records,
    MAX(created_at) as last_activity
FROM performance_metrics
UNION ALL
SELECT 
    'error_tracking' as table_name,
    COUNT(*) as total_records,
    COUNT(CASE WHEN is_resolved = FALSE THEN 1 END) as error_count,
    COUNT(CASE WHEN created_at > NOW() - INTERVAL '24 hours' THEN 1 END) as warning_count,
    COUNT(CASE WHEN created_at > NOW() - INTERVAL '1 hour' THEN 1 END) as recent_records,
    MAX(created_at) as last_activity
FROM error_tracking;

-- ユーザー活動ダッシュボード用ビュー
CREATE OR REPLACE VIEW user_activity_dashboard AS
SELECT 
    DATE(created_at) as activity_date,
    COUNT(DISTINCT user_id) as active_users,
    COUNT(*) as total_events,
    COUNT(CASE WHEN event_type = 'page_view' THEN 1 END) as page_views,
    COUNT(CASE WHEN event_type = 'game_action' THEN 1 END) as game_actions,
    COUNT(CASE WHEN event_type = 'button_click' THEN 1 END) as button_clicks
FROM user_analytics
WHERE created_at > NOW() - INTERVAL '30 days'
GROUP BY DATE(created_at)
ORDER BY activity_date DESC;

-- ============================================
-- 3. ログ関数の作成
-- ============================================

-- システムログを記録する関数
CREATE OR REPLACE FUNCTION log_system_event(
    p_log_level TEXT,
    p_log_category TEXT,
    p_log_message TEXT,
    p_log_data JSONB DEFAULT '{}',
    p_user_id UUID DEFAULT NULL,
    p_session_id UUID DEFAULT NULL,
    p_ip_address INET DEFAULT NULL,
    p_user_agent TEXT DEFAULT NULL,
    p_request_id TEXT DEFAULT NULL,
    p_stack_trace TEXT DEFAULT NULL
) RETURNS UUID AS $$
DECLARE
    v_log_id UUID;
BEGIN
    INSERT INTO system_logs (
        log_level,
        log_category,
        log_message,
        log_data,
        user_id,
        session_id,
        ip_address,
        user_agent,
        request_id,
        stack_trace
    ) VALUES (
        p_log_level,
        p_log_category,
        p_log_message,
        p_log_data,
        p_user_id,
        p_session_id,
        p_ip_address,
        p_user_agent,
        p_request_id,
        p_stack_trace
    ) RETURNING id INTO v_log_id;
    
    RETURN v_log_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- パフォーマンスメトリクスを記録する関数
CREATE OR REPLACE FUNCTION log_performance_metric(
    p_metric_name TEXT,
    p_metric_value NUMERIC,
    p_metric_unit TEXT,
    p_metric_category TEXT,
    p_user_id UUID DEFAULT NULL,
    p_session_id UUID DEFAULT NULL,
    p_additional_data JSONB DEFAULT '{}'
) RETURNS UUID AS $$
DECLARE
    v_metric_id UUID;
BEGIN
    INSERT INTO performance_metrics (
        metric_name,
        metric_value,
        metric_unit,
        metric_category,
        user_id,
        session_id,
        additional_data
    ) VALUES (
        p_metric_name,
        p_metric_value,
        p_metric_unit,
        p_metric_category,
        p_user_id,
        p_session_id,
        p_additional_data
    ) RETURNING id INTO v_metric_id;
    
    RETURN v_metric_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- エラーを記録する関数
CREATE OR REPLACE FUNCTION log_error(
    p_error_type TEXT,
    p_error_code TEXT,
    p_error_message TEXT,
    p_error_stack TEXT DEFAULT NULL,
    p_user_id UUID DEFAULT NULL,
    p_session_id UUID DEFAULT NULL,
    p_page_url TEXT DEFAULT NULL,
    p_browser_info JSONB DEFAULT '{}',
    p_device_info JSONB DEFAULT '{}',
    p_error_context JSONB DEFAULT '{}'
) RETURNS UUID AS $$
DECLARE
    v_error_id UUID;
BEGIN
    INSERT INTO error_tracking (
        error_type,
        error_code,
        error_message,
        error_stack,
        user_id,
        session_id,
        page_url,
        browser_info,
        device_info,
        error_context
    ) VALUES (
        p_error_type,
        p_error_code,
        p_error_message,
        p_error_stack,
        p_user_id,
        p_session_id,
        p_page_url,
        p_browser_info,
        p_device_info,
        p_error_context
    ) RETURNING id INTO v_error_id;
    
    RETURN v_error_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ユーザー行動を記録する関数
CREATE OR REPLACE FUNCTION log_user_analytics(
    p_user_id UUID,
    p_event_type TEXT,
    p_event_name TEXT,
    p_event_data JSONB DEFAULT '{}',
    p_page_url TEXT DEFAULT NULL,
    p_referrer_url TEXT DEFAULT NULL,
    p_session_id UUID DEFAULT NULL
) RETURNS UUID AS $$
DECLARE
    v_analytics_id UUID;
BEGIN
    INSERT INTO user_analytics (
        user_id,
        event_type,
        event_name,
        event_data,
        page_url,
        referrer_url,
        session_id
    ) VALUES (
        p_user_id,
        p_event_type,
        p_event_name,
        p_event_data,
        p_page_url,
        p_referrer_url,
        p_session_id
    ) RETURNING id INTO v_analytics_id;
    
    RETURN v_analytics_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- 4. アラート機能
-- ============================================

-- アラート設定テーブル
CREATE TABLE IF NOT EXISTS alert_settings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    alert_name TEXT NOT NULL UNIQUE,
    alert_type TEXT NOT NULL CHECK (alert_type IN ('error_rate', 'performance', 'security', 'usage')),
    threshold_value NUMERIC NOT NULL,
    threshold_unit TEXT NOT NULL,
    check_interval_minutes INTEGER DEFAULT 60 CHECK (check_interval_minutes >= 1),
    is_enabled BOOLEAN DEFAULT TRUE,
    notification_method TEXT DEFAULT 'log' CHECK (notification_method IN ('log', 'email', 'webhook')),
    notification_target TEXT, -- メールアドレスやWebhook URL
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- アラート履歴テーブル
CREATE TABLE IF NOT EXISTS alert_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    alert_setting_id UUID REFERENCES alert_settings(id) ON DELETE CASCADE,
    alert_triggered_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    alert_value NUMERIC NOT NULL,
    alert_message TEXT NOT NULL,
    alert_data JSONB DEFAULT '{}',
    is_resolved BOOLEAN DEFAULT FALSE,
    resolved_at TIMESTAMP WITH TIME ZONE,
    resolved_by TEXT,
    resolution_notes TEXT
);

-- アラートチェック関数
CREATE OR REPLACE FUNCTION check_alerts() RETURNS VOID AS $$
DECLARE
    v_alert_record RECORD;
    v_current_value NUMERIC;
    v_alert_message TEXT;
    v_alert_id UUID;
BEGIN
    FOR v_alert_record IN 
        SELECT * FROM alert_settings WHERE is_enabled = TRUE
    LOOP
        -- アラートタイプに応じて値を取得
        CASE v_alert_record.alert_type
            WHEN 'error_rate' THEN
                SELECT COUNT(*)::NUMERIC INTO v_current_value
                FROM system_logs 
                WHERE log_level = 'ERROR' 
                AND created_at > NOW() - (v_alert_record.check_interval_minutes || ' minutes')::INTERVAL;
                
            WHEN 'performance' THEN
                SELECT AVG(metric_value) INTO v_current_value
                FROM performance_metrics 
                WHERE metric_name = 'response_time'
                AND created_at > NOW() - (v_alert_record.check_interval_minutes || ' minutes')::INTERVAL;
                
            WHEN 'security' THEN
                SELECT COUNT(*)::NUMERIC INTO v_current_value
                FROM system_logs 
                WHERE log_category = 'security' 
                AND log_level IN ('WARN', 'ERROR')
                AND created_at > NOW() - (v_alert_record.check_interval_minutes || ' minutes')::INTERVAL;
                
            WHEN 'usage' THEN
                SELECT COUNT(DISTINCT user_id)::NUMERIC INTO v_current_value
                FROM user_analytics 
                WHERE created_at > NOW() - (v_alert_record.check_interval_minutes || ' minutes')::INTERVAL;
        END CASE;
        
        -- 閾値を超えているかチェック
        IF v_current_value > v_alert_record.threshold_value THEN
            v_alert_message := format('Alert %s triggered: %s %s (threshold: %s %s)', 
                v_alert_record.alert_name, 
                v_current_value, 
                v_alert_record.threshold_unit,
                v_alert_record.threshold_value,
                v_alert_record.threshold_unit
            );
            
            -- アラート履歴に記録
            INSERT INTO alert_history (
                alert_setting_id,
                alert_value,
                alert_message,
                alert_data
            ) VALUES (
                v_alert_record.id,
                v_current_value,
                v_alert_message,
                jsonb_build_object(
                    'threshold', v_alert_record.threshold_value,
                    'unit', v_alert_record.threshold_unit,
                    'check_interval', v_alert_record.check_interval_minutes
                )
            ) RETURNING id INTO v_alert_id;
            
            -- システムログに記録
            PERFORM log_system_event(
                'WARN',
                'alert',
                v_alert_message,
                jsonb_build_object('alert_id', v_alert_id)
            );
            
            RAISE NOTICE 'Alert triggered: %', v_alert_message;
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- 5. データクリーンアップ関数
-- ============================================

-- 古いログデータをクリーンアップする関数
CREATE OR REPLACE FUNCTION cleanup_old_logs(p_retention_days INTEGER DEFAULT 30) RETURNS VOID AS $$
DECLARE
    v_deleted_count INTEGER;
BEGIN
    -- 古いシステムログを削除
    DELETE FROM system_logs 
    WHERE created_at < NOW() - (p_retention_days || ' days')::INTERVAL;
    
    GET DIAGNOSTICS v_deleted_count = ROW_COUNT;
    RAISE NOTICE 'Deleted % old system logs', v_deleted_count;
    
    -- 古いパフォーマンスメトリクスを削除
    DELETE FROM performance_metrics 
    WHERE created_at < NOW() - (p_retention_days || ' days')::INTERVAL;
    
    GET DIAGNOSTICS v_deleted_count = ROW_COUNT;
    RAISE NOTICE 'Deleted % old performance metrics', v_deleted_count;
    
    -- 古いユーザー分析データを削除
    DELETE FROM user_analytics 
    WHERE created_at < NOW() - (p_retention_days || ' days')::INTERVAL;
    
    GET DIAGNOSTICS v_deleted_count = ROW_COUNT;
    RAISE NOTICE 'Deleted % old user analytics', v_deleted_count;
    
    -- 解決済みの古いエラーを削除
    DELETE FROM error_tracking 
    WHERE is_resolved = TRUE 
    AND created_at < NOW() - (p_retention_days || ' days')::INTERVAL;
    
    GET DIAGNOSTICS v_deleted_count = ROW_COUNT;
    RAISE NOTICE 'Deleted % old resolved errors', v_deleted_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- 6. インデックスの作成
-- ============================================

-- system_logsテーブルのインデックス
CREATE INDEX IF NOT EXISTS idx_system_logs_level ON system_logs(log_level);
CREATE INDEX IF NOT EXISTS idx_system_logs_category ON system_logs(log_category);
CREATE INDEX IF NOT EXISTS idx_system_logs_created_at ON system_logs(created_at);
CREATE INDEX IF NOT EXISTS idx_system_logs_user_id ON system_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_system_logs_session_id ON system_logs(session_id);

-- performance_metricsテーブルのインデックス
CREATE INDEX IF NOT EXISTS idx_performance_metrics_name ON performance_metrics(metric_name);
CREATE INDEX IF NOT EXISTS idx_performance_metrics_category ON performance_metrics(metric_category);
CREATE INDEX IF NOT EXISTS idx_performance_metrics_created_at ON performance_metrics(created_at);
CREATE INDEX IF NOT EXISTS idx_performance_metrics_user_id ON performance_metrics(user_id);

-- error_trackingテーブルのインデックス
CREATE INDEX IF NOT EXISTS idx_error_tracking_type ON error_tracking(error_type);
CREATE INDEX IF NOT EXISTS idx_error_tracking_resolved ON error_tracking(is_resolved);
CREATE INDEX IF NOT EXISTS idx_error_tracking_created_at ON error_tracking(created_at);
CREATE INDEX IF NOT EXISTS idx_error_tracking_user_id ON error_tracking(user_id);

-- user_analyticsテーブルのインデックス
CREATE INDEX IF NOT EXISTS idx_user_analytics_event_type ON user_analytics(event_type);
CREATE INDEX IF NOT EXISTS idx_user_analytics_event_name ON user_analytics(event_name);
CREATE INDEX IF NOT EXISTS idx_user_analytics_timestamp ON user_analytics(timestamp);
CREATE INDEX IF NOT EXISTS idx_user_analytics_user_id ON user_analytics(user_id);
CREATE INDEX IF NOT EXISTS idx_user_analytics_session_id ON user_analytics(session_id);

-- ============================================
-- 7. 初期アラート設定の挿入
-- ============================================

-- デフォルトのアラート設定を挿入
INSERT INTO alert_settings (alert_name, alert_type, threshold_value, threshold_unit, check_interval_minutes, notification_method) VALUES
('High Error Rate', 'error_rate', 10, 'count', 60, 'log'),
('Slow Response Time', 'performance', 1000, 'ms', 60, 'log'),
('Security Issues', 'security', 5, 'count', 60, 'log'),
('Low User Activity', 'usage', 1, 'count', 60, 'log')
ON CONFLICT (alert_name) DO NOTHING;

-- ============================================
-- 8. 確認クエリ
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
    'system_logs', 
    'performance_metrics', 
    'error_tracking', 
    'user_analytics',
    'alert_settings',
    'alert_history'
)
ORDER BY tablename;

-- 作成された関数を確認
SELECT 
    routine_name,
    routine_type,
    data_type as return_type
FROM information_schema.routines 
WHERE routine_schema = 'public' 
AND routine_name LIKE '%log%' OR routine_name LIKE '%alert%' OR routine_name LIKE '%cleanup%'
ORDER BY routine_name;
