# AI Agent 快速開始示例

立即體驗 GitHub Copilot AI Agent 的自動協作能力！

## 🚀 5 分鐘快速演示

### 前置條件

- ✅ VSCode 已安裝 GitHub Copilot
- ✅ 已登入 GitHub Copilot（按 `Ctrl+I` 測試是否可用）

---

## 示例 1：AI 生成完整功能（單設備）

### 步驟 1：創建功能討論（30 秒）

```powershell
# 運行討論空間創建腳本
.\create-discussion-space.ps1 -ProjectName "demo-project"

# 進入討論空間
cd discussions\demo-project

# 創建新討論
.\new-discussion.ps1 -Category ideas -Title "todo-list-feature"
```

### 步驟 2：使用 AI 分析需求（1 分鐘）

打開剛創建的討論文件，在 VSCode 中按 `Ctrl+I`，輸入：

```
@workspace 我要實作一個 Todo List 功能

需求：
- 添加待辦事項
- 標記完成/未完成
- 刪除事項
- 過濾顯示（全部/已完成/未完成）

請分析：
1. 需要的資料結構
2. 前後端 API 設計
3. 資料庫 schema
4. UI 組件設計
5. 完整的實作計劃

將分析結果以 Markdown 格式寫入當前文件
```

**AI 會自動生成：** 完整的技術分析報告（約 200-300 行）

### 步驟 3：AI 生成代碼（2 分鐘）

繼續在 Chat 中：

```
@workspace 根據上述分析，生成完整的 Todo List 實作

生成以下文件：
1. src/models/Todo.js - 資料模型
2. src/routes/todos.js - API 路由
3. src/controllers/todoController.js - 控制器邏輯
4. src/components/TodoList.jsx - React 組件
5. src/components/TodoItem.jsx - 待辦項目組件
6. src/__tests__/todo.test.js - 單元測試

每個文件都要包含完整的代碼和註釋
```

**AI 會逐個生成每個文件：** 你只需按 `Tab` 接受或根據需要調整

### 步驟 4：運行和測試（1 分鐘）

```powershell
# AI 生成的代碼可以直接運行
npm test

# 啟動開發伺服器
npm run dev
```

### 結果

✅ **5 分鐘內完成：**
- 完整的技術分析文檔
- 6 個代碼文件（約 500+ 行）
- 單元測試
- 可運行的 Todo List 功能

---

## 示例 2：3 設備 AI 協作（完整流程）

### 設備 A：AI 輔助需求分析

```powershell
# 創建討論
cd discussions\team-project
.\new-discussion.ps1 -Category ideas -Title "user-profile-feature"
```

在 VSCode Chat 中：
```
@workspace 分析用戶個人資料功能需求

功能：
- 查看個人資料
- 編輯資料（姓名、頭像、簡介）
- 修改密碼
- 賬號設置

請提供：
1. 完整的功能規格
2. 所需的資料庫欄位
3. API 端點設計
4. 前後端工作分配建議

保存到當前討論文件
```

提交討論：
```powershell
git add discussions/
git commit -m "docs: add user profile feature analysis"
git push origin main
```

---

### 設備 B：AI 生成後端代碼

```powershell
# 拉取討論
git pull origin main

# 閱讀討論
cat discussions\team-project\ideas\2026-03-02-user-profile-feature.md

# 創建開發分支
git checkout -b feature/user-profile-backend
```

在 VSCode Chat 中：
```
@workspace 根據 discussions/team-project/ideas/2026-03-02-user-profile-feature.md
生成後端實作

需要：
1. User profile model (src/models/UserProfile.js)
2. Profile routes (src/routes/profile.js)
3. Profile controller (src/controllers/profileController.js)
4. Image upload handler (src/middleware/uploadImage.js)
5. Unit tests (src/__tests__/profile.test.js)

使用 Express + Multer 處理圖片上傳
包含完整的驗證和錯誤處理
```

AI 生成後：
```powershell
# 運行測試
npm test

# 提交並創建 PR
git add .
git commit -m "feat: implement user profile backend"
git push origin feature/user-profile-backend
gh pr create --title "feat: User Profile Backend"
```

---

### 設備 C：AI 生成前端代碼

```powershell
# 拉取討論
git pull origin main

# 創建開發分支
git checkout -b feature/user-profile-frontend
```

在 VSCode Chat 中：
```
@workspace 根據 discussions/team-project/ideas/2026-03-02-user-profile-feature.md
生成前端實作

需要：
1. Profile view page (src/pages/ProfilePage.jsx)
2. Profile edit form (src/components/ProfileEditForm.jsx)
3. Avatar upload (src/components/AvatarUpload.jsx)
4. Password change form (src/components/PasswordChangeForm.jsx)
5. Profile API service (src/services/profileService.js)
6. Component tests (src/components/__tests__/profile.test.jsx)

使用 React + React Hook Form
響應式設計，支持圖片預覽和裁剪
```

AI 生成後：
```powershell
# 本地測試
npm run dev

# 提交並創建 PR
git add .
git commit -m "feat: implement user profile frontend"
git push origin feature/user-profile-frontend
gh pr create --title "feat: User Profile Frontend"
```

---

### 設備 A：AI 審查代碼

```powershell
# 獲取後端分支
git fetch origin
git checkout feature/user-profile-backend
```

在 VSCode Chat 中：
```
@workspace 審查當前分支的代碼

重點檢查：
1. 圖片上傳的安全性（文件類型、大小限制）
2. 輸入驗證是否完整
3. 錯誤處理
4. 測試覆蓋率
5. 是否符合討論中的需求

生成詳細的審查報告
```

在 GitHub PR 上貼上審查報告，或讓 AI 直接生成評論：
```
@workspace 將審查結果轉換為 GitHub PR 評論格式
```

對前端分支重複相同步驟。

---

## 示例 3：AI 驅動的 Bug 修復

### 發現 Bug

```powershell
# 創建問題討論
cd discussions\team-project
.\new-discussion.ps1 -Category troubleshooting -Title "memory-leak-in-chat"
```

### 使用 AI 診斷

在討論文件中，按 `Ctrl+I`：

```
@workspace 聊天功能有記憶體洩漏問題

現象：
- 運行 6 小時後記憶體使用從 200MB 增長到 1.5GB
- Chrome DevTools 顯示大量未釋放的 WebSocket 連接

請：
1. 分析可能的原因
2. 檢查 src/services/chatService.js 的代碼
3. 提供修復方案
4. 生成修復的代碼
```

### AI 自動修復

AI 會：
1. 分析代碼找出問題（未清理的事件監聽器）
2. 提供詳細解釋
3. 生成修復代碼
4. 建議預防措施

```powershell
# 應用修復
git checkout -b fix/chat-memory-leak
# [AI 已修改相關文件]
git add .
git commit -m "fix: resolve memory leak in chat service"
git push origin fix/chat-memory-leak
```

---

## 示例 4：AI 生成測試

### 為現有代碼添加測試

```
@workspace 為 src/services/paymentService.js 生成完整的測試

要求：
1. 單元測試（測試所有方法）
2. 集成測試（測試與 Stripe API 的交互）
3. 錯誤場景測試
4. Mock 外部 API
5. 測試覆蓋率要達到 95%+

使用 Jest + Supertest
保存到 src/__tests__/paymentService.test.js
```

---

## 示例 5：AI 生成文檔

### 自動化文檔生成

```
@workspace 為整個專案生成完整的 API 文檔

掃描 src/routes/ 下的所有路由文件
生成 OpenAPI 3.0 規格

包括：
1. 所有端點的描述
2. 請求參數和格式
3. 響應格式和狀態碼
4. 錯誤代碼說明
5. 使用範例（curl 命令）

保存到 docs/api/openapi.yaml
並生成對應的 Markdown 文檔到 docs/api/README.md
```

---

## 💡 高效提示詞技巧

### ✅ 好的提示詞

```
@workspace 根據 discussions/project/architecture/ADR-001.md 中的決議，
實作 JWT 認證中間件

要求：
- 檔案：src/middleware/auth.js
- 驗證 Bearer Token
- 檢查 Token 過期
- 處理無效 Token 的情況
- 參考 src/middleware/logger.js 的代碼風格
- 包含 JSDoc 註釋
- 添加單元測試到 src/__tests__/middleware/auth.test.js
```

### ❌ 不好的提示詞

```
寫一個認證中間件
```

### 關鍵原則

1. **使用 `@workspace`** - 讓 AI 理解整個專案上下文
2. **參考具體文件** - 指向討論、ADR、或現有代碼
3. **明確要求** - 列出具體的功能點
4. **指定風格** - 參考現有文件的風格
5. **包含測試** - 要求生成對應的測試

---

## 🎯 常用 AI 命令模板

### 需求分析

```
@workspace 分析 [功能名稱] 的需求

考慮：
1. 功能範圍和邊界
2. 技術可行性
3. 所需資源
4. 潛在風險
5. 實作時程

保存分析到 discussions/[project]/ideas/[date]-[feature].md
```

### 代碼生成

```
@workspace 實作 [功能描述]

根據：[討論文件路徑或 ADR]

生成：
1. [文件路徑1] - [說明]
2. [文件路徑2] - [說明]
...

要求：
- 符合專案代碼風格
- 包含完整註釋
- 包含錯誤處理
- 包含單元測試
```

### 代碼審查

```
@workspace 審查當前分支的代碼

檢查：
1. 代碼品質
2. 安全性
3. 性能
4. 測試覆蓋率
5. 是否符合需求

生成詳細報告
```

### Bug 診斷

```
@workspace 診斷以下問題：

錯誤訊息：
[貼上錯誤訊息]

重現步驟：
1. [步驟1]
2. [步驟2]

請：
1. 分析根本原因
2. 提供修復方案
3. 生成修復代碼
4. 建議預防措施
```

### 文檔生成

```
@workspace 生成 [類型] 文檔

範圍：[指定範圍]

格式：[Markdown/OpenAPI/JSDoc]

包括：
1. [內容1]
2. [內容2]

保存到：[文件路徑]
```

---

## 🔥 實用場景速查

| 場景 | 命令開頭 | 關鍵詞 |
|------|---------|--------|
| 分析需求 | `@workspace 分析...需求` | 功能範圍、技術可行性 |
| 設計架構 | `@workspace 設計...架構` | 系統設計、ADR |
| 生成代碼 | `@workspace 實作...` | 根據討論、生成文件 |
| 審查代碼 | `@workspace 審查...` | 代碼品質、安全性 |
| 修復 Bug | `@workspace 診斷...` | 錯誤訊息、根本原因 |
| 重構代碼 | `@workspace 重構...` | 改進可讀性、性能優化 |
| 生成測試 | `@workspace 為...生成測試` | 單元測試、覆蓋率 |
| 文檔更新 | `@workspace 生成...文檔` | API 文檔、README |
| 性能優化 | `@workspace 分析...性能` | 瓶頸、優化建議 |

---

## 📚 下一步

完成快速演示後：

1. **深入學習** - 閱讀 [AI Agent 協作完整指南](AI_AGENT_COLLABORATION_GUIDE.md)
2. **設備設置** - 參考 [設備操作詳細指南](DEVICE_SETUP_GUIDE.md)
3. **討論系統** - 學習 [討論空間使用指南](DISCUSSION_GUIDE.md)
4. **提示詞庫** - 查看 [Copilot 提示詞庫](COPILOT_PROMPTS.md)

---

## 💬 提示

- 💡 **最重要的技巧**：使用 `@workspace` 讓 AI 理解整個專案
- 🎯 **最有效的方式**：在討論空間記錄所有決策，AI 會參考這些記錄
- ⚡ **最快的開發**：讓 AI 生成初步代碼，人類調整和優化
- 🔒 **最安全的做法**：AI 生成後永遠要人類審查

開始使用 AI Agent 協作，體驗 10 倍效率提升！🚀

---

**最後更新：** 2026年3月2日
