# 📁 專案檔案結構說明

完整的專案檔案和目錄結構概覽。

---

## 📂 目錄結構總覽

```
d:\TEJ\
│
├─ 📘 核心文檔（必讀）
│  ├─ README.md                               ⭐ 主要入口，總體概覽
│  ├─ DOCS_INDEX.md                           📚 文檔導航索引
│  ├─ QUICKSTART.md                           🚀 15 分鐘快速設置
│  ├─ AI_QUICK_START.md                       ⚡ 5 分鐘 AI 演示
│  └─ DEVICE_SETUP_GUIDE.md                   👥 設備操作指南
│
├─ 🤖 AI 協作文檔
│  ├─ AI_AGENT_COLLABORATION_GUIDE.md         📖 AI 完整協作指南
│  └─ COPILOT_PROMPTS.md                      💬 提示詞模板庫
│
├─ 💬 討論空間文檔
│  ├─ DISCUSSION_GUIDE.md                     📖 討論系統使用指南
│  ├─ DISCUSSION_QUICK_REF.md                 🔖 命令快速參考
│  └─ DISCUSSION_EXAMPLES.md                  📝 真實範例集
│
├─ 🔄 工作流程文檔
│  ├─ WORKFLOW.md                             📋 Git 協作流程
│  └─ WORKFLOW_DIAGRAM.md                     📊 視覺化流程圖
│
├─ 🏗️ 專案規範文檔
│  ├─ ARCHITECTURE.md                         🏛️ 架構設計文檔
│  ├─ CONTRIBUTING.md                         🤝 貢獻指南
│  └─ PROJECT_README.md                       📄 專案說明模板
│
├─ 🔧 設置和故障排除
│  └─ SETUP_FIX.md                           🔨 問題解決指南
│
├─ 🛠️ 自動化腳本
│  ├─ setup.ps1                              ⚙️ 環境自動設置（有編碼問題）
│  └─ create-discussion-space.ps1            📝 討論空間創建器
│
├─ ⚙️ 配置檔案
│  ├─ package.json                           📦 Node.js 依賴
│  ├─ .eslintrc.json                         🔍 ESLint 配置
│  ├─ .prettierrc.json                       ✨ Prettier 配置
│  ├─ .commitlintrc.json                     📝 Commit 規範
│  ├─ jest.config.js                         🧪 Jest 測試配置
│  ├─ jest.setup.js                          🔧 Jest 設置
│  ├─ .env.example                           🔐 環境變數範例
│  ├─ .gitignore                             🚫 Git 忽略規則
│  └─ .gitattributes                         📋 Git 屬性設置
│
├─ 📁 目錄
│  ├─ .vscode/                               ⚙️ VSCode 工作區設置
│  ├─ .github/                               🐙 GitHub Actions 配置
│  └─ src/                                   💻 原始碼目錄
│
└─ 📝 自動生成（運行腳本後）
   └─ discussions/                           💬 討論空間目錄
      └─ [project-name]/                    📁 專案討論
         ├─ ideas/                          💡 功能提案
         ├─ technical/                      🔧 技術討論
         ├─ architecture/                   🏗️ 架構決策
         ├─ meetings/                       📅 會議記錄
         ├─ troubleshooting/                🐛 問題排查
         ├─ reviews/                        👀 代碼審查
         ├─ notes/                          📝 開發筆記
         └─ [helper scripts]                🛠️ 輔助腳本
```

---

## 📘 文檔詳細說明

### 核心入口文檔

#### [README.md](README.md) ⭐
- **用途：** 專案總體概覽和入門指南
- **適合：** 所有人，第一次閱讀
- **包含：**
  - 完整的功能介紹
  - 前置需求說明
  - 設置步驟概覽
  - 工作流程說明
  - 常見問題解答
- **閱讀時間：** 10-15 分鐘
- **更新頻率：** 隨專案更新

#### [DOCS_INDEX.md](DOCS_INDEX.md) 📚
- **用途：** 文檔導航和快速查找
- **適合：** 需要快速找到特定文檔的人
- **包含：**
  - 按主題分類的文檔列表
  - 按場景的文檔推薦
  - 文檔關係圖
  - 快速搜索表
- **閱讀時間：** 5 分鐘
- **使用方式：** 查詢工具，隨時參考

#### [QUICKSTART.md](QUICKSTART.md) 🚀
- **用途：** 15 分鐘快速設置指南
- **適合：** 第一次設置環境的人
- **包含：**
  - 必要軟體安裝
  - 環境配置步驟
  - 驗證安裝
  - 第一次使用指南
- **閱讀時間：** 15 分鐘（含實際操作）
- **前置需求：** 無

#### [AI_QUICK_START.md](AI_QUICK_START.md) ⚡
- **用途：** 5 分鐘 AI 協作快速演示
- **適合：** 想立即體驗 AI 功能的人
- **包含：**
  - 5 個實用場景演示
  - AI 提示詞範例
  - 常用命令模板
  - 效率提升技巧
- **閱讀時間：** 5 分鐘
- **前置需求：** 已安裝 GitHub Copilot

#### [DEVICE_SETUP_GUIDE.md](DEVICE_SETUP_GUIDE.md) 👥
- **用途：** 3 設備具體操作流程
- **適合：** 多人團隊協作
- **包含：**
  - 設備 A（架構師）操作指南
  - 設備 B（後端）操作指南
  - 設備 C（前端）操作指南
  - 7 天開發週期範例
- **閱讀時間：** 20 分鐘
- **使用方式：** 各設備查看自己的部分

---

### 🤖 AI 協作文檔

#### [AI_AGENT_COLLABORATION_GUIDE.md](AI_AGENT_COLLABORATION_GUIDE.md) 📖
- **用途：** AI Agent 深度協作指南
- **適合：** 想充分利用 AI 的開發者
- **包含：**
  - 6 個開發階段的 AI 使用方法
  - 完整的 3 天支付功能開發案例
  - 詳細的 AI 提示詞範例
  - 高級 AI 協作技巧
  - TDD、性能優化等進階用法
- **檔案大小：** 約 27KB（800+ 行）
- **閱讀時間：** 30-40 分鐘
- **深度：** ⭐⭐⭐⭐⭐

#### [COPILOT_PROMPTS.md](COPILOT_PROMPTS.md) 💬
- **用途：** 精選提示詞模板庫
- **適合：** 日常開發參考
- **包含：**
  - 代碼生成提示詞
  - 代碼審查提示詞
  - 測試生成提示詞
  - 文檔生成提示詞
  - 重構和優化提示詞
- **閱讀時間：** 10 分鐘
- **使用方式：** 隨時複制貼上使用

---

### 💬 討論空間文檔

#### [DISCUSSION_GUIDE.md](DISCUSSION_GUIDE.md) 📖
- **用途：** 討論空間系統完整指南
- **適合：** 團隊負責人和協作者
- **包含：**
  - 討論空間概念和結構
  - 7 個討論類別說明
  - 創建和管理討論的方法
  - 討論驅動開發（DDD）模式
  - 最佳實踐和工作流程
- **閱讀時間：** 25 分鐘
- **深度：** ⭐⭐⭐

#### [DISCUSSION_QUICK_REF.md](DISCUSSION_QUICK_REF.md) 🔖
- **用途：** 命令和模板快速參考
- **適合：** 日常開發使用
- **包含：**
  - 常用命令速查表
  - 討論模板
  - Git 命令速查
  - 快速操作指南
- **閱讀時間：** 5 分鐘
- **使用方式：** 加入書籤，隨時查閱

#### [DISCUSSION_EXAMPLES.md](DISCUSSION_EXAMPLES.md) 📝
- **用途：** 真實場景討論範例
- **適合：** 需要參考範例的人
- **包含：**
  - 💡 功能提案範例（暗黑模式）
  - 🔧 技術討論範例（JWT 認證）
  - 🏗️ 架構決策範例（資料庫選擇 ADR）
  - 🐛 問題排查範例（記憶體洩漏）
  - 📅 會議記錄範例（Sprint 規劃）
- **閱讀時間：** 20 分鐘
- **使用方式：** 需要時參考對應場景

---

### 🔄 工作流程文檔

#### [WORKFLOW.md](WORKFLOW.md) 📋
- **用途：** Git 協作流程和最佳實踐
- **適合：** 團隊成員和協作者
- **包含：**
  - Git Flow 分支策略
  - Pull Request 流程
  - 代碼審查規範
  - CI/CD 流程
  - 版本發布流程
- **閱讀時間：** 25 分鐘
- **深度：** ⭐⭐⭐

#### [WORKFLOW_DIAGRAM.md](WORKFLOW_DIAGRAM.md) 📊
- **用途：** 視覺化協作流程
- **適合：** 視覺學習者
- **包含：**
  - 完整協作流程圖（Mermaid）
  - AI 輔助代碼生命週期
  - 3 設備角色分配圖
  - 典型一天的工作時序圖
  - 2 週 Sprint 甘特圖
  - Git 分支策略圖
  - 討論空間結構圖
  - 效率提升對比圖
- **閱讀時間：** 15 分鐘
- **視覺效果：** ⭐⭐⭐⭐⭐

---

### 🏗️ 專案規範文檔

#### [ARCHITECTURE.md](ARCHITECTURE.md) 🏛️
- **用途：** 專案架構和設計決策
- **適合：** 架構師和技術負責人
- **包含：**
  - 系統架構概覽
  - 技術棧選擇
  - 設計模式
  - 模組劃分
  - 數據流設計
- **閱讀時間：** 30 分鐘
- **深度：** ⭐⭐⭐⭐

#### [CONTRIBUTING.md](CONTRIBUTING.md) 🤝
- **用途：** 代碼貢獻指南
- **適合：** 所有開發者
- **包含：**
  - 代碼風格規範
  - Commit 訊息格式
  - Pull Request 規範
  - 測試要求
  - 文檔更新規則
- **閱讀時間：** 15 分鐘
- **重要性：** ⭐⭐⭐⭐

#### [PROJECT_README.md](PROJECT_README.md) 📄
- **用途：** 新專案 README 模板
- **適合：** 創建新專案時使用
- **包含：**
  - README 結構範本
  - 必要章節
  - 範例內容
- **閱讀時間：** 10 分鐘
- **使用方式：** 複制並修改

---

### 🔧 設置和故障排除

#### [SETUP_FIX.md](SETUP_FIX.md) 🔨
- **用途：** 設置問題解決指南
- **適合：** 遇到安裝問題的人
- **包含：**
  - setup.ps1 編碼問題解決
  - 手動安裝步驟
  - 常見錯誤排查
  - PowerShell UTF-8 設置
  - 依賴安裝故障排除
- **閱讀時間：** 20 分鐘
- **使用時機：** 遇到問題時

---

## 🛠️ 自動化腳本說明

### setup.ps1 ⚙️ （有已知問題）
```powershell
# 功能：自動化環境設置
# 狀態：有 UTF-8 編碼問題，建議使用手動安裝
# 執行：.\setup.ps1
# 時間：約 5 分鐘（如果成功）
# 問題：PowerShell 解析錯誤 at lines 62, 163, 190
# 解決：參考 SETUP_FIX.md 進行手動安裝
```

**包含的設置：**
- ✅ Git 配置
- ✅ Node.js 依賴安裝
- ✅ VSCode 擴展安裝
- ✅ GitHub CLI 設置
- ❌ 編碼問題導致無法正常執行

### create-discussion-space.ps1 📝 （完全可用）
```powershell
# 功能：自動創建討論空間
# 狀態：完全可用，無已知問題
# 執行：.\create-discussion-space.ps1 -ProjectName "my-project"
# 時間：約 2 分鐘
```

**創建的結構：**
```
discussions/
└─ my-project/
   ├─ ideas/                          💡 功能提案
   ├─ technical/                      🔧 技術討論
   ├─ architecture/                   🏗️ 架構決策
   ├─ meetings/                       📅 會議記錄
   ├─ troubleshooting/                🐛 問題排查
   ├─ reviews/                        👀 代碼審查
   ├─ notes/                          📝 開發筆記
   ├─ README.md                       📖 專案說明
   ├─ new-discussion.ps1              ➕ 創建討論
   ├─ search-discussion.ps1           🔍 搜索討論
   ├─ stats.ps1                       📊 統計資訊
   └─ archive-discussion.ps1          📦 歸檔討論
```

---

## ⚙️ 配置檔案說明

### package.json 📦
```json
{
  "name": "multi-device-copilot-collab",
  "version": "1.0.0",
  "description": "多設備 AI Agent 協作開發框架"
}
```

**主要依賴：**
- `express`: 4.18.2 - Web 框架
- `dotenv`: 16.3.1 - 環境變數管理
- `jest`: 29.7.0 - 測試框架
- `eslint`: 8.55.0 - 代碼檢查
- `prettier`: 3.1.1 - 代碼格式化
- `@commitlint/*`: Commit 規範檢查

### .eslintrc.json 🔍
```json
{
  "env": { "node": true, "es2021": true },
  "extends": ["eslint:recommended"],
  "rules": { ... }
}
```

**用途：** JavaScript/TypeScript 代碼品質檢查

### .prettierrc.json ✨
```json
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 100
}
```

**用途：** 自動代碼格式化配置

### .commitlintrc.json 📝
```json
{
  "extends": ["@commitlint/config-conventional"]
}
```

**用途：** Commit 訊息格式檢查（Conventional Commits）

**格式範例：**
```
feat: 添加用戶認證功能
fix: 修復記憶體洩漏問題
docs: 更新 API 文檔
style: 調整代碼格式
refactor: 重構認證模組
test: 添加單元測試
chore: 更新依賴套件
```

### jest.config.js 🧪
```javascript
module.exports = {
  testEnvironment: 'node',
  coverageDirectory: 'coverage',
  collectCoverageFrom: ['src/**/*.js'],
  testMatch: ['**/__tests__/**/*.js', '**/*.test.js']
};
```

**用途：** Jest 測試框架配置

### .env.example 🔐
```bash
# 環境變數範例
NODE_ENV=development
PORT=3000
DATABASE_URL=postgresql://localhost:5432/mydb
JWT_SECRET=your-secret-key
```

**用途：** 環境變數範例（複制為 .env 使用）

### .gitignore 🚫
```
node_modules/
.env
coverage/
*.log
.DS_Store
```

**用途：** 指定 Git 忽略的檔案和目錄

---

## 📁 目錄說明

### .vscode/ ⚙️
```
.vscode/
├─ settings.json          工作區設置
├─ extensions.json        推薦擴展
├─ launch.json            除錯配置
└─ tasks.json             任務配置
```

**用途：** VSCode 工作區特定設置

**settings.json 重要設置：**
```json
{
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  },
  "github.copilot.enable": {
    "*": true
  }
}
```

### .github/ 🐙
```
.github/
├─ workflows/
│  ├─ ci.yml              持續整合
│  └─ cd.yml              持續部署
└─ PULL_REQUEST_TEMPLATE.md
```

**用途：** GitHub Actions 自動化和 PR 模板

### src/ 💻
```
src/
├─ index.js               應用入口
├─ index.test.js          入口測試
├─ models/                資料模型
├─ routes/                路由定義
├─ controllers/           控制器邏輯
├─ middleware/            中間件
├─ services/              業務邏輯
├─ utils/                 工具函數
└─ __tests__/             測試檔案
```

**用途：** 應用原始碼

### discussions/ 💬 （運行腳本後生成）
```
discussions/
├─ project-alpha/
├─ project-beta/
└─ project-gamma/
```

**用途：** 多專案討論空間

**每個專案目錄結構：**
```
project-name/
├─ ideas/                 💡 功能提案和改進建議
├─ technical/             🔧 技術討論和實作方案
├─ architecture/          🏗️ 架構決策記錄（ADR）
├─ meetings/              📅 會議記錄和決議
├─ troubleshooting/       🐛 問題排查和解決方案
├─ reviews/               👀 代碼審查和 PR 討論
└─ notes/                 📝 開發日誌和隨手筆記
```

---

## 📊 檔案統計

### 文檔檔案

| 類別 | 數量 | 總大小 |
|------|------|--------|
| 核心文檔 | 5 個 | ~100 KB |
| AI 協作文檔 | 2 個 | ~40 KB |
| 討論文檔 | 3 個 | ~60 KB |
| 工作流程文檔 | 2 個 | ~50 KB |
| 專案規範 | 3 個 | ~40 KB |
| 設置指南 | 1 個 | ~15 KB |
| **總計** | **16 個** | **~305 KB** |

### 配置檔案

| 類型 | 數量 |
|------|------|
| JSON 配置 | 6 個 |
| JavaScript 配置 | 2 個 |
| Git 配置 | 2 個 |
| **總計** | **10 個** |

### 腳本檔案

| 腳本 | 行數 | 狀態 |
|------|------|------|
| setup.ps1 | ~200 | ⚠️ 有編碼問題 |
| create-discussion-space.ps1 | ~300 | ✅ 正常運作 |
| **總計** | **~500** | |

---

## 🎯 使用建議

### 📚 初次使用順序

1. ☑️ [README.md](README.md) - 了解整體
2. ☑️ [DOCS_INDEX.md](DOCS_INDEX.md) - 知道有哪些資源
3. ☑️ [QUICKSTART.md](QUICKSTART.md) - 設置環境
4. ☑️ [AI_QUICK_START.md](AI_QUICK_START.md) - 體驗 AI
5. ☑️ [DEVICE_SETUP_GUIDE.md](DEVICE_SETUP_GUIDE.md) - 學習操作

### 📖 日常參考文檔

加入書籤：
- [AI_QUICK_START.md](AI_QUICK_START.md) - AI 命令速查
- [DISCUSSION_QUICK_REF.md](DISCUSSION_QUICK_REF.md) - 討論命令速查
- [COPILOT_PROMPTS.md](COPILOT_PROMPTS.md) - 提示詞庫

### 🔧 遇到問題時

檢查順序：
1. [SETUP_FIX.md](SETUP_FIX.md) - 設置問題
2. [DOCS_INDEX.md](DOCS_INDEX.md) - 找相關文檔
3. [DISCUSSION_EXAMPLES.md](DISCUSSION_EXAMPLES.md) - 參考範例
4. [README.md](README.md) - 查看常見問題

---

## 🔄 檔案更新記錄

| 檔案 | 最後更新 | 版本 |
|------|---------|------|
| README.md | 2026-03-02 | v1.3 |
| AI_AGENT_COLLABORATION_GUIDE.md | 2026-03-02 | v1.0 |
| AI_QUICK_START.md | 2026-03-02 | v1.0 |
| WORKFLOW_DIAGRAM.md | 2026-03-02 | v1.0 |
| DOCS_INDEX.md | 2026-03-02 | v1.0 |
| 其他文檔 | 2026-03-01 | v1.0 |

---

## 📞 需要幫助？

- 📖 查看 [文檔導航索引](DOCS_INDEX.md) 找到你需要的內容
- 🤖 在 VSCode 中使用 `@workspace` 詢問 Copilot
- 🔍 搜索相關關鍵詞
- 📝 參考 [討論範例集](DISCUSSION_EXAMPLES.md)

---

**最後更新：** 2026年3月2日

[返回 README](README.md) | [查看文檔導航](DOCS_INDEX.md)
