# 3 設備協作開發詳細操作指南

本指南詳細說明設備 A、B、C 在整個協作開發流程中的具體操作步驟。

## 📋 目錄

- [設備角色分配](#設備角色分配)
- [首次設置（一次性）](#首次設置一次性)
- [日常協作工作流程](#日常協作工作流程)
- [討論空間使用](#討論空間使用)
- [實戰演練場景](#實戰演練場景)

---

## 🎯 設備角色分配

### 建議的角色分配

| 設備 | GitHub 賬號 | 主要角色 | 專長領域 |
|------|------------|---------|---------|
| 設備 A | developer1@example.com | 項目負責人/架構師 | 系統架構、代碼審查 |
| 設備 B | developer2@example.com | 核心開發者 | 後端開發、API 設計 |
| 設備 C | developer3@example.com | 開發者/測試 | 前端開發、測試 |

> **注意：** 角色可以靈活調整，這只是建議分配。所有設備都可以執行所有任務。

---

## 🔧 首次設置（一次性）

### 設備 A：項目創建與初始化

#### 步驟 1：環境檢查與設置

```powershell
# 在設備 A 的 PowerShell 中執行

# 1. 檢查 Git 是否已安裝
git --version
# 應顯示：git version 2.x.x

# 2. 檢查 Node.js 是否已安裝
node --version
npm --version
# 應顯示：v18.x.x 或更高

# 3. 檢查 VSCode 是否已安裝
code --version

# 4. 運行自動化設置腳本
cd d:\TEJ
.\setup.ps1
```

設置腳本會提示輸入：
```
請輸入你的 Git 用戶名: Developer A
請輸入你的 Git 郵箱: developer1@example.com
```

#### 步驟 2：在 VSCode 中配置 GitHub Copilot

```powershell
# 啟動 VSCode
cd d:\TEJ
code .
```

在 VSCode 中：
1. 按 `Ctrl+Shift+P` 打開命令面板
2. 輸入 `GitHub Copilot: Sign In`
3. 使用 developer1@example.com 登入
4. 授權 VSCode 訪問

#### 步驟 3：創建 GitHub 儲存庫

在 GitHub 網站上：
```
1. 登入 developer1@example.com 賬號
2. 點擊 "New repository"
3. 填寫：
   - Repository name: team-project
   - Description: 3-device collaborative project
   - Public or Private: Private
   - ✅ Add a README file
4. 點擊 "Create repository"
```

#### 步驟 4：添加協作者

在 GitHub 儲存庫設置中：
```
1. 進入儲存庫頁面
2. 點擊 Settings → Collaborators
3. 點擊 "Add people"
4. 添加：
   - developer2@example.com (設備 B)
   - developer3@example.com (設備 C)
5. 發送邀請
```

#### 步驟 5：推送初始代碼

```powershell
# 在 d:\TEJ 目錄中
cd d:\TEJ

# 連接遠程倉庫
git remote add origin https://github.com/developer1/team-project.git

# 推送代碼（如果是新建立的倉庫）
git branch -M main
git push -u origin main

# 或者克隆已存在的倉庫
git clone https://github.com/developer1/team-project.git
cd team-project
```

#### 步驟 6：創建討論空間

```powershell
# 為第一個項目創建討論空間
.\create-discussion-space.ps1 -ProjectName "team-project"

# 驗證創建結果
ls discussions\team-project
```

應該看到：
```
general/
ideas/
technical/
architecture/
troubleshooting/
decisions/
meetings/
README.md
new-discussion.ps1
search-discussion.ps1
stats.ps1
```

#### 步驟 7：提交討論空間結構

```powershell
# 添加討論空間到版本控制
git add discussions/
git commit -m "chore: initialize discussion space structure"
git push origin main
```

---

### 設備 B：克隆與配置

#### 步驟 1：接受邀請

```
1. 檢查 developer2@example.com 的郵箱
2. 找到來自 GitHub 的協作邀請郵件
3. 點擊 "Accept invitation"
4. 確認可以訪問儲存庫
```

#### 步驟 2：克隆項目

```powershell
# 在設備 B 的 PowerShell 中執行

# 1. 創建工作目錄
mkdir D:\Projects
cd D:\Projects

# 2. 克隆儲存庫
git clone https://github.com/developer1/team-project.git
cd team-project

# 3. 驗證遠程連接
git remote -v
```

應該看到：
```
origin  https://github.com/developer1/team-project.git (fetch)
origin  https://github.com/developer1/team-project.git (push)
```

#### 步驟 3：配置 Git 身份

```powershell
# 設置 Git 用戶信息（針對這個項目）
git config user.name "Developer B"
git config user.email "developer2@example.com"

# 驗證配置
git config --list | Select-String "user"
```

#### 步驟 4：安裝依賴並運行設置

```powershell
# 安裝 Node.js 依賴
npm install

# 運行設置腳本
.\setup.ps1
```

#### 步驟 5：配置 VSCode 和 Copilot

```powershell
# 在項目目錄中打開 VSCode
code .
```

在 VSCode 中：
1. 按 `Ctrl+Shift+P`
2. 輸入 `GitHub Copilot: Sign In`
3. 使用 developer2@example.com 登入

#### 步驟 6：驗證環境

```powershell
# 運行測試確保環境正常
npm test

# 啟動開發伺服器（如果有）
npm run dev
```

---

### 設備 C：克隆與配置

#### 步驟 1-6：與設備 B 相同

重複設備 B 的步驟 1-6，但使用：
- Git 用戶名：`Developer C`
- Git 郵箱：`developer3@example.com`
- GitHub 登入：`developer3@example.com`

```powershell
# 設備 C 的快速設置
cd D:\Projects
git clone https://github.com/developer1/team-project.git
cd team-project

git config user.name "Developer C"
git config user.email "developer3@example.com"

npm install
.\setup.ps1

code .
# 在 VSCode 中用 developer3@example.com 登入 Copilot
```

---

## 🔄 日常協作工作流程

### 場景 1：設備 A 創建新功能需求

#### 設備 A 的操作

```powershell
# 1. 創建功能討論
cd discussions\team-project
.\new-discussion.ps1 -Category ideas -Title "用戶註冊功能"
```

這會創建：`discussions/team-project/ideas/2026-03-02-user-registration-feature.md`

編輯討論文件：
```markdown
# 用戶註冊功能

**日期:** 2026-03-02
**作者:** Developer A
**分類:** ideas

---

## 需求描述

實作用戶註冊功能，包含：
- 郵箱註冊
- 密碼驗證（最少 8 字符）
- 郵箱驗證
- 用戶資料儲存

## 技術需求

- RESTful API 端點：POST /api/auth/register
- 資料庫：使用 PostgreSQL
- 密碼加密：bcrypt
- 郵件服務：SendGrid

## 分工建議

- @Developer-B：實作後端 API
- @Developer-C：實作前端註冊表單

## 時程

預計 3 天完成
```

```powershell
# 2. 提交討論
git add discussions/
git commit -m "docs: add user registration feature discussion"
git push origin main

# 3. 在 GitHub 上創建 Issue
# 手動在 GitHub 網站上創建，或使用 GitHub CLI：
gh issue create --title "Feature: User Registration" --body "See discussions/team-project/ideas/2026-03-02-user-registration-feature.md"
```

---

### 場景 2：設備 B 實作後端功能

#### 設備 B 的操作

```powershell
# 1. 更新本地代碼
git checkout main
git pull origin main

# 2. 閱讀討論
cat discussions\team-project\ideas\2026-03-02-user-registration-feature.md

# 3. 在 VSCode 中使用 Copilot 規劃
code .
```

在 VSCode Chat 中：
```
@workspace 閱讀 discussions/team-project/ideas/2026-03-02-user-registration-feature.md
根據需求實作用戶註冊 API

需要：
1. Express 路由
2. PostgreSQL 資料庫操作
3. bcrypt 密碼加密
4. 輸入驗證
5. 錯誤處理
```

```powershell
# 4. 創建功能分支
git checkout -b feature/user-registration-api

# 5. 創建技術討論（如有需要）
cd discussions\team-project
.\new-discussion.ps1 -Category technical -Title "用戶註冊API實作細節"
```

編輯技術討論：
```markdown
# 用戶註冊API實作細節

**日期:** 2026-03-02
**作者:** Developer B
**分類:** technical

---

## 實作方案

### 1. 資料庫 Schema

\```sql
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  is_verified BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT NOW()
);
\```

### 2. API 端點

POST /api/auth/register

請求：
\```json
{
  "email": "user@example.com",
  "password": "securePassword123"
}
\```

響應：
\```json
{
  "success": true,
  "userId": "uuid",
  "message": "Registration successful"
}
\```

## 🤖 Copilot 協助

使用 Copilot 生成的代碼片段已儲存在分支中。
```

```powershell
# 6. 使用 Copilot 生成代碼
# 在 VSCode 中創建文件: src/routes/auth.js
# 讓 Copilot 根據討論生成代碼

# 7. 運行測試
npm test

# 8. 提交代碼
git add .
git commit -m "feat: implement user registration API

- Add POST /api/auth/register endpoint
- Add user schema and migration
- Add password hashing with bcrypt
- Add input validation
- Add unit tests

Related: #123"

git push origin feature/user-registration-api
```

#### 設備 B 創建 Pull Request

在 GitHub 網站上：
```
1. 進入儲存庫
2. 看到 "Compare & pull request" 按鈕，點擊
3. 填寫 PR 表單：
   - Title: feat: User Registration API
   - Description:
     實作用戶註冊後端 API

     Changes:
     - ✅ POST /api/auth/register 端點
     - ✅ 用戶資料庫 schema
     - ✅ 密碼加密 (bcrypt)
     - ✅ 輸入驗證
     - ✅ 單元測試

     參考討論：
     - discussions/team-project/ideas/2026-03-02-user-registration-feature.md
     - discussions/team-project/technical/2026-03-02-user-registration-api-implementation.md

     @Developer-A 請審查
     @Developer-C 可以開始前端開發

4. 點擊 "Create pull request"
```

---

### 場景 3：設備 A 審查代碼

#### 設備 A 的操作

```powershell
# 1. 收到 PR 通知後，獲取分支
git fetch origin
git checkout feature/user-registration-api

# 2. 在 VSCode 中審查
code .
```

在 VSCode Chat 中使用 Copilot：
```
@workspace 審查 feature/user-registration-api 分支的代碼

請檢查：
1. 代碼品質和可讀性
2. 安全性（密碼處理、SQL 注入防護）
3. 錯誤處理是否完整
4. 測試覆蓋率
5. 是否符合 discussions 中的需求
```

Copilot 會提供審查報告。

```powershell
# 3. 運行測試
npm test

# 4. 在 GitHub PR 頁面添加評論
```

在 GitHub 網站上：
```
審查意見：

✅ 整體實作符合需求
✅ 測試覆蓋率良好
✅ 安全處理得當

💡 建議：
1. 添加郵箱格式驗證正則表達式
2. 錯誤訊息可以更具體
3. 建議添加 rate limiting

請修改後我會批准合併。
```

#### 設備 B 根據反饋修改

```powershell
# 設備 B 執行

# 1. 查看審查意見
# 在 GitHub PR 頁面查看

# 2. 在 VSCode 中使用 Copilot 修改
```

在 VSCode Chat：
```
@workspace 根據審查意見修改代碼：

1. 添加郵箱格式驗證
2. 改進錯誤訊息
3. 實作 rate limiting
```

```powershell
# 3. 提交修改
git add .
git commit -m "fix: address code review feedback

- Add email format validation with regex
- Improve error messages
- Add rate limiting middleware"

git push origin feature/user-registration-api
```

#### 設備 A 批准並合併

```powershell
# 1. 再次審查
git pull origin feature/user-registration-api

# 2. 在 GitHub 上批准
# 點擊 "Approve" 並 "Merge pull request"

# 3. 更新本地 main 分支
git checkout main
git pull origin main

# 4. 創建決策記錄
cd discussions\team-project
.\new-discussion.ps1 -Category decisions -Title "用戶註冊API技術方案已採納"
```

---

### 場景 4：設備 C 實作前端

#### 設備 C 的操作

```powershell
# 1. 確保後端 API 已合併
git checkout main
git pull origin main

# 2. 創建前端分支
git checkout -b feature/user-registration-ui

# 3. 在 VSCode 中開發
code .
```

在 VSCode Chat：
```
@workspace 根據後端 API (src/routes/auth.js)
實作用戶註冊前端表單

要求：
1. React 組件
2. 表單驗證
3. 錯誤提示
4. 載入狀態
5. 成功後導向登入頁
```

```powershell
# 4. 開發過程中使用 Copilot
# 讓 Copilot 生成：
# - 註冊表單組件
# - 表單驗證邏輯
# - API 調用
# - 錯誤處理

# 5. 測試
npm run dev
# 在瀏覽器中測試註冊流程

# 6. 提交
git add .
git commit -m "feat: implement user registration UI

- Add registration form component
- Add client-side validation
- Add error handling and display
- Add loading states
- Add success redirection

Related: #123"

git push origin feature/user-registration-ui

# 7. 創建 PR
gh pr create --title "feat: User Registration UI" --body "前端註冊表單實作，配合後端 API"
```

---

### 場景 5：三設備同步討論

#### 使用 GitHub Discussions

所有設備可以同時參與：

```
設備 A (09:30):
發現註冊流程需要添加郵箱驗證功能。
@Developer-B 後端可以實作嗎？

設備 B (09:45):
可以，我會添加：
1. 生成驗證 token
2. 發送驗證郵件
3. 驗證端點

預計今天完成。

設備 C (10:00):
前端需要添加：
1. "驗證郵箱" 提示頁面
2. 驗證成功頁面

我會配合後端進度。

設備 A (10:15):
好的，我會更新需求文檔。
創建新的技術討論來追蹤這個功能。
```

---

## 💬 討論空間使用

### 設備 A：管理討論空間

```powershell
# 為新專案創建討論空間
.\create-discussion-space.ps1 -ProjectName "payment-service"

# 查看所有討論統計
cd discussions\team-project
.\stats.ps1

# 搜尋特定主題
.\search-discussion.ps1 -Keyword "API"
.\search-discussion.ps1 -Keyword "PostgreSQL" -Category architecture
```

### 設備 B：創建技術討論

```powershell
# 在開發過程中遇到技術問題
cd discussions\team-project
.\new-discussion.ps1 -Category troubleshooting -Title "PostgreSQL連接池配置問題"

# 編輯討論文件，記錄問題和解決方案
code troubleshooting\2026-03-02-postgresql-connection-pool.md
```

### 設備 C：記錄會議

```powershell
# 每周例會後記錄
cd discussions\team-project
.\new-discussion.ps1 -Category meetings -Title "Sprint-5-Planning"

# 填寫會議內容
code meetings\2026-03-02-sprint-5-planning.md
```

### 所有設備：使用 Copilot 查詢討論

在 VSCode Chat 中：
```
# 查詢特定討論
@workspace 總結 discussions/team-project/architecture/ 中所有的架構決策

# 基於討論開發
@workspace 根據 discussions/team-project/decisions/2026-03-01-database-selection.md
中的決議，生成 PostgreSQL 連接設定代碼

# 審查討論內容
@workspace 檢查 discussions/team-project/technical/ 中的技術方案
是否有互相衝突的地方
```

---

## 🎬 實戰演練場景

### 完整流程：從想法到部署

#### Day 1 - 需求討論（設備 A 主導）

**設備 A - 上午 09:00**
```powershell
# 1. 創建功能提案討論
cd discussions\team-project
.\new-discussion.ps1 -Category ideas -Title "添加支付功能"

# 2. 編輯討論，詳細描述需求
code ideas\2026-03-02-payment-feature.md

# 3. 提交並通知團隊
git add discussions/
git commit -m "docs: propose payment feature"
git push origin main

# 4. 在 Discord/Slack 通知
# "@all 請查看新的功能提案討論"
```

**設備 B - 上午 10:30**
```powershell
# 1. 更新並查看提案
git pull origin main
cat discussions\team-project\ideas\2026-03-02-payment-feature.md

# 2. 在討論文件中添加技術意見
code discussions\team-project\ideas\2026-03-02-payment-feature.md

# 添加評論：
## 技術可行性評估 (Developer B)

後端可以使用 Stripe API 整合：
- 支付處理
- Webhook 處理
- 退款功能

預估工時：5 天

# 3. 提交意見
git add discussions/
git commit -m "docs: add technical assessment for payment feature"
git push origin main
```

**設備 C - 下午 14:00**
```powershell
# 1. 更新並查看
git pull origin main
cat discussions\team-project\ideas\2026-03-02-payment-feature.md

# 2. 添加前端意見
## UI/UX 考量 (Developer C)

需要設計：
- 支付表單
- 支付進度指示
- 成功/失敗頁面
- 支付歷史列表

預估工時：4 天

# 3. 提交
git add discussions/
git commit -m "docs: add UI/UX considerations for payment feature"
git push origin main
```

**設備 A - 下午 16:00**
```powershell
# 1. 審查所有意見
git pull origin main
cat discussions\team-project\ideas\2026-03-02-payment-feature.md

# 2. 創建架構決策記錄
.\new-discussion.ps1 -Category architecture -Title "ADR-支付系統架構"

# 3. 創建 GitHub Issue 和 Milestone
gh issue create --title "Feature: Payment System" \
  --body "See discussions for details" \
  --milestone "v2.0"
```

---

#### Day 2 - 架構設計（所有設備協作）

**設備 A - 上午 09:30**
```powershell
# 召開線上會議（使用 VSCode Live Share）

# 1. 啟動 Live Share
# 在 VSCode 中：Ctrl+Shift+P → "Live Share: Start Collaboration Session"

# 2. 分享連結給設備 B 和 C

# 3. 共同編輯架構文檔
code discussions\team-project\architecture\ADR-002-payment-system.md
```

**設備 B 和 C - 上午 09:30**
```powershell
# 加入 Live Share 會話
# 在 VSCode 中：Ctrl+Shift+P → "Live Share: Join Collaboration Session"
# 輸入設備 A 分享的連結

# 共同編輯，實時討論
```

所有設備同時使用 Copilot：
```
@workspace 設計支付系統架構

要求：
1. 使用 Stripe API
2. 安全的支付流程
3. Webhook 處理
4. 錯誤處理和重試機制
5. 交易記錄和審計

請提供：
- 系統架構圖（Mermaid）
- 資料庫 Schema
- API 端點設計
- 安全考量
```

**會議結束後 - 設備 A**
```powershell
# 整理會議記錄
.\new-discussion.ps1 -Category meetings -Title "支付系統架構設計會議"

# 提交架構文檔
git add discussions/
git commit -m "docs: finalize payment system architecture"
git push origin main
```

---

#### Day 3-5 - 並行開發

**設備 A（監督和審查）**
```powershell
# 每天早上檢查進度
git pull origin main
git fetch --all

# 查看所有分支
git branch -a

# 審查 PR
gh pr list
gh pr view 15

# 使用 Copilot 審查代碼
code .
# 在 Chat: @workspace 審查 PR #15 的代碼品質
```

**設備 B（後端開發）**
```powershell
# Day 3
git checkout -b feature/payment-backend

# 使用 Copilot 開發
# 1. Stripe 整合
# 2. 支付端點
# 3. Webhook 處理
# 4. 資料庫操作

# 每天提交進度
git add .
git commit -m "feat: add stripe integration (Day 3 progress)"
git push origin feature/payment-backend

# Day 5 - 完成並創建 PR
git push origin feature/payment-backend
gh pr create --title "feat: Payment Backend" --assignee "@Developer-A"
```

**設備 C（前端開發）**
```powershell
# Day 3
git checkout -b feature/payment-ui

# 使用 Copilot 開發
# 1. 支付表單
# 2. Stripe Elements 整合
# 3. 支付流程 UI
# 4. 錯誤處理

# 每天提交進度
git add .
git commit -m "feat: add payment form (Day 3 progress)"
git push origin feature/payment-ui

# Day 5 - 完成並創建 PR
git push origin feature/payment-ui
gh pr create --title "feat: Payment UI" --assignee "@Developer-A"
```

---

#### Day 6 - 審查和合併

**設備 A**
```powershell
# 審查後端 PR
git fetch origin
git checkout feature/payment-backend
npm test

# 使用 Copilot 深度審查
# Chat: @workspace 全面審查支付後端代碼的安全性

# 在 GitHub 上批准並合併
gh pr review 15 --approve
gh pr merge 15 --squash

# 審查前端 PR
git checkout feature/payment-ui
npm test
npm run dev

# 批准並合併
gh pr review 16 --approve
gh pr merge 16 --squash
```

---

#### Day 7 - 整合測試

**所有設備協同測試**

**設備 A**
```powershell
# 更新到最新代碼
git checkout main
git pull origin main

# 啟動完整環境
docker-compose up -d
npm run dev

# 創建測試討論
.\new-discussion.ps1 -Category troubleshooting -Title "支付功能整合測試"
```

**設備 B**
```powershell
# 進行後端測試
npm run test:integration

# 使用 Postman/Insomnia 測試 API
# 記錄測試結果到討論文件
```

**設備 C**
```powershell
# 進行前端測試
npm run test:e2e

# 手動測試用戶流程
# 記錄問題到討論文件
```

**發現問題時**
```powershell
# 任何設備發現問題
.\new-discussion.ps1 -Category troubleshooting -Title "支付失敗處理問題"

# 在討論中：
1. 描述問題
2. 貼上錯誤日誌
3. 使用 Copilot 分析
4. 提出解決方案
5. 分配修復責任
```

---

## ⚡ 快速命令參考

### 設備 A（項目負責人）

```powershell
# 日常開始
git pull origin main
git fetch --all
gh pr list

# 創建討論空間
.\create-discussion-space.ps1 -ProjectName "new-feature"

# 審查 PR
gh pr view 10
git checkout pr-branch
code .

# 合併 PR
gh pr review 10 --approve
gh pr merge 10 --squash
```

### 設備 B（後端開發）

```powershell
# 日常開始
git checkout main
git pull origin main

# 開始新功能
git checkout -b feature/api-endpoint

# 開發過程
# ... 使用 Copilot 寫代碼 ...

# 提交進度
git add .
git commit -m "feat: progress on API endpoint"
git push origin feature/api-endpoint

# 完成後創建 PR
gh pr create --title "feat: New API Endpoint"
```

### 設備 C（前端開發）

```powershell
# 日常開始
git checkout main
git pull origin main

# 開始新功能
git checkout -b feature/ui-component

# 開發過程
npm run dev
# ... 使用 Copilot 寫代碼 ...

# 提交進度
git add .
git commit -m "feat: progress on UI component"
git push origin feature/ui-component

# 完成後創建 PR
gh pr create --title "feat: New UI Component"
```

---

## 🎯 每日工作流程檢查清單

### 每天開始時（所有設備）

- [ ] 拉取最新代碼：`git pull origin main`
- [ ] 檢查 PR 和 Issue：`gh pr list`, `gh issue list`
- [ ] 閱讀討論更新：查看 `discussions/` 目錄
- [ ] 檢查團隊通訊（Discord/Slack）

### 開發過程中（所有設備）

- [ ] 使用 Copilot 輔助開發
- [ ] 定期提交代碼（至少每 2 小時）
- [ ] 記錄重要決策到討論空間
- [ ] 遇到問題創建 troubleshooting 討論

### 每天結束時（所有設備）

- [ ] 提交當天所有工作：`git push`
- [ ] 更新相關討論文件
- [ ] 在團隊頻道同步進度
- [ ] 標記任何阻塞問題

---

## 🆘 常見問題處理

### 問題：設備間代碼衝突

**情境：** 設備 B 和 C 同時修改了同一個文件

**設備 B（先推送）：**
```powershell
git add .
git commit -m "feat: update feature"
git push origin feature-branch
# ✅ 成功
```

**設備 C（後推送）：**
```powershell
git push origin feature-branch
# ❌ 錯誤：需要先拉取
```

**解決方案（設備 C）：**
```powershell
# 1. 拉取最新更改
git pull origin feature-branch

# 2. 如果有衝突，解決衝突
code .  # 在 VSCode 中解決衝突

# 3. 使用 Copilot 協助
# Chat: @workspace 幫我分析這些合併衝突，建議如何解決

# 4. 完成合併
git add .
git commit -m "merge: resolve conflicts with Developer B's changes"
git push origin feature-branch
```

### 問題：忘記切換分支

**情境：** 設備 B 忘記創建分支，直接在 main 上開發了

```powershell
# ❌ 錯誤操作
git checkout main
# ... 開發了一些代碼 ...
git add .

# 😱 發現在 main 分支上！
```

**解決方案：**
```powershell
# 1. 不要 commit！先創建新分支
git checkout -b feature/correct-branch

# 2. 現在你的更改在新分支上了
git status  # 確認

# 3. 提交
git commit -m "feat: add feature (recovered from main)"
git push origin feature/correct-branch

# 4. 確保 main 分支乾淨
git checkout main
git status  # 應該顯示 "nothing to commit"
```

---

## 📚 相關文檔

- **[README.md](README.md)** - 主要文檔
- **[QUICKSTART.md](QUICKSTART.md)** - 15 分鐘快速開始
- **[WORKFLOW.md](WORKFLOW.md)** - 詳細工作流程
- **[DISCUSSION_GUIDE.md](DISCUSSION_GUIDE.md)** - 討論空間完整指南
- **[COPILOT_PROMPTS.md](COPILOT_PROMPTS.md)** - Copilot 提示詞庫

---

**最後更新：** 2026年3月2日
**維護者：** Developer A, Developer B, Developer C
