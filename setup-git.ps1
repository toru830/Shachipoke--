# Gitリポジトリのセットアップスクリプト
# PowerShellで実行: .\setup-git.ps1

Write-Host "=== Gitリポジトリのセットアップ ===" -ForegroundColor Green

# Gitがインストールされているか確認
try {
    $gitVersion = git --version
    Write-Host "Gitが見つかりました: $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "エラー: Gitがインストールされていません" -ForegroundColor Red
    Write-Host "Gitをインストールしてください: https://git-scm.com/download/win" -ForegroundColor Yellow
    exit 1
}

# 現在のディレクトリを確認
$currentDir = Get-Location
Write-Host "現在のディレクトリ: $currentDir" -ForegroundColor Cyan

# Gitリポジトリが既に存在するか確認
if (Test-Path .git) {
    Write-Host "既にGitリポジトリが存在します" -ForegroundColor Yellow
    $continue = Read-Host "続行しますか？ (y/n)"
    if ($continue -ne "y") {
        exit 0
    }
} else {
    Write-Host "Gitリポジトリを初期化しています..." -ForegroundColor Cyan
    git init
    if ($LASTEXITCODE -ne 0) {
        Write-Host "エラー: Gitの初期化に失敗しました" -ForegroundColor Red
        exit 1
    }
    Write-Host "✓ Gitリポジトリを初期化しました" -ForegroundColor Green
}

# すべてのファイルを追加
Write-Host "ファイルを追加しています..." -ForegroundColor Cyan
git add .
if ($LASTEXITCODE -ne 0) {
    Write-Host "エラー: ファイルの追加に失敗しました" -ForegroundColor Red
    exit 1
}
Write-Host "✓ ファイルを追加しました" -ForegroundColor Green

# コミット
Write-Host "初回コミットを作成しています..." -ForegroundColor Cyan
git commit -m "Initial commit: シャチポケ２ ready for Cloudflare Pages"
if ($LASTEXITCODE -ne 0) {
    Write-Host "エラー: コミットに失敗しました" -ForegroundColor Red
    exit 1
}
Write-Host "✓ コミットを作成しました" -ForegroundColor Green

Write-Host ""
Write-Host "=== セットアップ完了！ ===" -ForegroundColor Green
Write-Host ""
Write-Host "次のステップ:" -ForegroundColor Yellow
Write-Host "1. GitHubでリポジトリを作成: https://github.com/new" -ForegroundColor Cyan
Write-Host "2. 以下のコマンドでGitHubにプッシュ:" -ForegroundColor Cyan
Write-Host "   git remote add origin https://github.com/あなたのユーザー名/リポジトリ名.git" -ForegroundColor White
Write-Host "   git branch -M main" -ForegroundColor White
Write-Host "   git push -u origin main" -ForegroundColor White
Write-Host ""
Write-Host "詳細は DEPLOY_STEPS.md を参照してください" -ForegroundColor Cyan

