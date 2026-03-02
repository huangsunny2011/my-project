# 共同討論空間使用指南

本指南說明如何使用團隊討論空間進行有效的協作溝通。

## 📋 目錄

- [概述](#概述)
- [快速開始](#快速開始)
- [討論空間結構](#討論空間結構)
- [建立討論](#建立討論)
- [最佳實踐](#最佳實踐)
- [整合 Copilot](#整合-copilot)
- [多專案管理](#多專案管理)

## 🎯 概述

討論空間提供了一個結構化的環境，讓 3 台設備的開發者可以：

- 📢 進行技術討論
- 💡 分享想法和提案
- 📝 記錄決策過程
- 🗓️ 保存會議記錄
- 🐛 協作解決問題

### 為什麼需要討論空間？

```
傳統方式                    使用討論空間
────────────────────────────────────────────────
聊天訊息散亂          →     結構化的討論記錄
難以追蹤決策          →     清晰的決策記錄
知識容易丟失          →     永久保存和易於搜尋
溝通效率低            →     異步協作，各自時區
```

## 🚀 快速開始

### 步驟 1：建立專案討論空間

```powershell
# 為新專案建立討論空間
.\create-discussion-space.ps1 -ProjectName "user-auth-system"

# 指定自訂路徑
.\create-discussion-space.ps1 -ProjectName "payment-api" -ProjectPath "D:\Projects\payment-api"

# 同時設置 GitHub Discussions
.\create-discussion-space.ps1 -ProjectName "my-project" -CreateGitHubDiscussions
```

### 步驟 2：進入討論空間

```powershell
# 進入專案討論目錄
cd discussions\user-auth-system

# 在 VSCode 中打開
code .
```

### 步驟 3：建立第一個討論

```powershell
# 使用輔助腳本建立討論
.\new-discussion.ps1 -Category "technical" -Title "JWT token 實作方式"

# 會自動在 VSCode 中打開新建立的討論文件
```

## 📂 討論空間結構

```
專案根目錄/
│
└── discussions/                    # 所有討論的根目錄
    │
    ├── 專案A/                      # 專案 A 的討論空間
    │   ├── README.md              # 討論索引
    │   ├── new-discussion.ps1     # 建立新討論
    │   ├── search-discussion.ps1  # 搜尋討論
    │   ├── stats.ps1              # 統計資訊
    │   │
    │   ├── general/               # 一般討論
    │   │   ├── README.md
    │   │   └── 2026-03-02-weekly-sync.md
    │   │
    │   ├── ideas/                 # 想法和建議
    │   │   ├── README.md
    │   │   └── 2026-03-01-new-feature-proposal.md
    │   │
    │   ├── technical/             # 技術討論
    │   │   ├── README.md
    │   │   └── 2026-03-02-jwt-implementation.md
    │   │
    │   ├── architecture/          # 架構設計
    │   │   ├── README.md
    │   │   └── ADR-001-database-choice.md
    │   │
    │   ├── troubleshooting/       # 問題排查
    │   │   ├── README.md
    │   │   └── 2026-03-02-login-bug-investigation.md
    │   │
    │   ├── decisions/             # 決策記錄
    │   │   ├── README.md
    │   │   └── 2026-03-01-api-versioning-strategy.md
    │   │
    │   └── meetings/              # 會議記錄
    │       ├── README.md
    │       └── 2026-03-02-sprint-planning.md
    │
    ├── 專案B/                      # 專案 B 的討論空間
    │   └── ...                    # 相同結構
    │
    └── 專案C/                      # 專案 C 的討論空間
        └── ...                    # 相同結構
```

## 💬 建立討論

### 方法 1：使用輔助腳本（推薦）

```powershell
# 基本用法
.\new-discussion.ps1 -Category "technical" -Title "討論主題"

# 指定作者
.\new-discussion.ps1 -Category "ideas" -Title "新功能提案" -Author "張三"

# 不同類型的討論
.\new-discussion.ps1 -Category "general" -Title "本週進度同步"
.\new-discussion.ps1 -Category "architecture" -Title "微服務拆分策略"
.\new-discussion.ps1 -Category "troubleshooting" -Title "記憶體洩漏問題"
.\new-discussion.ps1 -Category "decisions" -Title "選擇前端框架"
.\new-discussion.ps1 -Category "meetings" -Title "Sprint Planning"
```

### 方法 2：手動建立

創建檔案：`discussions/專案名稱/技術討論/2026-03-02-討論主題.md`

```markdown
# 討論主題

**日期:** 2026-03-02
**作者:** 開發者 A
**分類:** technical

---

## 📝 討論內容

這裡描述討論的主要內容...

## 👥 參與者

- @開發者A
- @開發者B
- @開發者C

## 🎯 目標

這次討論想要達成的目標...

## 💬 討論記錄

### 開發者A - 10:30

我認為應該使用 JWT...

### 開發者B - 11:15

同意，但需要考慮 refresh token...

### 開發者C - 14:20

我做了一些研究，建議...

## 📌 結論

最終決定採用...

## ✅ 後續行動

- [ ] 開發者A 實作 JWT middleware (#123)
- [ ] 開發者B 設計 token 刷新機制 (#124)
- [ ] 開發者C 撰寫測試 (#125)

---

**相關連結:**
- Issue #123
- PR #45
- [相關文檔](./link)

**標籤:** `討論中`
```

## 🎨 討論類型和使用場景

### 📢 一般討論 (General)

**使用場景：**
- 每日/每週進度同步
- 團隊公告
- 非技術性溝通

**範例：**
```powershell
.\new-discussion.ps1 -Category "general" -Title "本週進度更新"
```

### 💡 想法和建議 (Ideas)

**使用場景：**
- 新功能提案
- 改進建議
- 創新想法

**範例：**
```powershell
.\new-discussion.ps1 -Category "ideas" -Title "添加暗黑模式支援"
```

**提案格式：**
```markdown
## 背景
為什麼需要這個功能？

## 提案內容
具體想法是什麼？

## 預期效益
會帶來什麼好處？

## 實作難度
初步評估：低/中/高
```

### 🔧 技術討論 (Technical)

**使用場景：**
- API 設計討論
- 資料庫設計
- 演算法選擇
- 程式碼實作細節

**範例：**
```powershell
.\new-discussion.ps1 -Category "technical" -Title "RESTful API 設計規範"
```

### 🏗️ 架構設計 (Architecture)

**使用場景：**
- 系統架構決策
- 技術選型
- 設計模式討論
- 架構決策記錄（ADR）

**範例：**
```powershell
.\new-discussion.ps1 -Category "architecture" -Title "ADR-001-選擇資料庫系統"
```

**ADR 格式：**
```markdown
# ADR-001: 決策標題

## 狀態
[提議/已接受/已拒絕/已廢棄]

## 背景
為什麼需要做這個決策？

## 決策
我們決定採用...

## 理由
1. 理由 1
2. 理由 2
3. 理由 3

## 後果
- 正面影響
- 負面影響
- 風險
```

### 🐛 問題排查 (Troubleshooting)

**使用場景：**
- Bug 調查
- 問題診斷
- 解決方案討論

**範例：**
```powershell
.\new-discussion.ps1 -Category "troubleshooting" -Title "生產環境記憶體洩漏問題"
```

### 📋 決策記錄 (Decisions)

**使用場景：**
- 重要決策記錄
- 投票結果
- 方案選擇

**範例：**
```powershell
.\new-discussion.ps1 -Category "decisions" -Title "API 版本控制策略"
```

### 🗓️ 會議記錄 (Meetings)

**使用場景：**
- 站會記錄
- Sprint Planning
- 回顧會議
- 技術分享會

**範例：**
```powershell
.\new-discussion.ps1 -Category "meetings" -Title "2026-03-02-Sprint-Planning"
```

## 🔍 搜尋和管理

### 搜尋討論

```powershell
# 在所有分類中搜尋
.\search-discussion.ps1 -Keyword "JWT"

# 在特定分類中搜尋
.\search-discussion.ps1 -Keyword "authentication" -Category "technical"

# 搜尋多個關鍵字
.\search-discussion.ps1 -Keyword "API|REST|endpoint"
```

### 查看統計

```powershell
# 查看討論統計
.\stats.ps1

# 輸出範例：
# ==========================================
# user-auth-system - 討論統計
# ==========================================
#
# 📂 general
#    討論數: 5
# 📂 ideas
#    討論數: 3
# 📂 technical
#    討論數: 12
# ...
# 總討論數: 35
# 最近 7 天新增/更新: 8
```

### 討論狀態管理

在討論文件中使用標籤表示狀態：

- `討論中` - 正在進行的討論
- `已解決` - 已經得出結論
- `待決定` - 等待決策
- `已歸檔` - 已歸檔的舊討論
- `需要輸入` - 需要更多人參與

## 🤖 整合 Copilot

### 在討論中使用 Copilot

#### 1. 分析技術問題

```
開發者A 在討論中提問：

"我們應該使用 Session-based 還是 Token-based 認證？"

開發者B 使用 Copilot 協助：

@workspace 分析 Session-based 和 Token-based 認證的優缺點，
考慮我們的專案架構和需求

Copilot 提供詳細分析後，開發者B 將結果整理到討論中。
```

#### 2. 生成討論摘要

```markdown
## 使用 Copilot 生成摘要

在討論進行一段時間後：

@workspace 請總結這個討論的主要觀點和結論
```

#### 3. 建議解決方案

```markdown
## 請 Copilot 提供建議

針對技術問題：

@workspace 基於這個討論，請給出 3 個可行的實作方案，
包含優缺點和建議
```

#### 4. 代碼範例

```markdown
## 使用 Copilot 生成範例

在討論實作細節時：

@workspace 根據討論的需求，生成 JWT 認證 middleware 的範例代碼
```

### Copilot 討論工作流程

```
1. 開發者A 提出問題
   └─> 在討論中描述問題

2. 開發者B 使用 Copilot 分析
   └─> @workspace 分析這個問題

3. 開發者C 驗證 Copilot 建議
   └─> 測試建議的解決方案

4. 團隊討論並決策
   └─> 記錄最終決定

5. 開發者A 實作
   └─> 基於討論結果進行開發
```

## 🌐 多專案管理

### 為不同專案建立獨立討論空間

```powershell
# 專案 1: 用戶認證系統
.\create-discussion-space.ps1 -ProjectName "user-auth-system"

# 專案 2: 支付 API
.\create-discussion-space.ps1 -ProjectName "payment-api"

# 專案 3: 通知服務
.\create-discussion-space.ps1 -ProjectName "notification-service"
```

### 專案間的討論結構

```
discussions/
├── user-auth-system/        # 專案 1
│   ├── technical/
│   │   └── 2026-03-02-jwt-implementation.md
│   └── architecture/
│       └── ADR-001-auth-strategy.md
│
├── payment-api/             # 專案 2
│   ├── technical/
│   │   └── 2026-03-02-stripe-integration.md
│   └── decisions/
│       └── 2026-03-01-payment-gateway-choice.md
│
└── notification-service/    # 專案 3
    ├── technical/
    │   └── 2026-03-02-email-templates.md
    └── architecture/
        └── ADR-001-message-queue.md
```

### 跨專案討論

當討論涉及多個專案時，在討論中明確標註：

```markdown
# 跨專案討論：統一認證機制

**涉及專案:**
- user-auth-system
- payment-api
- notification-service

**日期:** 2026-03-02
**分類:** architecture

---

## 背景

三個專案都需要用戶認證，應該統一認證機制...

## 提案

建立統一的認證服務...

## 影響範圍

### user-auth-system
- 需要重構現有認證...

### payment-api
- 需要整合新的認證...

### notification-service
- 需要實作認證檢查...
```

### 專案討論索引

建立一個總索引文件：

```markdown
# 所有專案討論索引

## 🔗 快速連結

- [user-auth-system 討論](./user-auth-system/)
- [payment-api 討論](./payment-api/)
- [notification-service 討論](./notification-service/)

## 📊 統計總覽

| 專案 | 討論數 | 本週新增 | 待解決 |
|------|--------|----------|--------|
| user-auth-system | 35 | 5 | 3 |
| payment-api | 28 | 3 | 2 |
| notification-service | 15 | 2 | 1 |

## 🔥 熱門討論

1. [統一認證機制](./user-auth-system/architecture/...)
2. [支付閘道選擇](./payment-api/decisions/...)
3. [郵件範本系統](./notification-service/technical/...)
```

## ✅ 最佳實踐

### 1. 討論命名規範

```
格式: YYYY-MM-DD-簡短描述.md

✅ 好的範例:
- 2026-03-02-jwt-token-implementation.md
- 2026-03-02-database-migration-strategy.md

❌ 不好的範例:
- discussion.md
- 討論1.md
- temp.md
```

### 2. 參與討論的禮儀

- ✅ 使用清晰的標題
- ✅ 標註自己的意見和時間
- ✅ 引用具體的代碼或文檔
- ✅ 提供建設性的意見
- ✅ 及時更新討論狀態
- ❌ 避免離題討論
- ❌ 避免人身攻擊
- ❌ 避免在討論中直接修改他人意見

### 3. 定期整理

```powershell
# 每週執行一次
.\stats.ps1

# 檢查：
# - 哪些討論已經解決但未標記？
# - 哪些討論需要更多輸入？
# - 哪些討論可以歸檔？
```

### 4. 連結相關資源

在討論中連結相關資源：

```markdown
## 相關資源

- Issue #123 - 實作用戶認證
- PR #45 - JWT middleware
- [API 文檔](../docs/api.md)
- [架構圖](../docs/architecture-diagram.png)
- [相關討論](./2026-03-01-auth-comparison.md)
```

### 5. 使用檢查清單

對於需要多人協作的討論：

```markdown
## 行動項目

- [x] @開發者A - 研究 JWT 最佳實踐
- [x] @開發者B - 評估安全性問題
- [ ] @開發者C - 實作 prototype
- [ ] @全體 - 審查並提供反饋
```

## 🔄 與 Git 工作流程整合

### 討論 → Issue → PR 流程

```
1. 在討論空間中討論想法
   └─> discussions/project/ideas/2026-03-02-new-feature.md

2. 達成共識後創建 Issue
   └─> GitHub Issue #123: Implement new feature
   └─> 在 Issue 中連結討論

3. 開發實作
   └─> git checkout -b feature/new-feature

4. 創建 Pull Request
   └─> 在 PR 中連結 Issue 和討論
   └─> Closes #123
   └─> 參考討論: discussions/project/ideas/...

5. 更新討論狀態
   └─> 標記為"已實作"
   └─> 連結 PR
```

### 在 Git Commit 中引用討論

```bash
git commit -m "feat: implement new feature

基於團隊討論決定實作此功能。

討論記錄: discussions/project/ideas/2026-03-02-new-feature.md
設計決策: discussions/project/architecture/ADR-001.md

Closes #123"
```

## 🎯 團隊協作模式

### 模式 1：異步討論

```
時間軸        設備 A (UTC+8)    設備 B (UTC+0)    設備 C (UTC-5)
─────────────────────────────────────────────────────────────────
Day 1
09:00 (A)   提出問題
            創建討論

17:00 (B)                    閱讀討論
                             提供意見 1

01:00 (C)                                      閱讀討論
                                               提供意見 2

Day 2
09:00 (A)   閱讀意見
            總結並決策
```

### 模式 2：即時討論（使用 Live Share)

```
1. 開發者A 發起 Live Share 會話
2. 開發者B、C 加入
3. 同時編輯討論文件
4. 即時達成共識
5. 保存討論記錄
```

### 模式 3：結構化決策

```
週一：提案階段
  └─> 各自在討論中提出想法

週二-週四：討論階段
  └─> 異步討論優缺點

週五：決策階段
  └─> 投票或達成共識
  └─> 記錄決策
```

## 📱 GitHub Discussions 整合

### 同步到 GitHub Discussions

```powershell
# 將本地討論同步到 GitHub
# (需要安裝 GitHub CLI)

gh api repos/{owner}/{repo}/discussions \
  -f title="討論標題" \
  -f body="$(Get-Content discussion-file.md -Raw)" \
  -f category_id="CATEGORY_ID"
```

### GitHub Discussions 分類設置

在 GitHub 上設置對應的分類：

- 💬 General (一般討論)
- 💡 Ideas (想法)
- 🔧 Technical (技術)
- 🏗️ Architecture (架構)
- 🐛 Troubleshooting (問題)
- 📋 Decisions (決策)
- 🗓️ Meetings (會議)

## 📚 範例和模板

查看各分類的 README.md 文件，包含詳細的模板和範例。

---

**最後更新:** 2026年3月2日
**維護者:** 全體團隊成員
