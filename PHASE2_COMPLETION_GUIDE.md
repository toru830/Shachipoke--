# Phase 2 残り完了 - 実行手順書

## 🎯 概要
Phase 2の残り3項目を完了し、完全なデータベース統合を実現します。

## 📋 実行順序
以下の順序でSQLファイルをSupabase SQL Editorで実行してください。

### 1️⃣ **データベーススキーマの拡張** (`extend-database-schema.sql`)
**目的**: ゲーム機能拡張に対応したテーブル設計
**実行方法**:
1. Supabaseダッシュボード → SQL Editor
2. `extend-database-schema.sql`の内容をコピー&ペースト
3. "Run"ボタンをクリック
**期待結果**: 7つの新しいテーブルが作成される

**作成されるテーブル**:
- `user_characters`: ユーザーが所有するキャラクターの詳細データ
- `event_history`: イベント参加履歴
- `purchase_history`: アイテム購入履歴
- `user_achievements`: アチーブメント達成状況
- `user_parties`: パーティー編成
- `user_game_stats`: 詳細なゲーム統計
- `user_sessions`: セッション情報

### 2️⃣ **バックアップ・復旧戦略** (`backup-recovery-strategy.sql`)
**目的**: データ保護と復旧機能の実装
**実行方法**:
1. `backup-recovery-strategy.sql`の内容をコピー&ペースト
2. "Run"ボタンをクリック
**期待結果**: バックアップ機能が実装される

**実装される機能**:
- `create_game_backup()`: 完全バックアップ作成
- `restore_game_backup()`: バックアップからの復旧
- `execute_automatic_backup()`: 自動バックアップ
- `cleanup_old_backups()`: 古いバックアップのクリーンアップ

### 3️⃣ **監視・ログ機能** (`monitoring-logging-system.sql`)
**目的**: 運用監視とログ機能の実装
**実行方法**:
1. `monitoring-logging-system.sql`の内容をコピー&ペースト
2. "Run"ボタンをクリック
**期待結果**: 監視・ログ機能が実装される

**実装される機能**:
- `log_system_event()`: システムログ記録
- `log_performance_metric()`: パフォーマンス監視
- `log_error()`: エラー追跡
- `log_user_analytics()`: ユーザー行動分析
- `check_alerts()`: アラート機能

## ⚠️ 注意事項

### 実行前の確認
- [ ] Supabaseプロジェクトにログイン済み
- [ ] SQL Editorにアクセス可能
- [ ] 十分なストレージ容量がある

### エラーが発生した場合
1. **制約エラー**: 既存データが制約に違反している可能性
2. **権限エラー**: 適切な権限がない可能性
3. **構文エラー**: SQLの構文に問題がある可能性

### ロールバック方法
問題が発生した場合は、以下のSQLでテーブルを削除：
```sql
DROP TABLE IF EXISTS user_characters CASCADE;
DROP TABLE IF EXISTS event_history CASCADE;
DROP TABLE IF EXISTS purchase_history CASCADE;
DROP TABLE IF EXISTS user_achievements CASCADE;
DROP TABLE IF EXISTS user_parties CASCADE;
DROP TABLE IF EXISTS user_game_stats CASCADE;
DROP TABLE IF EXISTS user_sessions CASCADE;
DROP TABLE IF EXISTS game_data_backups CASCADE;
DROP TABLE IF EXISTS backup_metadata CASCADE;
DROP TABLE IF EXISTS system_logs CASCADE;
DROP TABLE IF EXISTS performance_metrics CASCADE;
DROP TABLE IF EXISTS error_tracking CASCADE;
DROP TABLE IF EXISTS user_analytics CASCADE;
DROP TABLE IF EXISTS alert_settings CASCADE;
DROP TABLE IF EXISTS alert_history CASCADE;
```

## 🎯 完了基準

### ✅ Phase 2-6: データベーススキーマの拡張
- [ ] 7つの新しいテーブルが作成されている
- [ ] 適切なインデックスが作成されている
- [ ] RLSポリシーが設定されている
- [ ] トリガーが設定されている

### ✅ Phase 2-7: バックアップ・復旧戦略
- [ ] バックアップテーブルが作成されている
- [ ] バックアップ関数が実装されている
- [ ] 復旧関数が実装されている
- [ ] 自動バックアップ機能が実装されている

### ✅ Phase 2-8: 監視・ログ機能
- [ ] ログテーブルが作成されている
- [ ] 監視関数が実装されている
- [ ] アラート機能が実装されている
- [ ] ダッシュボード用ビューが作成されている

## 🚀 完了後の確認

Phase 2完了後、以下を確認してください：

1. **テーブル作成確認**: 全テーブルが正常に作成されている
2. **RLS確認**: セキュリティポリシーが適切に設定されている
3. **関数動作確認**: 各関数が正常に動作する
4. **インデックス確認**: パフォーマンス用インデックスが作成されている

## 📞 サポート

問題が発生した場合は、エラーメッセージと実行したSQLファイル名を教えてください。

## 🎉 Phase 2完了後の次のステップ

Phase 2が完全に完了すると：
- **完全なデータベース統合**: スケーラブルで安全なデータ管理
- **運用監視**: リアルタイムでのシステム監視
- **データ保護**: 自動バックアップと復旧機能
- **拡張性**: 将来の機能追加に対応

**Phase 3: ゲーム機能拡張**に進む準備が整います！
