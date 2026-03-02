# 快速設置腳本
# 用於在新設備上快速配置開發環境

Write-Host "==================================" -ForegroundColor Cyan
Write-Host "GitHub Copilot 協作環境設置工具" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# 檢查 Git 安裝
Write-Host "檢查 Git 安裝..." -ForegroundColor Yellow
if (Get-Command git -ErrorAction SilentlyContinue) {
    $gitVersion = git --version
    Write-Host " Git 已安裝: $gitVersion" -ForegroundColor Green
}
else {
    Write-Host " Git 未安裝" -ForegroundColor Red
    Write-Host "請從 https://git-scm.com/ 下載並安裝 Git" -ForegroundColor Yellow
    exit 1
}

# 檢查 Node.js 安裝
Write-Host "檢查 Node.js 安裝..." -ForegroundColor Yellow
if (Get-Command node -ErrorAction SilentlyContinue) {
    $nodeVersion = node --version
    Write-Host " Node.js 已安裝: $nodeVersion" -ForegroundColor Green
}
else {
    Write-Host " Node.js 未安裝" -ForegroundColor Red
    Write-Host "請從 https://nodejs.org/ 下載並安裝 Node.js" -ForegroundColor Yellow
    exit 1
}

# 檢查 VSCode 安裝
Write-Host "檢查 VSCode 安裝..." -ForegroundColor Yellow
if (Get-Command code -ErrorAction SilentlyContinue) {
    Write-Host " VSCode 已安裝" -ForegroundColor Green
}
else {
    Write-Host " VSCode 未安裝或未添加到 PATH" -ForegroundColor Red
    Write-Host "請從 https://code.visualstudio.com/ 下載並安裝 VSCode" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "配置 Git 用戶資訊" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# 獲取當前 Git 配置
$currentName = git config --global user.name
$currentEmail = git config --global user.email

if ($currentName) {
    Write-Host "當前 Git 用戶名: $currentName" -ForegroundColor Yellow
    $changeName = Read-Host "是否要更改? (y/N)"
    if ($changeName -eq "y" -or $changeName -eq "Y") {
        $userName = Read-Host "請輸入您的 Git 用戶名"
        git config --global user.name $userName
        Write-Host " Git 用戶名已設置為: $userName" -ForegroundColor Green
    }
}
else {
    $userName = Read-Host "請輸入您的 Git 用戶名"
    git config --global user.name $userName
    Write-Host " Git 用戶名已設置為: $userName" -ForegroundColor Green
}

if ($currentEmail) {
    Write-Host "當前 Git 郵箱: $currentEmail" -ForegroundColor Yellow
    $changeEmail = Read-Host "是否要更改? (y/N)"
    if ($changeEmail -eq "y" -or $changeEmail -eq "Y") {
        $userEmail = Read-Host "請輸入您的 Git 郵箱"
        git config --global user.email $userEmail
        Write-Host " Git 郵箱已設置為: $userEmail" -ForegroundColor Green
    }
}
else {
    $userEmail = Read-Host "請輸入您的 Git 郵箱"
    git config --global user.email $userEmail
    Write-Host " Git 郵箱已設置為: $userEmail" -ForegroundColor Green
}

Write-Host ""
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "安裝 VSCode 擴展" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

$extensions = @(
    "GitHub.copilot",
    "GitHub.copilot-chat",
    "ms-vsliveshare.vsliveshare",
    "dbaeumer.vscode-eslint",
    "esbenp.prettier-vscode",
    "eamodio.gitlens"
)

foreach ($ext in $extensions) {
    Write-Host "安裝 $ext..." -ForegroundColor Yellow
    code --install-extension $ext --force
    if ($LASTEXITCODE -eq 0) {
        Write-Host " $ext 安裝完成" -ForegroundColor Green
    }
    else {
        Write-Host " $ext 安裝失敗" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "設置 Git 配置" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# 設置有用的 Git 配置
Write-Host "配置 Git 自動換行..." -ForegroundColor Yellow
git config --global core.autocrlf true

Write-Host "配置 Git 預設分支名稱..." -ForegroundColor Yellow
git config --global init.defaultBranch main

Write-Host "配置 Git 自動拉取..." -ForegroundColor Yellow
git config --global pull.rebase false

Write-Host " Git 配置完成" -ForegroundColor Green

Write-Host ""
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "克隆儲存庫 (可選)" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

$cloneRepo = Read-Host "是否要克隆 Git 儲存庫? (y/N)"
if ($cloneRepo -eq "y" -or $cloneRepo -eq "Y") {
    $repoUrl = Read-Host "請輸入 Git 儲存庫 URL"
    $repoPath = Read-Host "請輸入克隆路徑 (留空使用當前目錄)"
    
    if ([string]::IsNullOrWhiteSpace($repoPath)) {
        git clone $repoUrl
    }
    else {
        git clone $repoUrl $repoPath
    }
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host " 儲存庫克隆成功" -ForegroundColor Green
        
        # 提取儲存庫名稱
        $repoName = $repoUrl.Split('/')[-1].Replace('.git', '')
        if ([string]::IsNullOrWhiteSpace($repoPath)) {
            $projectPath = Join-Path (Get-Location) $repoName
        }
        else {
            $projectPath = $repoPath
        }
        
        $openVscode = Read-Host "是否在 VSCode 中打開專案? (y/N)"
        if ($openVscode -eq "y" -or $openVscode -eq "Y") {
            code $projectPath
        }
    }
    else {
        Write-Host " 儲存庫克隆失敗" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "設置完成!" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "接下來的步驟：" -ForegroundColor Yellow
Write-Host "1. 在 VSCode 中登入 GitHub 賬號" -ForegroundColor White
Write-Host "   - 點擊左下角的帳戶圖示 -> Sign in to Sync Settings -> Sign in with GitHub" -ForegroundColor Gray
Write-Host ""
Write-Host "2. 啟用 GitHub Copilot" -ForegroundColor White
Write-Host "   - 確保您的 GitHub 賬號有 Copilot 訂閱" -ForegroundColor Gray
Write-Host "   - VSCode 會自動提示您授權 Copilot" -ForegroundColor Gray
Write-Host ""
Write-Host "3. 開始協作開發！" -ForegroundColor White
Write-Host "   - 查看 README.md 了解詳細協作流程" -ForegroundColor Gray
Write-Host "   - 查看 WORKFLOW.md 了解工作流程" -ForegroundColor Gray
Write-Host "   - 查看 COPILOT_PROMPTS.md 學習常用提示詞" -ForegroundColor Gray
Write-Host ""
Write-Host "祝您開發順利！" -ForegroundColor Green
Write-Host ""

# 暫停讓用戶看到訊息
Read-Host "按 Enter 鍵退出"
