# 討論空間範例集

本文檔提供實際的討論範例，幫助團隊快速上手。

## 📂 範例目錄

- [技術討論範例](#技術討論範例)
- [架構決策範例](#架構決策範例)
- [問題排查範例](#問題排查範例)
- [會議記錄範例](#會議記錄範例)
- [功能提案範例](#功能提案範例)

---

## 🔧 技術討論範例

### 範例 1: JWT 認證實作方式

**檔案名稱:** `discussions/user-auth-system/technical/2026-03-02-jwt-authentication-implementation.md`

```markdown
# JWT 認證實作方式

**日期:** 2026-03-02
**作者:** 開發者A
**分類:** technical

---

## 📝 討論內容

我們需要為 API 實作 JWT 認證機制。目前考慮兩種方案：

1. **存儲在 Cookie 中**
   - 優點: 自動發送、HttpOnly 安全
   - 缺點: CSRF 風險

2. **存儲在 LocalStorage 中**
   - 優點: 易於使用、跨域支援
   - 缺點: XSS 風險

## 🤖 Copilot 分析

我使用 Copilot 分析了這個問題：

\```
@workspace 分析 JWT token 存儲在 Cookie vs LocalStorage 的安全性
考慮 XSS、CSRF 攻擊和我們的應用架構
\```

**Copilot 建議：**
- 推薦使用 HttpOnly Cookie + SameSite 屬性
- 配合 CSRF token 防護
- Token 刷新機制使用 Refresh Token

## 👥 參與者

- @開發者A (提出問題)
- @開發者B (安全專家)
- @開發者C (前端負責人)

## 💬 討論記錄

### 開發者A - 10:30

我傾向使用 Cookie，因為安全性較高。但需要處理 CSRF 問題。

### 開發者B - 11:15

同意使用 Cookie。建議實作方案：
1. Access Token (短期，15分鐘) - HttpOnly Cookie
2. Refresh Token (長期，7天) - HttpOnly Cookie
3. 使用 SameSite=Strict 屬性
4. 實作 CSRF Token (存在 header 中)

程式碼範例：

\```javascript
// 設置 Cookie
res.cookie('accessToken', token, {
  httpOnly: true,
  secure: process.env.NODE_ENV === 'production',
  sameSite: 'strict',
  maxAge: 15 * 60 * 1000 // 15 分鐘
});
\```

### 開發者C - 14:20

從前端角度來看，Cookie 方案可行。但需要注意：
- 跨域請求需要設置 `credentials: 'include'`
- 開發環境需要處理 CORS

我會在前端這樣調用：

\```javascript
fetch('https://api.example.com/data', {
  method: 'GET',
  credentials: 'include', // 重要：包含 Cookie
  headers: {
    'X-CSRF-Token': getCsrfToken() // CSRF 防護
  }
});
\```

### 開發者A - 15:00

感謝意見！我整理了實作計劃，請看結論部分。

## 📌 結論

**決定採用 HttpOnly Cookie + CSRF Token 方案**

理由：
1. 安全性較高（防 XSS）
2. 自動管理生命週期
3. 配合 CSRF Token 可防 CSRF 攻擊
4. 符合業界最佳實踐

技術規格：
- Access Token: 15 分鐘，HttpOnly, Secure, SameSite=Strict
- Refresh Token: 7 天，HttpOnly, Secure, SameSite=Strict
- CSRF Token: 存在自訂 Header 中
- Token 刷新端點: `/api/auth/refresh`

## ✅ 後續行動

- [x] @開發者A - 實作 JWT middleware (#123) - 完成
- [x] @開發者B - 實作 CSRF 防護 (#124) - 完成
- [ ] @開發者C - 前端整合測試 (#125) - 進行中
- [ ] @全體 - 安全審查 - 待安排

---

**相關連結:**
- Issue #123: JWT Authentication Implementation
- PR #45: Add JWT middleware
- [OWASP JWT 安全指南](https://cheatsheetseries.owasp.org/cheatsheets/JSON_Web_Token_for_Java_Cheat_Sheet.html)
- [相關決策](../decisions/2026-03-01-authentication-strategy.md)

**標籤:** `已解決` `security` `authentication`
```

---

## 🏗️ 架構決策範例

### 範例 2: 資料庫選擇 ADR

**檔案名稱:** `discussions/payment-api/architecture/ADR-001-database-selection.md`

```markdown
# ADR-001: 資料庫系統選擇

**日期:** 2026-03-01
**狀態:** 已接受
**決策者:** 開發者A, 開發者B, 開發者C
**分類:** architecture

---

## 背景

支付 API 專案需要選擇合適的資料庫系統。主要需求：
- 交易一致性（ACID）
- 支援複雜查詢
- 良好的擴展性
- 團隊熟悉度

## 🤖 使用 Copilot 研究

\```
@workspace 比較 PostgreSQL、MySQL、MongoDB 用於支付系統
考慮 ACID、性能、擴展性和金融交易需求
\```

## 選項分析

### 選項 1: PostgreSQL

**優點：**
- 完整的 ACID 支援
- 豐富的資料類型（JSON、Array）
- 優秀的查詢優化器
- 強大的擴展性（PostGIS、全文搜索）
- 開源且活躍的社群

**缺點：**
- 寫入性能略低於 MySQL
- 設置較複雜
- 記憶體佔用較高

**評分:** 9/10

### 選項 2: MySQL

**優點：**
- 寫入性能優秀
- 簡單易用
- 廣泛使用，資源豐富
- 複製配置簡單

**缺點：**
- 某些高級功能不如 PostgreSQL
- JSON 支援較晚加入
- 部分操作不符合標準 SQL

**評分:** 7/10

### 選項 3: MongoDB

**優點：**
- 水平擴展容易
- 靈活的 Schema
- 查詢速度快

**缺點：**
- ❌ 預設不保證 ACID（跨文檔）
- ❌ 不適合金融交易
- 學習曲線較陡

**評分:** 4/10（不適合此場景）

## 💬 團隊討論

### 開發者A - 09:00

我推薦 PostgreSQL。支付系統最重要的是資料一致性，PostgreSQL 的 ACID 支援最完整。

### 開發者B - 10:30

同意 PostgreSQL。補充幾點：
1. 支援 JSON，未來可能需要
2. 有豐富的擴展（如 TimescaleDB 用於時序資料）
3. 我之前專案有使用經驗

### 開發者C - 11:45

從測試角度支持 PostgreSQL：
- 更容易寫測試（Docker 容器）
- pgTAP 測試框架
- 完整的交易回滾支援

## 決策

**選擇 PostgreSQL 作為主資料庫系統**

## 理由

1. **資料一致性**: 完整的 ACID 支援，適合金融交易
2. **功能豐富**: JSON、陣列、全文搜索等功能
3. **擴展性**: 可透過分區、複製等方式擴展
4. **團隊熟悉**: 開發者 B 有使用經驗
5. **社群支援**: 活躍的開源社群
6. **成本**: 開源免費

## 後果

### 正面影響
- ✅ 資料一致性有保障
- ✅ 減少資料不一致的風險
- ✅ 豐富的功能減少額外開發

### 負面影響
- ⚠️ 需要學習 PostgreSQL 特有功能
- ⚠️ 初期設置較複雜
- ⚠️ 可能需要額外的效能調優

### 風險
- 記憶體使用較高，需監控
- 需要規劃備份策略
- 需要設置連接池避免連接耗盡

## 實作計劃

### Phase 1: 基礎設置（Week 1）
- [ ] 安裝 PostgreSQL 14.x
- [ ] 設置開發環境
- [ ] 配置連接池（pgBouncer）
- [ ] 建立備份策略

### Phase 2: Schema 設計（Week 2）
- [ ] 設計資料表結構
- [ ] 建立索引策略
- [ ] 設計分區策略（如需要）

### Phase 3: 整合與測試（Week 3）
- [ ] 應用程式整合
- [ ] 效能測試
- [ ] 壓力測試

## 監控與評估

3 個月後評估：
- 查詢性能是否符合預期
- 是否有資料一致性問題
- 記憶體使用是否合理
- 團隊是否需要額外培訓

如發現重大問題，重新評估此決策。

## 參考資料

- [PostgreSQL vs MySQL for Payments](https://example.com)
- [PostgreSQL Performance Tuning](https://example.com)
- [ACID in PostgreSQL](https://example.com)

---

**審查者簽名:**
- ✅ 開發者A (2026-03-01)
- ✅ 開發者B (2026-03-01)
- ✅ 開發者C (2026-03-01)

**標籤:** `ADR` `database` `已接受`
```

---

## 🐛 問題排查範例

### 範例 3: 記憶體洩漏調查

**檔案名稱:** `discussions/notification-service/troubleshooting/2026-03-02-memory-leak-investigation.md`

```markdown
# 生產環境記憶體洩漏問題調查

**日期:** 2026-03-02
**作者:** 開發者B
**分類:** troubleshooting
**嚴重性:** 🔥 高

---

## 🔴 問題描述

生產環境的 Notification Service 在運行 6-8 小時後記憶體使用量持續增長，
最終導致 OOM（Out of Memory）錯誤並重啟。

## 📊 現象

- 初始記憶體: ~200MB
- 8小時後: ~2GB
- 錯誤訊息: `JavaScript heap out of memory`
- 發生頻率: 每天 2-3 次
- 影響: 服務中斷 2-5 分鐘

## 🔍 重現步驟

1. 部署 v1.2.3 到生產環境
2. 觀察記憶體使用（每小時記錄）
3. 約 8 小時後記憶體使用達到 2GB
4. 服務崩潰並自動重啟

## 📈 監控資料

\```
時間   | 記憶體使用 | 請求數 | EventEmitter 監聽器
-------|-----------|--------|------------------
00:00  | 200MB     | 0      | 15
02:00  | 450MB     | 3.2K   | 156
04:00  | 820MB     | 6.1K   | 312
06:00  | 1.2GB     | 9.5K   | 468
08:00  | 1.8GB     | 12.3K  | 624
08:30  | OOM Crash | -      | -
\```

**觀察:** EventEmitter 監聽器數量異常增長！

## 🤖 使用 Copilot 診斷

\```
@workspace 分析 Node.js 記憶體洩漏，特別是 EventEmitter 監聽器持續增長的問題
檢查 notification-service 的程式碼
\```

**Copilot 發現:**
1. WebSocket 連接未正確清理監聽器
2. 定時器未正確清除
3. 閉包持有大型物件引用

## 💬 調查記錄

### 開發者B - 09:00

初步調查發現可能的原因：

1. **WebSocket 監聽器洩漏**

   問題代碼：
   \```javascript
   // 每次連接都添加監聽器，但從未移除
   function handleConnection(ws) {
     ws.on('message', handleMessage);
     ws.on('close', handleClose);
     // ❌ 沒有清理機制
   }
   \```

2. **定時器未清理**

   \```javascript
   setInterval(() => {
     // 定時任務
   }, 60000);
   // ❌ 沒有 clearInterval
   \```

### 開發者A - 10:30

我檢查了程式碼，還發現：

3. **大型物件被閉包引用**

   \```javascript
   function sendNotification(userId, notification) {
     const largeUserData = await fetchUserData(userId); // 10KB

     // 閉包持有 largeUserData
     setTimeout(() => {
       logger.log('Sent to:', largeUserData.email);
     }, 60000);
   }
   \```

### 開發者C - 11:45

使用 Chrome DevTools 的 Heap Snapshot 分析：

發現記憶體中有大量未釋放的：
- WebSocket 物件: 624 個（應該 < 100）
- Timer 物件: 312 個（應該 < 50）
- User Data 物件: 1248 個（應該在處理後釋放）

## 💡 解決方案

### 方案 1: 修復 WebSocket 監聽器

\```javascript
function handleConnection(ws) {
  const messageHandler = (msg) => handleMessage(ws, msg);
  const closeHandler = () => {
    // ✅ 清理監聽器
    ws.removeListener('message', messageHandler);
    ws.removeListener('close', closeHandler);
    handleClose(ws);
  };

  ws.on('message', messageHandler);
  ws.on('close', closeHandler);
}
\```

### 方案 2: 清理定時器

\```javascript
const timers = new Set();

function startTask() {
  const timer = setInterval(() => {
    // 任務
  }, 60000);
  timers.add(timer);
}

function cleanup() {
  timers.forEach(timer => clearInterval(timer));
  timers.clear();
}

// 在關閉時清理
process.on('SIGTERM', cleanup);
\```

### 方案 3: 避免閉包持有大物件

\```javascript
function sendNotification(userId, notification) {
  const largeUserData = await fetchUserData(userId);
  const userEmail = largeUserData.email; // ✅ 只保留需要的

  setTimeout(() => {
    logger.log('Sent to:', userEmail); // ✅ 不持有整個物件
  }, 60000);
}
\```

## ✅ 測試驗證

### 開發者B - 測試結果

應用修復後，在測試環境運行 12 小時：

\```
時間   | 記憶體使用 | EventEmitter 監聽器
-------|-----------|------------------
00:00  | 200MB     | 15
04:00  | 220MB     | 18
08:00  | 235MB     | 22
12:00  | 240MB     | 25
\```

✅ 記憶體穩定！
✅ 監聽器數量正常！

## 📝 根本原因

1. WebSocket 連接後未清理事件監聽器
2. 定時器未在適當時機清除
3. 閉包持有大型物件導致無法垃圾回收

## ✅ 後續行動

- [x] @開發者B - 實作監聽器清理機制 (#234) - 完成
- [x] @開發者A - 添加定時器管理 (#235) - 完成
- [x] @開發者C - 添加記憶體監控告警 (#236) - 完成
- [ ] @全體 - Code Review 防止類似問題 - 進行中
- [ ] @開發者B - 部署到生產環境 - 待安排
- [ ] @全體 - 監控 7 天確認穩定 - 待進行

## 📚 學習與改進

### 預防措施
1. 使用 ESLint 插件檢測監聽器洩漏
2. 定期進行記憶體分析
3. 實作自動化記憶體測試
4. 建立監聽器和定時器管理的最佳實踐文檔

### 監控改進
- 添加 EventEmitter 監聽器數量監控
- 設定記憶體增長告警閾值
- 自動 Heap Dump 在記憶體異常時

---

**相關連結:**
- Issue #234: Fix WebSocket listener leak
- PR #67: Implement event listener cleanup
- [Node.js 記憶體洩漏最佳實踐](link)

**標籤:** `已解決` `memory-leak` `production-issue` `high-priority`
```

---

## 🗓️ 會議記錄範例

### 範例 4: Sprint Planning

**檔案名稱:** `discussions/user-auth-system/meetings/2026-03-02-sprint-planning.md`

```markdown
# Sprint 5 Planning Meeting

**日期:** 2026-03-02
**時間:** 09:00 - 11:00 (2 小時)
**類型:** Sprint Planning
**參與者:** 開發者A, 開發者B, 開發者C
**主持人:** 開發者A
**記錄人:** 開發者C

---

## 會議目標

規劃 Sprint 5 的工作項目（2026-03-04 至 2026-03-17，共 2 週）

## 上一個 Sprint 回顧

### 完成的工作
- ✅ JWT 認證實作 (#123)
- ✅ CSRF 防護 (#124)
- ✅ 前端整合測試 (#125)
- ✅ 記憶體洩漏修復 (#234, #235, #236)

### 未完成的工作
- ❌ OAuth2 整合 (#126) - 延期到 Sprint 5
- ❌ API 文檔更新 (#127) - 延期到 Sprint 5

### 團隊速率
- 計劃: 30 點
- 完成: 26 點
- 完成率: 87%

## Sprint 5 目標

### 主要目標
1. 完成 OAuth2 整合
2. 更新所有 API 文檔
3. 實作用戶權限系統
4. 性能優化

### 目標陳述
> "實作完整的認證授權系統，包含 OAuth2 和權限管理，並確保文檔完整"

## 待辦項目討論

### Story 1: OAuth2 整合 (#126)

**優先級:** P0 (最高)
**預估點數:** 8 點
**負責人:** 開發者A

**驗收標準:**
- [ ] 支援 Google OAuth2
- [ ] 支援 GitHub OAuth2
- [ ] 用戶資料綁定
- [ ] 錯誤處理完整
- [ ] 包含測試

**開發者A:** 我建議分成兩個子任務：
1. Google OAuth2 (5 點)
2. GitHub OAuth2 (3 點)

**決議:** 同意拆分

---

### Story 2: 用戶權限系統 (#128)

**優先級:** P0
**預估點數:** 13 點
**負責人:** 開發者B

**使用 Copilot 輔助設計:**

\```
@workspace 設計 RBAC 權限系統，需要支援：
- 角色管理（Admin、User、Guest）
- 權限檢查中間件
- API 端點權限配置
\```

Based on Copilot的建議，我們決定使用 RBAC 模式。

**驗收標準:**
- [ ] 角色定義（Admin, User, Guest）
- [ ] 權限中間件
- [ ] 資料庫設計
- [ ] API 權限配置
- [ ] 測試覆蓋率 > 80%

---

### Story 3: API 文檔更新 (#127)

**優先級:** P1
**預估點數:** 5 點
**負責人:** 開發者C

**驗收標準:**
- [ ] 使用 OpenAPI 3.0
- [ ] 所有端點有文檔
- [ ] 包含範例請求/響應
- [ ] 部署到文檔網站

**開發者C:** 我會使用 Swagger UI 展示文檔。

---

### Story 4: 性能優化 (#129)

**優先級:** P2
**預估點數:** 8 點
**負責人:** 開發者A, 開發者B (協作)

**範圍:**
- [ ] 資料庫查詢優化
- [ ] 添加 Redis 快取
- [ ] API Response 壓縮
- [ ] CDN 配置

---

### Bug 修復

#### Bug #130: 登入頁面閃爍
**優先級:** P1
**預估:** 2 點
**負責人:** 開發者C

#### Bug #131: Token 刷新偶爾失敗
**優先級:** P0
**預估:** 3 點
**負責人:** 開發者A

## Sprint Backlog

| ID | 項目 | 點數 | 負責人 | 優先級 |
|----|------|------|--------|--------|
| #126 | OAuth2 - Google | 5 | 開發者A | P0 |
| #126 | OAuth2 - GitHub | 3 | 開發者A | P0 |
| #131 | Bug: Token 刷新 | 3 | 開發者A | P0 |
| #128 | 權限系統 | 13 | 開發者B | P0 |
| #127 | API 文檔 | 5 | 開發者C | P1 |
| #130 | Bug: 頁面閃爍 | 2 | 開發者C | P1 |
| #129 | 性能優化 | 8 | 開發者A+B | P2 |
| **總計** | | **39** | | |

**團隊承諾:** 基於上一個 Sprint 的速率(26點)，我們承諾完成 30 點的工作。
性能優化 (#129) 作為 Stretch Goal。

## 風險與依賴

### 風險
1. **OAuth2 整合可能比預期複雜**
   - 緩解: 提前研究文檔，必要時尋求外部協助

2. **權限系統需要資料庫遷移**
   - 緩解: 先在開發環境測試遷移腳本

### 依賴
- OAuth2 需要先取得 Google/GitHub 的應用憑證
  - **行動:** 開發者A 今天申請

## 定義
 of Done

一個 Story 被認為 Done 當：
- [x] 代碼完成並通過 Code Review
- [x] 所有測試通過（單元測試 + 整合測試）
- [x] 文檔已更新
- [x] 已部署到測試環境
- [x] 產品負責人驗收通過

## 每日站會安排

- **時間:** 每天 09:30
- **時長:** 15 分鐘
- **格式:**
  - 昨天完成了什麼
  - 今天計劃做什麼
  - 有什麼阻礙

## Sprint Review & Retrospective

- **Sprint Review:** 2026-03-17 14:00
- **Sprint Retrospective:** 2026-03-17 15:00

## 決議事項

1. ✅ Sprint 5 承諾 30 點，Stretch Goal 8 點
2. ✅ OAuth2 拆分為兩個子任務
3. ✅ 採用 RBAC 權限模式
4. ✅ 使用 Swagger UI 生成 API 文檔
5. ✅ 開發者A 負責申請 OAuth2 憑證

## 行動項目

- [ ] 開發者A - 申請 Google OAuth2 憑證 - 2026-03-02
- [ ] 開發者A - 申請 GitHub OAuth2 憑證 - 2026-03-02
- [ ] 開發者B - 設計權限系統資料庫 Schema - 2026-03-03
- [ ] 開發者C - 準備 API 文檔模板 - 2026-03-03
- [ ] 全體 - 更新 Jira/GitHub Projects - 2026-03-02

## 下次會議

**Sprint Review & Retrospective**
- **時間:** 2026-03-17 14:00
- **主題:** Sprint 5 成果展示和回顧

---

**會議記錄確認:**
- ✅ 開發者A (2026-03-02)
- ✅ 開發者B (2026-03-02)
- ✅ 開發者C (2026-03-02)

**標籤:** `sprint-planning` `meeting` `sprint-5`
```

---

## 💡 功能提案範例

### 範例 5: 暗黑模式支援

**檔案名稱:** `discussions/frontend-app/ideas/2026-03-01-dark-mode-support.md`

```markdown
# [提案] 添加暗黑模式支援

**日期:** 2026-03-01
**提案人:** 開發者C
**分類:** ideas

---

## 💡 提案概述

為應用程式添加暗黑模式支援，讓用戶可以選擇淺色或深色主題。

## 背景與動機

### 為什麼需要？

1. **用戶回饋:** 收到 15+ 用戶請求支援暗黑模式
2. **眼睛健康:** 減少夜間使用時的眼睛疲勞
3. **省電:** 在 OLED 螢幕上可節省電力
4. **趨勢:** 現代應用的標準功能

### 競品分析

| 應用 | 暗黑模式 | 自動切換 | 用戶評價 |
|------|---------|---------|----------|
| GitHub | ✅ | ✅ | ⭐⭐⭐⭐⭐ |
| Twitter | ✅ | ✅ | ⭐⭐⭐⭐⭐ |
| LinkedIn | ✅ | ❌ | ⭐⭐⭐⭐ |
| 我們 | ❌ | ❌ | - |

## 🤖 使用 Copilot 研究

\```
@workspace 研究實作 React 應用暗黑模式的最佳實踐
包含主題切換、本地存儲、系統偏好檢測
\```

**Copilot 建議的實作方案:**
1. 使用 CSS Variables
2. Context API 管理主題狀態
3. localStorage 保存用戶偏好
4. 偵測系統主題偏好

## 提案內容

### 功能需求

#### 1. 主題切換
- 淺色模式（預設）
- 深色模式
- 自動模式（跟隨系統）

#### 2. UI 組件
- 主題切換按鈕（在導航欄）
- 三個選項的下拉選單
- 平滑的過渡動畫

#### 3. 設定保存
- 保存到 localStorage
- 在用戶登入時同步到伺服器

#### 4. 響應系統偏好
\```javascript
// 偵測系統主題
const darkModeQuery = window.matchMedia('(prefers-color-scheme: dark)');
\```

### 技術實作

#### 方案 A: CSS Variables (推薦)

**優點:**
- 性能好
- 易於維護
- 支援動態切換

\```css
:root {
  --bg-primary: #ffffff;
  --text-primary: #000000;
}

[data-theme="dark"] {
  --bg-primary: #1a1a1a;
  --text-primary: #ffffff;
}
\```

#### 方案 B: CSS-in-JS (Styled Components)

**優點:**
- 與 React 整合緊密
- 類型安全

**缺點:**
- 性能較差
- Bundle 大小增加

**決定:** 採用方案 A

### UI 設計

\```
┌─────────────────────────────────┐
│  Logo    [搜尋]    🌙 [選單] v  │
│                                 │
│  主題選擇：                      │
│  ○ 淺色模式                     │
│  ● 深色模式                     │
│  ○ 自動（跟隨系統）             │
└─────────────────────────────────┘
\```

## 預期效益

### 用戶體驗
- ✅ 提高用戶滿意度
- ✅ 減少眼睛疲勞
- ✅ 符合現代應用標準

### 技術效益
- ✅ 改善 CSS 架構
- ✅ 建立主題系統（未來可擴展更多主題）

### 商業效益
- ✅ 提升用戶留存率（預估 +3%）
- ✅ 減少用戶流失

## 實作難度

**評估:** 中等

### 簡單的部分 (40%)
- CSS Variables 設定
- 基本的主題切換邏輯

### 中等的部分 (45%)
- 各組件的樣式調整
- 圖片和圖標的深色版本
- localStorage 整合

### 困難的部分 (15%)
- 確保所有組件在深色模式下可讀
- 處理第三方組件
- 過渡動畫

**預估工時:** 3-4 天

## 實作計劃

### Phase 1: 基礎架構 (1 天)
- [ ] 設定 CSS Variables
- [ ] 實作主題 Context
- [ ] 基本的切換功能

### Phase 2: UI 適配 (1.5 天)
- [ ] 導航欄和側邊欄
- [ ] 按鈕和表單元素
- [ ] 卡片和容器
- [ ] 圖表和圖片

### Phase 3: 整合與優化 (0.5 天)
- [ ] localStorage 保存
- [ ] 系統偏好檢測
- [ ] 過渡動畫
- [ ] 跨瀏覽器測試

### Phase 4: 測試與文檔 (1 天)
- [ ] 測試所有頁面
- [ ] 修復樣式問題
- [ ] 更新用戶文檔
- [ ] 團隊培訓

## 潛在風險

1. **第三方組件不支援**
   - 緩解: 提前檢查，必要時自訂樣式

2. **圖片和SVG需要調整**
   - 緩解: 準備深色版本或使用 CSS filter

3. **可能影響現有樣式**
   - 緩解: 充分測試，使用 CSS Variables 避免衝突

## 👥 討論

### 開發者A - 14:00

很好的提案！我支持實作。建議：
1. 先實作核心功能（淺色/深色切換）
2. 自動模式可以放在 v2
3. 需要設計團隊提供深色模式的設計規範

### 開發者B - 15:30

從後端角度：
- 需要在用戶設定 API 添加 `theme_preference` 欄位
- 資料庫 migration 很簡單
- 我可以快速實作後端部分

### 開發者C - 16:00

感謝意見！我會：
1. 找設計團隊討論深色模式的色彩方案
2. 建立 prototype 給大家看
3. 整理技術實作指南

## 📌 下一步

- [ ] @開發者C - 與設計團隊會議 - 2026-03-03
- [ ] @開發者C - 建立 prototype - 2026-03-05
- [ ] @開發者B - 實作後端 API - 2026-03-06
- [ ] @全體 - 審查 prototype - 2026-03-07
- [ ] @開發者C - 正式實作 - 如獲批准

## 投票結果

- ✅ 開發者A: 贊成
- ✅ 開發者B: 贊成
- ✅ 開發者C: 贊成（提案人）

**決議:** 提案通過，進入實作階段

---

**相關連結:**
- [Material Design Dark Theme Guidelines](https://material.io/design/color/dark-theme.html)
- [相關用戶回饋 #89, #102, #145]

**標籤:** `feature-request` `approved` `ui-ux`
```

---

## 📚 更多資源

- **[DISCUSSION_GUIDE.md](DISCUSSION_GUIDE.md)** - 完整使用指南
- **[DISCUSSION_QUICK_REF.md](DISCUSSION_QUICK_REF.md)** - 快速參考
- **[create-discussion-space.ps1](create-discussion-space.ps1)** - 自動化腳本

---

**最後更新:** 2026年3月2日
