# 🚀 一鍵部署腳本
# 此腳本幫助你在本設備上完成 Git 配置和部署

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   多設備 AI 協作框架 - 部署助手" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 檢查當前目錄
$currentDir = Get-Location
Write-Host "✓ 當前目錄: $currentDir" -ForegroundColor Green
Write-Host ""

# ============================================
# 步驟 1: 檢查 Git 配置
# ============================================
Write-Host "步驟 1: 檢查 Git 配置..." -ForegroundColor Yellow

# 檢查 Git 是否初始化
if (-not (Test-Path ".git")) {
    Write-Host "! Git 尚未初始化" -ForegroundColor Red
    $initGit = Read-Host "是否要初始化 Git 倉庫? (Y/n)"
    if ($initGit -ne "n") {
        git init
        Write-Host "✓ Git 倉庫已初始化" -ForegroundColor Green
    } else {
        Write-Host "× 已取消，請手動初始化 Git 倉庫" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "✓ Git 倉庫已存在" -ForegroundColor Green
}

Write-Host ""

# 檢查 Git 用戶配置
$gitUserName = git config user.name
$gitUserEmail = git config user.email

if (-not $gitUserName -or -not $gitUserEmail) {
    Write-Host "! Git 用戶信息未設置" -ForegroundColor Red
    Write-Host ""

    $userName = Read-Host "請輸入你的 Git 用戶名"
    $userEmail = Read-Host "請輸入你的 Git 郵箱"

    git config user.name "$userName"
    git config user.email "$userEmail"

    Write-Host "✓ Git 用戶信息已設置" -ForegroundColor Green
    Write-Host "  名稱: $userName" -ForegroundColor Gray
    Write-Host "  郵箱: $userEmail" -ForegroundColor Gray
} else {
    Write-Host "✓ Git 用戶信息已設置" -ForegroundColor Green
    Write-Host "  名稱: $gitUserName" -ForegroundColor Gray
    Write-Host "  郵箱: $gitUserEmail" -ForegroundColor Gray
}

Write-Host ""

# ============================================
# 步驟 2: 檢查遠程倉庫配置
# ============================================
Write-Host "步驟 2: 檢查遠程倉庫配置..." -ForegroundColor Yellow

$remotes = git remote -v
if (-not $remotes) {
    Write-Host "! 遠程倉庫尚未配置" -ForegroundColor Red
    Write-Host ""
    Write-Host "請選擇操作:" -ForegroundColor Cyan
    Write-Host "  1. 我已經在 GitHub 創建了倉庫，輸入 URL" -ForegroundColor Gray
    Write-Host "  2. 使用 GitHub CLI 自動創建倉庫 (需要安裝 gh)" -ForegroundColor Gray
    Write-Host "  3. 稍後手動設置" -ForegroundColor Gray
    Write-Host ""

    $choice = Read-Host "請選擇 (1/2/3)"

    switch ($choice) {
        "1" {
            Write-Host ""
            Write-Host "GitHub 倉庫 URL 範例:" -ForegroundColor Gray
            Write-Host "  HTTPS: https://github.com/username/repo.git" -ForegroundColor Gray
            Write-Host "  SSH:   git@github.com:username/repo.git" -ForegroundColor Gray
            Write-Host ""

            $repoUrl = Read-Host "請輸入倉庫 URL"
            git remote add origin $repoUrl
            Write-Host "✓ 遠程倉庫已添加" -ForegroundColor Green
        }
        "2" {
            Write-Host ""
            $repoName = Read-Host "請輸入倉庫名稱 (例如: multi-device-ai-collab)"
            $repoType = Read-Host "倉庫類型: 公開(public) 或 私有(private)? (輸入 public 或 private)"

            if ($repoType -eq "public") {
                gh repo create $repoName --public --source=. --remote=origin
            } else {
                gh repo create $repoName --private --source=. --remote=origin
            }

            if ($LASTEXITCODE -eq 0) {
                Write-Host "✓ GitHub 倉庫已創建並設置為遠程倉庫" -ForegroundColor Green
            } else {
                Write-Host "× 創建失敗，請確認已安裝 gh CLI 並已登入" -ForegroundColor Red
                Write-Host "  安裝: https://cli.github.com/" -ForegroundColor Gray
                Write-Host "  登入: gh auth login" -ForegroundColor Gray
            }
        }
        "3" {
            Write-Host "⚠ 稍後請手動添加遠程倉庫:" -ForegroundColor Yellow
            Write-Host "  git remote add origin <你的倉庫URL>" -ForegroundColor Gray
        }
        default {
            Write-Host "× 無效的選擇" -ForegroundColor Red
        }
    }
} else {
    Write-Host "✓ 遠程倉庫已配置" -ForegroundColor Green
    Write-Host $remotes -ForegroundColor Gray
}

Write-Host ""

# ============================================
# 步驟 3: 檢查並提交文件
# ============================================
Write-Host "步驟 3: 檢查文件狀態..." -ForegroundColor Yellow

# 確保 .gitignore 存在
if (-not (Test-Path ".gitignore")) {
    Write-Host "! .gitignore 不存在，正在創建..." -ForegroundColor Yellow
    @"
node_modules/
.env
coverage/
*.log
.DS_Store
dist/
build/
.vscode/.history
"@ | Out-File -FilePath ".gitignore" -Encoding utf8
    Write-Host "✓ .gitignore 已創建" -ForegroundColor Green
}

# 查看未提交的文件
$status = git status --short
if ($status) {
    Write-Host "發現未提交的文件:" -ForegroundColor Yellow
    Write-Host $status -ForegroundColor Gray
    Write-Host ""

    $shouldCommit = Read-Host "是否要提交這些文件? (Y/n)"
    if ($shouldCommit -ne "n") {
        # 添加所有文件
        git add .

        # 顯示將要提交的文件
        Write-Host ""
        Write-Host "將要提交的文件:" -ForegroundColor Green
        git status --short
        Write-Host ""

        # 提交
        $commitMsg = Read-Host "請輸入提交訊息 (直接 Enter 使用預設訊息)"
        if (-not $commitMsg) {
            $commitMsg = "feat: add multi-device AI collaboration framework

- Add complete documentation system (19 documents)
- Add AI agent collaboration guides
- Add discussion space management system
- Add automation scripts and configurations
- Add deployment guide for current device"
        }

        git commit -m "$commitMsg"

        if ($LASTEXITCODE -eq 0) {
            Write-Host "✓ 文件已提交" -ForegroundColor Green
        } else {
            Write-Host "× 提交失敗" -ForegroundColor Red
        }
    }
} else {
    Write-Host "✓ 沒有未提交的文件" -ForegroundColor Green
}

Write-Host ""

# ============================================
# 步驟 4: 推送到遠程倉庫
# ============================================
Write-Host "步驟 4: 推送到遠程倉庫..." -ForegroundColor Yellow

# 檢查當前分支
$currentBranch = git branch --show-current
if (-not $currentBranch) {
    Write-Host "! 沒有當前分支，創建 main 分支..." -ForegroundColor Yellow
    git checkout -b main
    $currentBranch = "main"
}

Write-Host "當前分支: $currentBranch" -ForegroundColor Gray

# 檢查是否有遠程倉庫
$hasRemote = git remote -v
if ($hasRemote) {
    Write-Host ""
    $shouldPush = Read-Host "是否要推送到遠程倉庫? (Y/n)"

    if ($shouldPush -ne "n") {
        Write-Host "正在推送..." -ForegroundColor Yellow

        # 嘗試推送
        git push -u origin $currentBranch

        if ($LASTEXITCODE -eq 0) {
            Write-Host "✓ 成功推送到遠程倉庫!" -ForegroundColor Green
        } else {
            Write-Host "× 推送失敗" -ForegroundColor Red
            Write-Host ""
            Write-Host "可能的原因和解決方法:" -ForegroundColor Yellow
            Write-Host "  1. 認證失敗 - 運行: gh auth login" -ForegroundColor Gray
            Write-Host "  2. 遠程倉庫不為空 - 運行: git pull origin main --allow-unrelated-histories" -ForegroundColor Gray
            Write-Host "  3. 分支名稱不匹配 - 運行: git branch -M main" -ForegroundColor Gray
            Write-Host ""
            Write-Host "詳細說明請查看: DEPLOY_THIS_DEVICE.md" -ForegroundColor Cyan
        }
    }
} else {
    Write-Host "⚠ 沒有配置遠程倉庫，跳過推送" -ForegroundColor Yellow
    Write-Host "請先添加遠程倉庫: git remote add origin <URL>" -ForegroundColor Gray
}

Write-Host ""

# ============================================
# 步驟 5: 檢查 Node.js 環境
# ============================================
Write-Host "步驟 5: 檢查 Node.js 環境..." -ForegroundColor Yellow

try {
    $nodeVersion = node --version
    $npmVersion = npm --version
    Write-Host "✓ Node.js: $nodeVersion" -ForegroundColor Green
    Write-Host "✓ npm: $npmVersion" -ForegroundColor Green

    # 檢查是否已安裝依賴
    if (-not (Test-Path "node_modules")) {
        Write-Host ""
        $shouldInstall = Read-Host "是否要安裝 Node.js 依賴? (Y/n)"
        if ($shouldInstall -ne "n") {
            Write-Host "正在安裝依賴..." -ForegroundColor Yellow
            npm install

            if ($LASTEXITCODE -eq 0) {
                Write-Host "✓ 依賴安裝成功" -ForegroundColor Green
            } else {
                Write-Host "× 依賴安裝失敗" -ForegroundColor Red
            }
        }
    } else {
        Write-Host "✓ Node.js 依賴已安裝" -ForegroundColor Green
    }
} catch {
    Write-Host "× Node.js 未安裝" -ForegroundColor Red
    Write-Host "請前往 https://nodejs.org/ 下載安裝 (推薦 LTS 版本)" -ForegroundColor Yellow
}

Write-Host ""

# ============================================
# 步驟 6: 檢查 VSCode 擴展
# ============================================
Write-Host "步驟 6: 檢查 VSCode 擴展..." -ForegroundColor Yellow

try {
    $extensions = code --list-extensions
    $hasCopilot = $extensions -match "github.copilot"
    $hasCopilotChat = $extensions -match "github.copilot-chat"

    if ($hasCopilot) {
        Write-Host "✓ GitHub Copilot 已安裝" -ForegroundColor Green
    } else {
        Write-Host "× GitHub Copilot 未安裝" -ForegroundColor Red
        Write-Host "  安裝: code --install-extension GitHub.copilot" -ForegroundColor Gray
    }

    if ($hasCopilotChat) {
        Write-Host "✓ GitHub Copilot Chat 已安裝" -ForegroundColor Green
    } else {
        Write-Host "× GitHub Copilot Chat 未安裝" -ForegroundColor Red
        Write-Host "  安裝: code --install-extension GitHub.copilot-chat" -ForegroundColor Gray
    }

    if (-not $hasCopilot -or -not $hasCopilotChat) {
        Write-Host ""
        $shouldInstallExt = Read-Host "是否要安裝缺失的擴展? (Y/n)"
        if ($shouldInstallExt -ne "n") {
            if (-not $hasCopilot) {
                code --install-extension GitHub.copilot
            }
            if (-not $hasCopilotChat) {
                code --install-extension GitHub.copilot-chat
            }
            Write-Host "✓ 擴展安裝完成，請重新啟動 VSCode" -ForegroundColor Green
        }
    }
} catch {
    Write-Host "⚠ 無法檢查 VSCode 擴展 (VSCode 可能未安裝或未添加到 PATH)" -ForegroundColor Yellow
}

Write-Host ""

# ============================================
# 完成
# ============================================
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "           部署檢查完成!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "下一步操作:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  1. 🚀 5 分鐘 AI 快速測試" -ForegroundColor Green
Write-Host "     查看: AI_QUICK_START.md" -ForegroundColor Gray
Write-Host "     在 VSCode 中按 Ctrl+I 開始使用 AI" -ForegroundColor Gray
Write-Host ""
Write-Host "  2. 📖 深入學習 AI 協作" -ForegroundColor Green
Write-Host "     查看: AI_AGENT_COLLABORATION_GUIDE.md" -ForegroundColor Gray
Write-Host ""
Write-Host "  3. 👥 設置多設備協作" -ForegroundColor Green
Write-Host "     查看: DEVICE_SETUP_GUIDE.md" -ForegroundColor Gray
Write-Host ""
Write-Host "  4. 💬 創建第一個討論空間" -ForegroundColor Green
Write-Host "     運行: .\create-discussion-space.ps1 -ProjectName `"my-project`"" -ForegroundColor Gray
Write-Host ""
Write-Host "完整部署說明: DEPLOY_THIS_DEVICE.md" -ForegroundColor Cyan
Write-Host "文檔導航: DOCS_INDEX.md" -ForegroundColor Cyan
Write-Host ""
Write-Host "祝你使用愉快! 🎉" -ForegroundColor Green
Write-Host ""
