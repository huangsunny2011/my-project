# 團隊協作工作流程

## 🔄 標準開發流程

### 1. 每日工作流程

#### 早上開始工作（所有設備）

```bash
# 1. 切換到主分支
git checkout main

# 2. 拉取最新代碼
git pull origin main

# 3. 查看今日任務
# 訪問 GitHub Projects 或 Issues 頁面

# 4. 創建功能分支
git checkout -b feature/your-feature-name

# 5. 在 VSCode Chat 中規劃工作
# "@workspace 我今天要實作 [功能名稱]，請分析當前代碼庫並建議實作方式"
```

#### 開發過程中

```bash
# 定期提交進度
git add .
git commit -m "wip: [簡短描述當前進度]"

# 定期推送到遠端（作為備份）
git push origin feature/your-feature-name

# 使用 Copilot 進行開發
# "@workspace 請實作 [具體功能]"
# "@workspace 請審查我剛寫的代碼"
# "@workspace 請為這個函數生成測試"
```

#### 完成功能後

```bash
# 1. 確保所有測試通過
npm test

# 2. 格式化代碼
npm run format

# 3. 提交最終版本
git add .
git commit -m "feat: [功能描述]"

# 4. 推送到遠端
git push origin feature/your-feature-name

# 5. 創建 Pull Request
# 在 GitHub 網站上創建 PR
# 使用模板填寫 PR 描述
```

### 2. Pull Request 流程

#### 創建 PR（開發者）

**PR 標題格式：**

```
[類型] 簡短描述 (#Issue編號)

範例：
feat: 新增用戶認證功能 (#123)
fix: 修復登入錯誤 (#124)
docs: 更新 API 文檔 (#125)
```

**PR 描述模板：**

```markdown
## 📝 變更描述

簡要說明這個 PR 的目的和內容

## 🎯 相關 Issue

Closes #123

## 🔄 變更類型

- [ ] 新功能
- [ ] Bug 修復
- [ ] 文檔更新
- [ ] 重構
- [ ] 測試

## ✅ 測試

說明如何測試這些變更

## 📸 截圖（如適用）

添加截圖或 GIF

## 📋 檢查清單

- [ ] 代碼已通過本地測試
- [ ] 已添加必要的測試
- [ ] 文檔已更新
- [ ] 代碼風格符合規範
```

#### 審查 PR（審查者）

```bash
# 1. 拉取 PR 分支
git fetch origin
git checkout feature/branch-name

# 2. 運行代碼
npm install
npm start

# 3. 運行測試
npm test

# 4. 使用 Copilot 進行代碼審查
# 在 VSCode Chat 中：
# "@workspace 請審查這個分支的代碼品質，重點關注：
#  1. 代碼可讀性
#  2. 安全性問題
#  3. 性能問題
#  4. 最佳實踐
#  5. 測試覆蓋率"

# 5. 在 GitHub 上提交審查意見
# - Approve: 批准合併
# - Request Changes: 請求修改
# - Comment: 僅留下評論
```

### 3. 分支策略

```
main (生產環境)
  ↓
develop (開發環境)
  ↓
feature/* (功能開發)
hotfix/* (緊急修復)
release/* (版本發布)
```

#### 分支命名規範

```bash
# 功能開發
feature/user-authentication
feature/payment-integration
feature/admin-dashboard

# Bug 修復
fix/login-error
fix/memory-leak
fix/timezone-issue

# 測試
test/unit-tests
test/integration-tests
test/e2e-tests

# 文檔
docs/api-documentation
docs/readme-update
docs/deployment-guide

# 重構
refactor/database-layer
refactor/api-endpoints
refactor/component-structure

# 緊急修復
hotfix/security-patch
hotfix/critical-bug
```

### 4. Commit Message 規範

使用 Conventional Commits 格式：

```
<type>(<scope>): <subject>

<body>

<footer>
```

#### 類型（type）

- `feat`: 新功能
- `fix`: Bug 修復
- `docs`: 文檔變更
- `style`: 代碼格式（不影響功能）
- `refactor`: 重構（不是新增功能或修復 bug）
- `perf`: 性能優化
- `test`: 添加測試
- `chore`: 構建過程或輔助工具變更
- `ci`: CI 配置變更
- `build`: 構建系統或外部依賴變更
- `revert`: 回退之前的 commit

#### 範例

```bash
# 新功能
git commit -m "feat(auth): add JWT authentication"

# Bug 修復
git commit -m "fix(api): resolve CORS issue"

# 文檔
git commit -m "docs(readme): add installation instructions"

# 重構
git commit -m "refactor(database): optimize query performance"

# 測試
git commit -m "test(user): add unit tests for user service"

# 多行提交訊息
git commit -m "feat(payment): integrate Stripe payment gateway

- Add Stripe SDK
- Implement payment processing
- Add webhook handlers
- Update database schema

Closes #456"
```

## 🤖 AI Agent 協作策略

### 策略 1：角色分工

#### 設備 A - 後端開發者

```
專注使用 Copilot 進行：
- API 端點開發
- 資料庫設計
- 業務邏輯實作
- 安全性實作

Copilot 提示詞範例：
"@workspace 實作用戶註冊 API 端點，包含郵件驗證和密碼加密"
"@workspace 設計資料庫架構支援多租戶系統"
```

#### 設備 B - 前端開發者

```
專注使用 Copilot 進行：
- UI 組件開發
- 狀態管理
- API 集成
- 響應式設計

Copilot 提示詞範例：
"@workspace 創建登入表單組件，包含驗證和錯誤處理"
"@workspace 實作 Redux store 用於用戶狀態管理"
```

#### 設備 C - QA 工程師

```
專注使用 Copilot 進行：
- 測試案例生成
- 自動化測試腳本
- 代碼審查
- 文檔撰寫

Copilot 提示詞範例：
"@workspace 為用戶認證流程生成完整的測試套件"
"@workspace 審查這個 PR 的代碼品質和安全性"
```

### 策略 2：輪流審查

```
週一：A 開發 → B 審查 → C 測試
週二：B 開發 → C 審查 → A 測試
週三：C 開發 → A 審查 → B 測試
週四：A 開發 → B 審查 → C 測試
週五：集體代碼審查和重構
```

### 策略 3：結對編程（使用 Live Share）

```
配對 1: A + B （後端 + 前端）
配對 2: B + C （前端 + 測試）
配對 3: C + A （測試 + 後端）

每對輪流使用 Copilot：
- 一人編寫代碼並使用 Copilot 生成
- 另一人審查並提供建議
- 每 30 分鐘交換角色
```

## 📅 每週協作時間表

### 週一：規劃和設計

```
09:00 - 團隊會議（所有設備在線）
- 討論本週目標
- 分配任務
- 技術討論

10:00 - 架構設計
- 設備 A: 設計後端架構
- 設備 B: 設計前端架構
- 設備 C: 規劃測試策略

使用 Copilot：
"@workspace 基於需求文檔，建議系統架構設計"
```

### 週二至週四：開發和協作

```
每日站會（15分鐘）
- 昨天完成了什麼
- 今天計劃做什麼
- 遇到什麼阻礙

開發時段：
- 使用 Copilot 加速開發
- 定期推送代碼
- 創建和審查 PR

傍晚：代碼審查時段
- 審查當日的 PR
- 提供反饋
- 合併通過的 PR
```

### 週五：整合和回顧

```
09:00 - 代碼整合
- 合併所有通過的 PR
- 解決衝突
- 整合測試

14:00 - 週回顧會議
- 回顧本週成果
- 討論遇到的問題
- 計劃下週工作

使用 Copilot：
"@workspace 分析本週的代碼變更，總結主要功能和改進"
```

## 🎯 Copilot 協作最佳實踐

### 1. 建立統一的提示詞庫

創建 `copilot-prompts.md` 文件，記錄常用的提示詞：

```markdown
# 常用提示詞

## 代碼生成

- "@workspace 實作 [功能] 使用 [技術棧]"
- "@workspace 創建 [組件類型] 包含 [具體需求]"

## 代碼審查

- "@workspace 審查這段代碼的安全性"
- "@workspace 檢查這個文件是否符合最佳實踐"

## 測試生成

- "@workspace 為這個函數生成完整的測試套件"
- "@workspace 創建 E2E 測試用於 [功能流程]"

## 重構

- "@workspace 建議如何重構這段代碼以提高性能"
- "@workspace 將這個文件拆分為更小的模組"

## 文檔生成

- "@workspace 為這個 API 生成 OpenAPI 文檔"
- "@workspace 為這個組件生成使用文檔"
```

### 2. 代碼審查檢查清單

使用 Copilot 進行多層次審查：

```
第一層：語法和格式
"@workspace 檢查代碼格式和語法錯誤"

第二層：邏輯和最佳實踐
"@workspace 審查業務邏輯和編碼最佳實踐"

第三層：安全性
"@workspace 檢查安全漏洞和潛在風險"

第四層：性能
"@workspace 分析性能並提供優化建議"

第五層：可維護性
"@workspace 評估代碼可讀性和可維護性"
```

### 3. 協作衝突解決

當遇到合併衝突時：

```bash
# 1. 拉取最新的主分支
git checkout main
git pull origin main

# 2. 回到功能分支
git checkout feature/your-feature

# 3. 合併主分支
git merge main

# 4. 使用 Copilot 協助解決衝突
# 在 VSCode 中打開衝突文件
# 在 Chat 中：
# "@workspace 這個文件有合併衝突，請分析兩個版本並建議最佳的合併方式"

# 5. 解決衝突後繼續合併
git add .
git commit -m "merge: resolve conflicts with main"
git push origin feature/your-feature
```

## 🔧 自動化工具

### 設置 Git Hooks

創建 `.husky` 配置進行自動化檢查：

```bash
# 安裝 husky
npm install --save-dev husky

# 初始化
npx husky install

# 添加 pre-commit hook
npx husky add .husky/pre-commit "npm test"

# 添加 commit-msg hook
npx husky add .husky/commit-msg 'npx --no -- commitlint --edit "$1"'
```

### CI/CD 集成

使用 GitHub Actions 自動化流程：

```yaml
# .github/workflows/ci.yml
name: CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: "18"
      - run: npm install
      - run: npm test
      - run: npm run lint

  ai-review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: AI Code Review
        uses: github/super-linter@v4
```

## 📚 資源和模板

### 有用的 GitHub 模板

#### Issue 模板

創建 `.github/ISSUE_TEMPLATE/feature_request.md`

#### PR 模板

創建 `.github/pull_request_template.md`

### 文檔模板

- `ARCHITECTURE.md` - 系統架構文檔
- `API.md` - API 文檔
- `DEPLOYMENT.md` - 部署指南
- `CONTRIBUTING.md` - 貢獻指南

---

**記住：**

- 頻繁溝通
- 定期同步代碼
- 善用 Copilot 提高效率
- 保持代碼品質
- 互相學習和成長

🚀 祝您的團隊協作順利！
