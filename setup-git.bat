@echo off
chcp 65001 >nul
echo === Gitリポジトリのセットアップ ===
echo.

REM Gitがインストールされているか確認
git --version >nul 2>&1
if errorlevel 1 (
    echo エラー: Gitがインストールされていません
    echo Gitをインストールしてください: https://git-scm.com/download/win
    pause
    exit /b 1
)

echo Gitが見つかりました
echo.

REM Gitリポジトリが既に存在するか確認
if exist .git (
    echo 既にGitリポジトリが存在します
    set /p continue="続行しますか？ (y/n): "
    if /i not "%continue%"=="y" exit /b 0
) else (
    echo Gitリポジトリを初期化しています...
    git init
    if errorlevel 1 (
        echo エラー: Gitの初期化に失敗しました
        pause
        exit /b 1
    )
    echo ✓ Gitリポジトリを初期化しました
)

echo.
echo ファイルを追加しています...
git add .
if errorlevel 1 (
    echo エラー: ファイルの追加に失敗しました
    pause
    exit /b 1
)
echo ✓ ファイルを追加しました

echo.
echo 初回コミットを作成しています...
git commit -m "Initial commit: シャチポケ２ ready for Cloudflare Pages"
if errorlevel 1 (
    echo エラー: コミットに失敗しました
    pause
    exit /b 1
)
echo ✓ コミットを作成しました

echo.
echo === セットアップ完了！ ===
echo.
echo 次のステップ:
echo 1. GitHubでリポジトリを作成: https://github.com/new
echo 2. 以下のコマンドでGitHubにプッシュ:
echo    git remote add origin https://github.com/あなたのユーザー名/リポジトリ名.git
echo    git branch -M main
echo    git push -u origin main
echo.
echo 詳細は DEPLOY_STEPS.md を参照してください
echo.
pause

