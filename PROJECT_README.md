# Team Collaboration Project

這是一個多設備協作開發的範例專案，展示如何使用 GitHub Copilot AI Agent 進行團隊協作。

## 🌟 專案說明

本專案是一個基於 Node.js + Express 的 API 應用範例，旨在作為多人協作開發的起點。

## 📁 專案結構

```
.
├── .github/                 # GitHub 配置
│   ├── ISSUE_TEMPLATE/      # Issue 模板
│   └── pull_request_template.md  # PR 模板
├── .vscode/                 # VSCode 配置
│   ├── settings.json        # 工作區設定
│   └── extensions.json      # 推薦擴展
├── src/                     # 源代碼
│   ├── index.js             # 應用入口
│   └── index.test.js        # 測試文件
├── .commitlintrc.json       # Commit message 規範
├── .env.example             # 環境變數範例
├── .eslintrc.json           # ESLint 配置
├── .gitattributes           # Git 屬性配置
├── .gitignore               # Git 忽略規則
├── .prettierrc.json         # Prettier 配置
├── CONTRIBUTING.md          # 貢獻指南
├── COPILOT_PROMPTS.md       # Copilot 提示詞庫
├── package.json             # 專案配置
├── QUICKSTART.md            # 快速開始指南
├── README.md                # 主要文檔（本文件）
├── setup.ps1                # 自動設置腳本
└── WORKFLOW.md              # 工作流程文檔
```

## 🚀 快速開始

### 方案 A：使用自動設置腳本（推薦）

```powershell
# 1. 克隆儲存庫
git clone https://github.com/your-org/team-project.git
cd team-project

# 2. 執行設置腳本
.\setup.ps1

# 腳本會自動完成環境檢查、配置和擴展安裝
```

### 方案 B：手動設置

```powershell
# 1. 安裝依賴
npm install

# 2. 配置環境變數
Copy-Item .env.example .env
# 編輯 .env 文件填入實際值

# 3. 運行測試
npm test

# 4. 啟動開發服務器
npm run dev
```

## 📚 文檔

- **[QUICKSTART.md](QUICKSTART.md)** - 15 分鐘快速設置指南
- **[WORKFLOW.md](WORKFLOW.md)** - 詳細的協作工作流程
- **[COPILOT_PROMPTS.md](COPILOT_PROMPTS.md)** - Copilot 提示詞庫
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - 如何貢獻代碼

## 🤖 使用 GitHub Copilot

本專案充分利用 GitHub Copilot AI Agent 進行開發。以下是一些常用的提示詞：

### 代碼生成

```
@workspace 實作用戶認證 API，包含註冊、登入和 JWT token
```

### 代碼審查

```
@workspace 審查這個文件的代碼品質、安全性和最佳實踐
```

### 測試生成

```
@workspace 為這個模組生成完整的測試套件
```

更多提示詞請查看 [COPILOT_PROMPTS.md](COPILOT_PROMPTS.md)

## 🔧 可用指令

```bash
# 開發
npm run dev          # 啟動開發服務器（支援熱重載）
npm start            # 啟動生產服務器

# 測試
npm test             # 運行所有測試
npm run test:watch   # 監視模式運行測試

# 代碼品質
npm run lint         # 檢查代碼風格
npm run lint:fix     # 自動修復代碼風格問題
npm run format       # 格式化代碼
npm run format:check # 檢查代碼格式
```

## 👥 團隊協作流程

### 1. 分支策略

```
main (保護分支)
  ↓
develop
  ↓
feature/功能名稱
fix/問題描述
test/測試範圍
```

### 2. 開發流程

```bash
# 1. 創建功能分支
git checkout -b feature/your-feature

# 2. 使用 Copilot 開發
# 在 VSCode Chat 中: @workspace 實作 [功能]

# 3. 提交代碼
git add .
git commit -m "feat: your feature description"

# 4. 推送分支
git push origin feature/your-feature

# 5. 創建 Pull Request
# 在 GitHub 上創建 PR 並指定審查者
```

### 3. 代碼審查

```bash
# 1. 拉取分支
git fetch origin
git checkout feature/branch-name

# 2. 使用 Copilot 審查
# @workspace 審查這個分支的代碼品質

# 3. 在 GitHub PR 中提供反饋
```

## 🎯 協作角色建議

### 設備 A - 後端開發

- API 端點實作
- 資料庫設計
- 業務邏輯開發
- 使用 Copilot: `@workspace 實作 [後端功能]`

### 設備 B - 前端開發

- UI 組件開發
- 狀態管理
- API 集成
- 使用 Copilot: `@workspace 創建 [UI 組件]`

### 設備 C - 測試與品質保證

- 測試案例撰寫
- 代碼審查
- 文檔維護
- 使用 Copilot: `@workspace 生成測試用於 [功能]`

## ✅ 最佳實踐

### 代碼品質

- ✅ 遵循 ESLint 和 Prettier 規範
- ✅ 編寫有意義的變數和函數名稱
- ✅ 保持函數簡短（< 50 行）
- ✅ 添加適當的註釋和文檔

### Git 使用

- ✅ 使用有意義的 commit message
- ✅ 頻繁提交小的變更
- ✅ 提交前運行測試
- ✅ 創建 PR 前同步 main 分支

### 團隊協作

- ✅ 定期溝通進度
- ✅ 認真審查他人的代碼
- ✅ 及時回應 PR 評論
- ✅ 善用 Copilot 提高效率

## 🐛 問題排查

### Copilot 沒有建議

1. 檢查 Copilot 狀態（VSCode 右下角）
2. 確保已登入 GitHub
3. 重新載入 VSCode: `Ctrl+Shift+P` → "Reload Window"

### 測試失敗

```bash
# 清理並重新安裝依賴
rm -rf node_modules package-lock.json
npm install
npm test
```

### Git 推送失敗

```bash
# 確保分支是最新的
git pull origin main --rebase
git push origin your-branch
```

## 📞 獲取幫助

- 📖 查看文檔
- 💬 創建 Issue
- 👥 聯繫團隊成員
- 🤖 使用 Copilot: `@workspace 如何...`

## 📜 授權

MIT License

## 🙏 致謝

感謝所有貢獻者讓這個專案變得更好！

---

**Happy Coding with AI! 🚀**
