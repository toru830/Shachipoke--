@echo off
chcp 65001 >nul
title シャチポケ２ - Gitセットアップ
color 0A

echo.
echo ========================================
echo   シャチポケ２ - Gitリポジトリセットアップ
echo ========================================
echo.

REM Gitがインストールされているか確認
echo [1/3] Gitの確認中...
git --version >nul 2>&1
if errorlevel 1 (
    echo.
    echo ❌ エラー: Gitがインストールされていません
    echo.
    echo Gitをインストールしてください:
    echo https://git-scm.com/download/win
    echo.
    pause
    exit /b 1
)
echo ✓ Gitが見つかりました
echo.

REM Gitリポジトリの初期化
echo [2/3] Gitリポジトリを初期化中...
if exist .git (
    echo ✓ 既にGitリポジトリが存在します
) else (
    git init >nul 2>&1
    if errorlevel 1 (
        echo ❌ エラー: Gitの初期化に失敗しました
        pause
        exit /b 1
    )
    echo ✓ Gitリポジトリを初期化しました
)
echo.

REM ファイルを追加
echo [3/3] ファイルを追加中...
git add . >nul 2>&1
if errorlevel 1 (
    echo ❌ エラー: ファイルの追加に失敗しました
    pause
    exit /b 1
)
echo ✓ ファイルを追加しました
echo.

REM コミット
echo コミットを作成中...
git commit -m "Initial commit: シャチポケ２ ready for Cloudflare Pages" >nul 2>&1
if errorlevel 1 (
    echo ❌ エラー: コミットに失敗しました
    echo （既にコミット済みの可能性があります）
) else (
    echo ✓ コミットを作成しました
)
echo.

echo ========================================
echo   ✓ セットアップ完了！
echo ========================================
echo.
echo 次のステップ:
echo.
echo 1. GitHubでリポジトリを作成:
echo    https://github.com/new
echo.
echo 2. 以下のコマンドでGitHubにプッシュ:
echo    git remote add origin https://github.com/あなたのユーザー名/リポジトリ名.git
echo    git branch -M main
echo    git push -u origin main
echo.
echo 3. Cloudflare Pagesでデプロイ:
echo    https://dash.cloudflare.com
echo.
echo 詳細は README_DEPLOY.md を参照してください
echo.
pause

