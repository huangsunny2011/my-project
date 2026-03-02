# 🚀 本設備部署指南

本指南專為 **d:\TEJ** 設備提供完整的部署步驟。

**當前日期：** 2026年3月2日  
**工作目錄：** `d:\TEJ`  
**設備角色：** 待確認（可選擇設備 A、B 或 C）

---

## ✅ 部署檢查清單

### 階段 1：環境準備 ✓（已完成）

- [x] 專案結構已創建
- [x] 所有文檔已生成（18 個文檔）
- [x] PowerShell 腳本已就緒
- [x] 配置檔案已設置

### 階段 2：Git 配置（需要執行）

- [ ] 初始化 Git 倉庫
- [ ] 設置 GitHub 遠程倉庫
- [ ] 提交所有文件
- [ ] 推送到 GitHub

### 階段 3：環境依賴（需要執行）

- [ ] 安裝 Node.js 依賴
- [ ] 驗證 VSCode 擴展
- [ ] 配置 GitHub Copilot
- [ ] 測試 AI Agent

---

## 📋 立即執行：完整部署步驟

### 步驟 1：初始化 Git 倉庫（如尚未初始化）

```powershell
# 在 d:\TEJ 目錄下執行

# 初始化 Git（如果尚未初始化）
git init

# 設置用戶信息（使用你的 GitHub 賬號）
git config user.name "你的名字"
git config user.email "your-email@example.com"

# 檢查狀態
git status
```

### 步驟 2：創建 GitHub 遠程倉庫

**選項 A：使用 GitHub Web 界面**
1. 前往 https://github.com/new
2. 創建新倉庫（例如：`multi-device-ai-collab`）
3. **不要**勾選「Initialize this repository with a README」
4. 創建後複製倉庫 URL

**選項 B：使用 GitHub CLI（如已安裝）**
```powershell
# 創建私有倉庫
gh repo create multi-device-ai-collab --private --source=. --remote=origin

# 或創建公開倉庫
gh repo create multi-device-ai-collab --public --source=. --remote=origin
```

### 步驟 3：連接遠程倉庫並推送

```powershell
# 如果使用 Web 界面創建，添加遠程倉庫
git remote add origin https://github.com/你的用戶名/multi-device-ai-collab.git

# 或使用 SSH
git remote add origin git@github.com:你的用戶名/multi-device-ai-collab.git

# 查看遠程倉庫
git remote -v

# 添加所有文件
git add .

# 創建 .gitignore（如果還沒有）
@"
node_modules/
.env
coverage/
*.log
.DS_Store
discussions/*/
!discussions/.gitkeep
"@ | Out-File -FilePath .gitignore -Encoding utf8

# 提交
git commit -m "feat: initial commit - Multi-device AI collaboration framework

- Add complete documentation system (18 documents)
- Add AI agent collaboration guides
- Add discussion space management system
- Add automation scripts
- Add configuration files
"

# 推送到 GitHub（main 分支）
git branch -M main
git push -u origin main
```

**如果 push 失敗，可能的原因和解決方法：**

#### 問題 1：遠程倉庫未設置
```powershell
# 檢查遠程倉庫
git remote -v

# 如果沒有輸出，需要添加
git remote add origin https://github.com/你的用戶名/倉庫名.git
```

#### 問題 2：main 或 master 分支名稱不匹配
```powershell
# 查看當前分支
git branch

# 重命名為 main
git branch -M main

# 再次推送
git push -u origin main
```

#### 問題 3：認證問題
```powershell
# 使用 GitHub CLI 登入
gh auth login

# 或設置 Personal Access Token
# 前往 https://github.com/settings/tokens
# 創建 token 並使用 token 作為密碼
```

#### 問題 4：遠程倉庫不為空
```powershell
# 先拉取遠程內容
git pull origin main --allow-unrelated-histories

# 解決衝突後再推送
git push -u origin main
```

---

### 步驟 4：安裝 Node.js 依賴

```powershell
# 確認 Node.js 已安裝
node --version
npm --version

# 如果未安裝，下載安裝
# https://nodejs.org/ (推薦 LTS 版本 18.x+)

# 安裝專案依賴
npm install
```

**預期安裝的套件：**
```
express@4.18.2
dotenv@16.3.1
jest@29.7.0
supertest@6.3.3
eslint@8.55.0
prettier@3.1.1
@commitlint/cli@18.4.3
@commitlint/config-conventional@18.4.3
husky@8.0.3
lint-staged@15.2.0
```

---

### 步驟 5：驗證 VSCode 擴展

打開 VSCode，確認已安裝以下擴展：

```powershell
# 檢查已安裝的擴展
code --list-extensions | Select-String -Pattern "github|prettier|eslint"
```

**必需擴展：**
- ✅ `GitHub.copilot` - GitHub Copilot
- ✅ `GitHub.copilot-chat` - GitHub Copilot Chat
- ✅ `esbenp.prettier-vscode` - Prettier
- ✅ `dbaeumer.vscode-eslint` - ESLint

**推薦擴展：**
- `ms-vsliveshare.vsliveshare` - Live Share
- `GitHub.vscode-pull-request-github` - GitHub Pull Requests
- `eamodio.gitlens` - GitLens

**安裝缺失的擴展：**
```powershell
# 安裝 GitHub Copilot
code --install-extension GitHub.copilot

# 安裝 Copilot Chat
code --install-extension GitHub.copilot-chat

# 安裝 Prettier
code --install-extension esbenp.prettier-vscode

# 安裝 ESLint
code --install-extension dbaeumer.vscode-eslint

# 安裝 Live Share
code --install-extension ms-vsliveshare.vsliveshare
```

---

### 步驟 6：配置 GitHub Copilot

```powershell
# 1. 在 VSCode 中按 Ctrl+Shift+P
# 2. 輸入 "GitHub Copilot: Sign In"
# 3. 按照提示登入你的 GitHub 賬號
# 4. 確認 Copilot 訂閱已啟用
```

**測試 Copilot：**
1. 在 VSCode 中打開任意 `.js` 檔案
2. 輸入註釋：`// function to calculate fibonacci`
3. 按 Enter，Copilot 應該會建議代碼
4. 按 `Tab` 接受建議

**測試 Copilot Chat：**
1. 按 `Ctrl+I` 打開 Copilot Chat
2. 輸入：`@workspace 解釋這個專案的結構`
3. AI 應該會回應專案說明

---

### 步驟 7：創建第一個討論空間（測試）

```powershell
# 創建測試討論空間
.\create-discussion-space.ps1 -ProjectName "test-project"

# 進入討論目錄
cd discussions\test-project

# 創建測試討論
.\new-discussion.ps1 -Category ideas -Title "first-test"

# 查看創建的文件
ls

# 返回專案根目錄
cd ..\..
```

---

### 步驟 8：運行測試

```powershell
# 運行所有測試
npm test

# 運行 ESLint 檢查
npm run lint

# 運行 Prettier 格式化檢查
npm run format:check

# 如果格式不正確，自動修復
npm run format
```

---

### 步驟 9：5 分鐘 AI 快速測試

```powershell
# 1. 在 VSCode 中按 Ctrl+I
# 2. 複制以下提示詞並貼上：
```

```
@workspace 我要測試 AI 協作功能

請分析這個專案的結構，並告訴我：
1. 主要文檔有哪些
2. 如何使用討論空間系統
3. 3 設備協作的基本流程

請以簡潔的方式回答
```

**預期結果：**
- AI 應該能識別專案中的文檔
- 能夠解釋討論空間的用途
- 能夠說明 3 設備協作模式

---

## 🎯 確定你的設備角色

根據團隊規劃，選擇本設備的角色：

### 🖥️ 設備 A - 架構和產品（推薦給團隊負責人）

**職責：**
- 📝 需求分析和討論創建
- 🏗️ 架構設計和 ADR
- 👀 代碼審查和批准
- 🔄 最終整合和部署

**日常操作：**
```powershell
# 早上：拉取更新
git pull origin main

# 創建新討論
cd discussions\your-project
.\new-discussion.ps1 -Category ideas -Title "new-feature"

# 使用 AI 分析需求
# 在 VSCode 中：Ctrl+I
# @workspace 分析 [功能名稱] 的需求...

# 審查其他設備的 PR
git fetch origin
git checkout feature/backend-api

# 使用 AI 審查代碼
# @workspace 審查當前分支的代碼...

# 晚上：提交討論記錄
git add discussions/
git commit -m "docs: add feature discussions"
git push origin main
```

詳細操作請參考：[設備操作詳細指南 - 設備 A 部分](DEVICE_SETUP_GUIDE.md#設備-a架構師)

---

### 💻 設備 B - 後端開發

**職責：**
- 🔧 API 開發和資料庫設計
- 🧪 後端單元測試
- 🔍 性能優化
- 📦 後端部署

**日常操作：**
```powershell
# 早上：拉取更新和討論
git pull origin main
cat discussions\your-project\ideas\*.md

# 創建開發分支
git checkout -b feature/user-api

# 使用 AI 生成後端代碼
# Ctrl+I
# @workspace 根據 discussions/... 實作後端 API
# 生成 models, routes, controllers, tests

# 運行測試
npm test

# 晚上：提交 PR
git add .
git commit -m "feat: implement user API"
git push origin feature/user-api
gh pr create --title "feat: User API Backend"
```

詳細操作請參考：[設備操作詳細指南 - 設備 B 部分](DEVICE_SETUP_GUIDE.md#設備-b後端開發者)

---

### 🖥️ 設備 C - 前端開發

**職責：**
- 🎨 UI 組件開發
- ⚛️ 前端邏輯實作
- 🧪 E2E 測試
- 📱 響應式設計

**日常操作：**
```powershell
# 早上：拉取更新和討論
git pull origin main
cat discussions\your-project\ideas\*.md

# 創建開發分支
git checkout -b feature/user-ui

# 使用 AI 生成前端代碼
# Ctrl+I
# @workspace 根據 discussions/... 實作前端 UI
# 生成 React 組件, 樣式, E2E 測試

# 本地開發測試
npm run dev

# 晚上：提交 PR
git add .
git commit -m "feat: implement user UI"
git push origin feature/user-ui
gh pr create --title "feat: User UI Frontend"
```

詳細操作請參考：[設備操作詳細指南 - 設備 C 部分](DEVICE_SETUP_GUIDE.md#設備-c前端開發者)

---

## ✅ 部署驗證檢查清單

完成以下檢查確認部署成功：

### Git 配置檢查
```powershell
# 應該顯示你的 GitHub 倉庫
git remote -v

# 應該顯示你的名字和郵箱
git config user.name
git config user.email

# 應該在 main 分支
git branch

# 應該顯示 "working tree clean"
git status
```

### 依賴檢查
```powershell
# 應該顯示版本號
node --version    # v18.0.0+
npm --version     # 9.0.0+

# 應該有 node_modules 目錄
Test-Path node_modules

# 應該通過測試
npm test
```

### VSCode 擴展檢查
```powershell
# 應該列出 Copilot 相關擴展
code --list-extensions | Select-String -Pattern "copilot"
```

### AI 功能檢查
```
✅ 在 VSCode 中按 Ctrl+I 能打開 Copilot Chat
✅ 輸入 @workspace 能看到工作區感知
✅ AI 能回答關於專案的問題
✅ AI 能生成代碼建議
```

### 討論空間檢查
```powershell
# 應該存在測試討論空間
Test-Path discussions\test-project

# 應該有 7 個類別目錄
(Get-ChildItem discussions\test-project -Directory).Count -ge 7

# 應該有助手腳本
Test-Path discussions\test-project\new-discussion.ps1
```

---

## 🎉 部署完成！下一步？

恭喜！如果所有檢查都通過，部署就成功了！

### 🚀 立即開始使用

**選擇你的起點：**

1. **🌟 5 分鐘快速體驗** → [AI_QUICK_START.md](AI_QUICK_START.md)
   - 立即測試 AI 協作功能
   - 生成第一個 AI 輔助的代碼

2. **📖 深度學習 AI 協作** → [AI_AGENT_COLLABORATION_GUIDE.md](AI_AGENT_COLLABORATION_GUIDE.md)
   - 學習完整的 AI 開發工作流程
   - 查看真實的 3 天開發案例

3. **📊 理解協作流程** → [WORKFLOW_DIAGRAM.md](WORKFLOW_DIAGRAM.md)
   - 查看視覺化流程圖
   - 理解 3 設備如何協作

4. **💬 創建第一個真實專案討論** → [DISCUSSION_GUIDE.md](DISCUSSION_GUIDE.md)
   - 為真實專案創建討論空間
   - 開始記錄需求和決策

### 👥 如果是多設備團隊

1. **邀請其他開發者加入**
   ```powershell
   # 在 GitHub 倉庫設置中添加協作者
   # Settings → Collaborators → Add people
   ```

2. **其他設備克隆倉庫**
   ```powershell
   # 在其他設備上執行
   git clone https://github.com/你的用戶名/multi-device-ai-collab.git
   cd multi-device-ai-collab
   npm install
   
   # 配置他們的 Git 信息
   git config user.name "開發者名字"
   git config user.email "開發者郵箱"
   ```

3. **分配角色** → 參考 [DEVICE_SETUP_GUIDE.md](DEVICE_SETUP_GUIDE.md)

### 📚 推薦閱讀路徑

**第 1 週：熟悉系統**
- Day 1: README + AI_QUICK_START
- Day 2: DEVICE_SETUP_GUIDE（你的角色部分）
- Day 3: AI_AGENT_COLLABORATION_GUIDE
- Day 4: DISCUSSION_GUIDE + DISCUSSION_EXAMPLES
- Day 5: 實際使用並優化工作流程

**第 2 週：實踐優化**
- 開始真實專案開發
- 使用 AI 生成代碼
- 記錄討論和決策
- 優化團隊協作流程

---

## 🔧 常見問題排查

### Git Push 失敗
```powershell
# 查看詳細錯誤
git push -u origin main -v

# 常見解決方法請參考上面的「步驟 3」
```

### NPM 安裝失敗
```powershell
# 清除緩存
npm cache clean --force

# 刪除 node_modules 重新安裝
Remove-Item -Recurse -Force node_modules
npm install
```

### Copilot 無法使用
```
1. 確認 GitHub Copilot 訂閱已啟用
   https://github.com/settings/copilot
   
2. 在 VSCode 中重新登入
   Ctrl+Shift+P → "GitHub Copilot: Sign In"
   
3. 重新載入 VSCode
   Ctrl+Shift+P → "Reload Window"
```

### PowerShell 腳本執行受限
```powershell
# 臨時允許腳本執行
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process

# 然後運行腳本
.\create-discussion-space.ps1 -ProjectName "test"
```

---

## 📞 需要更多幫助？

- 📖 查看 [文檔導航索引](DOCS_INDEX.md) 找到相關文檔
- 📁 查看 [檔案結構說明](FILE_STRUCTURE.md) 了解專案組織
- 🔨 查看 [設置修復指南](SETUP_FIX.md) 解決安裝問題
- 🤖 使用 `@workspace` 在 VSCode 中詢問 Copilot

---

## 📝 部署記錄

**部署時間：** 2026年3月2日  
**部署位置：** d:\TEJ  
**設備角色：** _____________（填寫你選擇的角色）  
**GitHub 倉庫：** _____________（填寫你的倉庫 URL）  
**團隊成員：** _____________（如果是團隊，列出成員）

---

**祝你使用愉快！🎉 開始體驗 AI 驅動的協作開發吧！**

[返回 README](README.md) | [查看快速開始](AI_QUICK_START.md)
