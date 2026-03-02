# Setup Script 修復指南

## 問題說明

`setup.ps1` 腳本存在字元編碼問題，導致 PowerShell 無法正確解析。

## 快速解決方案

### 方法 1：手動安裝（推薦）

無需運行 setup.ps1，您可以手動完成設置：

```powershell
# 1. 配置 Git 用戶資訊
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# 2. 配置 Git 設定
git config --global core.autocrlf true
git config --global init.defaultBranch main
git config --global pull.rebase false

# 3. 安裝 VSCode 擴展
code --install-extension GitHub.copilot
code --install-extension GitHub.copilot-chat
code --install-extension ms-vsliveshare.vsliveshare
code --install-extension dbaeumer.vscode-eslint
code --install-extension esbenp.prettier-vscode
code --install-extension eamodio.gitlens

# 4. 在 VSCode 中登入 GitHub
# 點擊左下角帳戶圖示 → Sign in with GitHub → 授權
```

### 方法 2：創建新的設置腳本

在 PowerShell 中執行以下命令創建新的設置腳本：

```powershell
# 創建新的 setup腳本（英文版）
@'
# GitHub Copilot Setup Script

Write-Host "GitHub Copilot Setup Tool" -ForegroundColor Cyan
Write-Host ""

# Check Git
if (Get-Command git -ErrorAction SilentlyContinue) {
    Write-Host "[OK] Git installed: $(git --version)" -ForegroundColor Green
} else {
    Write-Host "[ERROR] Git not found!" -ForegroundColor Red
    exit 1
}

# Check Node.js
if (Get-Command node -ErrorAction SilentlyContinue) {
    Write-Host "[OK] Node.js installed: $(node --version)" -ForegroundColor Green
} else {
    Write-Host "[ERROR] Node.js not found!" -ForegroundColor Red
    exit 1
}

# Check VSCode
if (Get-Command code -ErrorAction SilentlyContinue) {
    Write-Host "[OK] VSCode installed" -ForegroundColor Green
} else {
    Write-Host "[ERROR] VSCode not found!" -ForegroundColor Red
    exit 1
}

# Configure Git
Write-Host ""
Write-Host "Configuring Git..." -ForegroundColor Yellow

$name = Read-Host "Enter your Git username"
$email = Read-Host "Enter your Git email"

git config --global user.name $name
git config --global user.email $email
git config --global core.autocrlf true
git config --global init.defaultBranch main
git config --global pull.rebase false

Write-Host "[OK] Git configured!" -ForegroundColor Green

# Install VSCode extensions
Write-Host ""
Write-Host "Installing VSCode extensions..." -ForegroundColor Yellow

$exts = @("GitHub.copilot", "GitHub.copilot-chat", "ms-vsliveshare.vsliveshare", "dbaeumer.vscode-eslint", "esbenp.prettier-vscode", "eamodio.gitlens")

foreach ($ext in $exts) {
    Write-Host "Installing $ext..." -ForegroundColor Gray
    code --install-extension $ext --force 2>&1 | Out-Null
}

Write-Host "[OK] Extensions installed!" -ForegroundColor Green
Write-Host ""
Write-Host "Setup complete! Please sign in to GitHub in VSCode." -ForegroundColor Cyan
Read-Host "Press Enter to exit"
'@ | Out-File -FilePath "setup.ps1" -Encoding UTF8 -Force

Write-Host "New setup.ps1 created successfully!" -ForegroundColor Green
```

然後運行：
```powershell
.\setup.ps1
```

## 設備操作指南

無論是否運行設置腳本，請按照以下指南進行：

### 設備 A（項目負責人）

1. **配置 Git**
   ```powershell
   git config --global user.name "Developer A"
   git config --global user.email "developer1@example.com"
   ```

2. **創建 GitHub 儲存庫**
   - 登入 GitHub 網站
   - 創建新儲存庫（Private）
   - 添加設備 B 和 C 的賬號作為協作者

3. **初始化項目**
   ```powershell
   cd d:\TEJ
   git init
   git add .
   git commit -m "init: project setup"
   git remote add origin https://github.com/your-username/your-repo.git
   git push -u origin main
   ```

4. **創建討論空間**
   ```powershell
   .\create-discussion-space.ps1 -ProjectName "team-project"
   git add discussions/
   git commit -m "chore: add discussion space"
   git push
   ```

### 設備 B 和 C（協作開發者）

1. **配置 Git**
   ```powershell
   # 設備 B
   git config --global user.name "Developer B"
   git config --global user.email "developer2@example.com"

   # 設備 C
   git config --global user.name "Developer C"
   git config --global user.email "developer3@example.com"
   ```

2. **克隆項目**
   ```powershell
   git clone https://github.com/your-username/your-repo.git
   cd your-repo
   ```

3. **安裝依賴**
   ```powershell
   npm install
   ```

4. **在 VSCode 中打開**
   ```powershell
   code .
   ```

## VSCode GitHub Copilot 設置

在每台設備上：

1. **打開 VSCode**
2. **登入 GitHub**
   - 按 `F1` 或 `Ctrl+Shift+P`
   - 輸入 "GitHub: Sign In"
   - 在瀏覽器中授權
3. **啟用 Copilot**
   - 按 `F1` 或 `Ctrl+Shift+P`
   - 輸入 "GitHub Copilot: Sign In"
   - 使用對應設備的 GitHub 賬號登入

## 驗證設置

運行以下命令驗證環境：

```powershell
# 檢查 Git 配置
git config --list | Select-String "user"

# 檢查 Node.js
node --version
npm --version

# 檢查 VSCode
code --version

# 檢查 VSCode 擴展
code --list-extensions | Select-String "github.copilot"
```

## 開始協作

設置完成後，請查看：

- **[README.md](README.md)** - 主要文檔和總覽
- **[DEVICE_SETUP_GUIDE.md](DEVICE_SETUP_GUIDE.md)** - 詳細的設備操作指南
- **[QUICKSTART.md](QUICKSTART.md)** - 15分鐘快速開始
- **[DISCUSSION_GUIDE.md](DISCUSSION_GUIDE.md)** - 討論空間使用指南

## 常見問題

### Q: 為什麼 setup.ps1 無法運行？
A: 文件編碼問題。請使用方法1（手動安裝）或方法2（重新創建腳本）。

### Q: VSCode 擴展安裝失敗怎麼辦？
A: 在 VSCode 中手動安裝：
   - 按 `Ctrl+Shift+X` 打開擴展面板
   - 搜尋並安裝：GitHub Copilot, GitHub Copilot Chat, Live Share

### Q: 如何確認 Copilot 正常工作？
A:
   1. 打開任何 .js 或 .py 文件
   2. 開始輸入代碼，應該會看到灰色的建議
   3. 按 `Tab` 接受建議
   4. 或按 `Ctrl+I` 打開 Copilot Chat

## 需要幫助？

如果遇到問題，請：
1. 查看 [DEVICE_SETUP_GUIDE.md](DEVICE_SETUP_GUIDE.md) 中的詳細步驟
2. 檢查 Git、Node.js、VSCode 是否正確安裝和配置
3. 確認 GitHub 賬號有 Copilot 訂閱

---

**最後更新：** 2026年3月2日
