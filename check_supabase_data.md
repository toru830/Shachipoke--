# Supabaseデータ保存確認方法

## 方法1: Supabaseダッシュボードで確認

1. **Supabaseダッシュボードにアクセス**
   - https://supabase.com/dashboard
   - プロジェクト「shachipoke2」を選択

2. **Table Editorで確認**
   - 左メニュー「Table Editor」をクリック
   - 以下のテーブルを確認：
     - `event_history`: イベント履歴が保存されているか
     - `user_game_stats`: 統計情報が更新されているか
     - `game_saves`: ゲームセーブデータが保存されているか

## 方法2: コンソールログで確認

ブラウザのコンソールを確認：
- `'イベント履歴を保存開始:'` というログが表示される
- `'イベント履歴保存成功'` というログが表示される
- `'統計更新成功'` というログが表示される

## 方法3: SQL Editorで確認

```sql
-- イベント履歴を確認
SELECT * FROM event_history 
WHERE user_id = 'YOUR_USER_ID' 
ORDER BY created_at DESC;

-- 統計情報を確認
SELECT * FROM user_game_stats 
WHERE user_id = 'YOUR_USER_ID';
```

## Phase 3-1 修正完了 ✅

### 修正内容
1. **イベント回数の修正**: 各タイプのイベントを1日1回だけ実行可能
2. **completedEventTypes管理**: 完了したイベントタイプを記録
3. **重複チェック**: 同じタイプのイベントを2回以上実行できないように制限

### これで動作するはずです

ブラウザでリロードしてテストしてください！

**期待される動作**:
- 各イベントタイプ（上司とのやり取り、社内政治、カスタマーサービス）を1回ずつ実行可能
- 同じタイプのイベントを2回実行しようとすると警告表示
- 合計3回のイベントを実行可能
