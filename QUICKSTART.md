# 快速開始指南

本指南將幫助您在 15 分鐘內完成 3 台設備的協作開發環境設置。

## ⏱️ 預計時間：15 分鐘

## 📋 準備清單

在開始之前，準備以下資訊：

- [ ] 3 個 GitHub 賬號和密碼
- [ ] 每個賬號都有 GitHub Copilot 訂閱
- [ ] GitHub 儲存庫 URL（如果已存在）
- [ ] 確定每個設備的角色（開發者 A、B、C）

## 🚀 逐步設置

### 第 1 步：安裝必要軟體（每台設備）

#### Windows

1. **安裝 Git**
   - 訪問: https://git-scm.com/download/win
   - 下載並執行安裝程式
   - 使用默認設置即可

2. **安裝 Node.js**
   - 訪問: https://nodejs.org/
   - 下載 LTS 版本（推薦 18.x）
   - 執行安裝程式

3. **安裝 VSCode**
   - 訪問: https://code.visualstudio.com/
   - 下載並安裝
   - 安裝時勾選 "Add to PATH"

### 第 2 步：執行自動設置腳本

在每台設備上執行：

```powershell
# 1. 下載專案設置文件
git clone https://github.com/your-username/TEJ.git
cd TEJ

# 2. 執行設置腳本
.\setup.ps1

# 腳本會自動：
# - 檢查環境
# - 配置 Git
# - 安裝 VSCode 擴展
# - 設置基本配置
```

### 第 3 步：配置 GitHub 賬號（每台設備各自設置）

#### 設備 A

```powershell
# 設置 Git 身份
git config --global user.name "Developer A"
git config --global user.email "developerA@example.com"
```

#### 設備 B

```powershell
# 設置 Git 身份
git config --global user.name "Developer B"
git config --global user.email "developerB@example.com"
```

#### 設備 C

```powershell
# 設置 Git 身份
git config --global user.name "Developer C"
git config --global user.email "developerC@example.com"
```

### 第 4 步：在 VSCode 中登入 GitHub

**在每台設備上：**

1. 開啟 VSCode
2. 點擊左下角的 **帳戶圖示** (人形圖標)
3. 選擇 **"Sign in to Sync Settings"**
4. 選擇 **"Sign in with GitHub"**
5. 瀏覽器會開啟，使用對應的 GitHub 賬號登入
6. 授權 VSCode 訪問權限
7. 返回 VSCode，確認登入成功

### 第 5 步：啟用 GitHub Copilot

1. VSCode 會自動提示您啟用 Copilot
2. 點擊 **"啟用 GitHub Copilot"**
3. 授權 Copilot 訪問權限
4. 等待 Copilot 初始化完成

**驗證 Copilot 是否正常工作：**

1. 創建一個新的 `.js` 文件
2. 輸入: `// Function to add two numbers`
3. 按 Enter，Copilot 應該會自動建議代碼
4. 按 Tab 接受建議

### 第 6 步：創建或克隆共享儲存庫

#### 選項 A：創建新專案（在設備 A 上）

```powershell
# 1. 在 GitHub 上創建新儲存庫
# 訪問: https://github.com/new
# 儲存庫名稱: team-project
# 公開或私有: 根據需求選擇
# 不要初始化 README

# 2. 在本地初始化專案
mkdir team-project
cd team-project
git init
git branch -M main

# 3. 使用 Copilot 創建專案結構
# 在 VSCode 中打開 team-project 資料夾
# 在 Copilot Chat 中輸入：
# "@workspace 為一個 Node.js Express API 專案創建標準目錄結構"

# 4. 推送到 GitHub
git add .
git commit -m "init: project setup"
git remote add origin https://github.com/your-username/team-project.git
git push -u origin main
```

#### 選項 B：克隆現有專案（所有設備）

```powershell
# 克隆儲存庫
git clone https://github.com/your-org/team-project.git
cd team-project

# 安裝依賴
npm install

# 運行測試確保環境正常
npm test
```

### 第 7 步：設置協作權限

1. **在 GitHub 上添加協作者**
   - 前往儲存庫設置: `https://github.com/your-org/team-project/settings`
   - 點擊 **"Collaborators"**
   - 點擊 **"Add people"**
   - 添加另外兩個 GitHub 賬號
   - 發送邀請

2. **接受邀請**
   - 其他設備的用戶檢查郵件
   - 點擊邀請連結並接受

3. **設置分支保護**（可選但推薦）
   - 前往: Settings → Branches
   - 點擊 **"Add rule"**
   - Branch name pattern: `main`
   - 啟用:
     - ☑ Require pull request reviews before merging
     - ☑ Require status checks to pass before merging

## ✅ 驗證設置

### 測試 1：分支和推送（每台設備）

```powershell
# 創建測試分支
git checkout -b test/device-[A/B/C]

# 創建測試文件
echo "# Test from Device [A/B/C]" > test-[A/B/C].md

# 提交並推送
git add .
git commit -m "test: verify device [A/B/C] setup"
git push origin test/device-[A/B/C]
```

### 測試 2：Copilot 功能（每台設備）

1. 在 VSCode 中按 `Ctrl+I`（Windows）開啟 Copilot Chat
2. 輸入: `@workspace 說明這個專案的結構`
3. Copilot 應該分析專案並給出說明

### 測試 3：Pull Request 流程

**設備 A:**

```powershell
# 創建簡單的功能
git checkout -b feature/hello-world

# 創建文件
echo "console.log('Hello from Device A');" > hello-a.js

# 提交並推送
git add .
git commit -m "feat: add hello world from device A"
git push origin feature/hello-world

# 在 GitHub 上創建 Pull Request
```

**設備 B:**

- 前往 GitHub 儲存庫
- 查看 Pull Request
- 審查代碼並留下評論
- 批准或請求修改

**設備 C:**

- 拉取分支: `git fetch origin && git checkout feature/hello-world`
- 本地測試: `node hello-a.js`
- 在 PR 中添加測試結果

## 🎯 第一個協作任務

現在您的環境已設置完成，嘗試第一個協作任務：

### 任務：創建簡單的用戶 API

**設備 A - 實作 API 端點**

```powershell
git checkout -b feature/user-api

# 在 Copilot Chat 中：
# "@workspace 創建一個 Express.js API 端點用於獲取用戶列表，返回 JSON 格式"

# 編寫代碼後
git add .
git commit -m "feat(api): add user list endpoint"
git push origin feature/user-api

# 創建 Pull Request
```

**設備 B - 代碼審查**

```powershell
# 拉取分支
git fetch origin
git checkout feature/user-api

# 在 Copilot Chat 中：
# "@workspace 審查這個分支的代碼品質和安全性"

# 在 GitHub PR 中提供反饋
```

**設備 C - 添加測試**

```powershell
# 創建測試分支
git checkout feature/user-api
git checkout -b test/user-api

# 在 Copilot Chat 中：
# "@workspace 為 user-api 端點生成完整的測試套件"

# 提交測試
git add .
git commit -m "test: add user API tests"
git push origin test/user-api

# 創建 Pull Request 到 feature/user-api
```

## 📚 下一步

設置完成後，建議閱讀：

1. **[README.md](README.md)** - 完整的協作指南
2. **[WORKFLOW.md](WORKFLOW.md)** - 詳細的工作流程
3. **[COPILOT_PROMPTS.md](COPILOT_PROMPTS.md)** - 常用提示詞庫
4. **[CONTRIBUTING.md](CONTRIBUTING.md)** - 貢獻指南

## 🆘 疑難排解

### 問題 1：Git 推送失敗

```
錯誤: Permission denied (publickey)
```

**解決方案：**

```powershell
# 生成 SSH 金鑰
ssh-keygen -t ed25519 -C "your-email@example.com"

# 添加到 SSH agent
ssh-add ~/.ssh/id_ed25519

# 複製公鑰
Get-Content ~/.ssh/id_ed25519.pub | Set-Clipboard

# 前往 GitHub: Settings → SSH and GPG keys → New SSH key
# 貼上公鑰
```

### 問題 2：Copilot 沒有建議

**解決方案：**

1. 檢查 Copilot 狀態列圖示（右下角）
2. 確保已登入 GitHub
3. 確保 Copilot 訂閱有效
4. 重新載入 VSCode: `Ctrl+Shift+P` → "Reload Window"
5. 檢查設定: `Ctrl+,` → 搜尋 "copilot" → 確保已啟用

### 問題 3：合併衝突

```powershell
# 更新 main 分支
git checkout main
git pull origin main

# 回到功能分支
git checkout your-feature-branch

# 合併 main
git merge main

# 使用 VSCode 解決衝突
# 或使用 Copilot: "@workspace 幫我解決這個合併衝突"

# 完成合併
git add .
git commit -m "merge: resolve conflicts"
git push origin your-feature-branch
```

### 問題 4：VSCode 擴展安裝失敗

**解決方案：**

```powershell
# 手動安裝
code --install-extension GitHub.copilot --force
code --install-extension GitHub.copilot-chat --force

# 如果仍然失敗，在 VSCode 中：
# Extensions → 搜尋 "GitHub Copilot" → Install
```

## 💡 提示和技巧

### 1. 使用 Git Alias 提高效率

```powershell
# 添加常用的 Git alias
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'

# 使用範例
git co main          # checkout main
git st               # status
git ci -m "message"  # commit
```

### 2. 設置 VSCode 快捷鍵

在 VSCode 中按 `Ctrl+K Ctrl+S` 開啟快捷鍵設定，添加：

- `Ctrl+K Ctrl+C`: Copilot Chat
- `Ctrl+K Ctrl+I`: Copilot Inline Chat
- `Ctrl+Enter`: 接受所有 Copilot 建議

### 3. 使用 Live Share 即時協作

```powershell
# 安裝 Live Share
code --install-extension MS-vsliveshare.vsliveshare

# 開始會話
# VSCode: 點擊底部狀態欄 "Live Share" → Start collaboration session
# 分享連結給團隊成員
```

## 🎉 完成！

恭喜！您已經完成了 3 台設備的協作開發環境設置。

現在可以開始高效的團隊協作開發了！

---

**需要幫助？**

- 查看 [README.md](README.md) 獲取更多資訊
- 在專案中創建 Issue
- 使用 Copilot: `@workspace 如何...`

**Happy Coding! 🚀**
