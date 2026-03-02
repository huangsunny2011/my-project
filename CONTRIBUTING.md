# 貢獻指南

感謝您想要為本專案做出貢獻！本文檔提供了貢獻的指南和最佳實踐。

## 📋 目錄

- [開始之前](#開始之前)
- [開發流程](#開發流程)
- [代碼規範](#代碼規範)
- [提交規範](#提交規範)
- [Pull Request 流程](#pull-request-流程)
- [使用 Copilot 的最佳實踐](#使用-copilot-的最佳實踐)

## 🚀 開始之前

### 前置要求

- Node.js 18.x 或更高版本
- Git 2.x 或更高版本
- VSCode 最新版本
- GitHub Copilot 訂閱

### 環境設置

1. **Fork 並克隆儲存庫**

   ```bash
   git clone https://github.com/your-username/your-repo.git
   cd your-repo
   ```

2. **執行設置腳本**

   ```powershell
   .\setup.ps1
   ```

3. **安裝依賴**

   ```bash
   npm install
   ```

4. **運行測試確保環境正常**
   ```bash
   npm test
   ```

## 🔄 開發流程

### 1. 創建 Issue

在開始編碼之前，請先創建或認領一個 Issue：

- 如果是新功能，使用 **Feature Request** 模板
- 如果是 Bug 修復，使用 **Bug Report** 模板
- 在 Issue 中標註您將負責這個任務

### 2. 創建分支

```bash
# 確保 main 分支是最新的
git checkout main
git pull origin main

# 創建功能分支
git checkout -b feature/your-feature-name
# 或 Bug 修復分支
git checkout -b fix/bug-description
```

**分支命名規範：**

- `feature/功能名稱` - 新功能
- `fix/問題描述` - Bug 修復
- `docs/文檔主題` - 文檔更新
- `refactor/重構範圍` - 代碼重構
- `test/測試範圍` - 測試相關
- `chore/任務描述` - 維護任務

### 3. 開發

#### 使用 Copilot 輔助開發

```
# 開始開發前，先了解上下文
@workspace 我要實作 [功能名稱]，請分析相關的代碼和架構

# 實作功能
@workspace 實作 [具體需求]

# 代碼審查
@workspace 審查我剛寫的代碼

# 生成測試
@workspace 為這個功能生成測試
```

#### 遵循代碼規範

- 使用 ESLint 和 Prettier 確保代碼風格一致
- 編寫有意義的變數和函數名稱
- 添加適當的註釋
- 保持函數簡短和單一職責

### 4. 測試

```bash
# 運行所有測試
npm test

# 運行特定測試
npm test -- --grep "your test name"

# 檢查測試覆蓋率
npm run test:coverage
```

**測試要求：**

- 新功能必須包含測試
- Bug 修復必須包含重現測試
- 測試覆蓋率不應降低

### 5. 提交

遵循 [Conventional Commits](https://www.conventionalcommits.org/) 規範：

```bash
# 好的提交訊息範例
git commit -m "feat(auth): add JWT authentication"
git commit -m "fix(api): resolve CORS issue"
git commit -m "docs(readme): update installation steps"

# 多行提交訊息
git commit -m "feat(payment): integrate Stripe payment

- Add Stripe SDK
- Implement payment processing
- Add webhook handlers

Closes #123"
```

## 📝 代碼規範

### JavaScript/TypeScript

```typescript
// ✅ 好的範例
export async function getUserById(id: string): Promise<User | null> {
  try {
    const user = await userRepository.findById(id);
    if (!user) {
      logger.warn(`User not found: ${id}`);
      return null;
    }
    return user;
  } catch (error) {
    logger.error("Error fetching user:", error);
    throw new Error("Failed to fetch user");
  }
}

// ❌ 不好的範例
export async function get(i: string) {
  const u = await repo.find(i);
  return u;
}
```

### 命名規範

- **檔案名稱**: `kebab-case.ts`
- **類別**: `PascalCase`
- **函數/變數**: `camelCase`
- **常數**: `UPPER_SNAKE_CASE`
- **接口**: `PascalCase` (加 `I` 前綴或不加都可以)
- **類型別名**: `PascalCase`

### 註釋規範

````typescript
/**
 * 根據 ID 獲取用戶資訊
 *
 * @param id - 用戶的唯一識別符
 * @returns 用戶對象，如果不存在則返回 null
 * @throws {Error} 當資料庫查詢失敗時
 *
 * @example
 * ```typescript
 * const user = await getUserById('123');
 * if (user) {
 *   console.log(user.name);
 * }
 * ```
 */
export async function getUserById(id: string): Promise<User | null> {
  // Implementation
}
````

## 📨 提交規範

### Commit Message 格式

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Type 類型

- `feat`: 新功能
- `fix`: Bug 修復
- `docs`: 文檔變更
- `style`: 代碼格式（不影響功能）
- `refactor`: 重構
- `perf`: 性能優化
- `test`: 測試相關
- `chore`: 構建過程或輔助工具變更
- `ci`: CI 配置變更
- `revert`: 回退之前的 commit

### Scope 範圍

根據專案模組定義，例如：

- `auth` - 認證相關
- `api` - API 相關
- `ui` - UI 相關
- `db` - 資料庫相關
- `config` - 配置相關

### 範例

```bash
# 簡單的提交
git commit -m "feat(auth): add password reset functionality"

# 詳細的提交
git commit -m "fix(api): resolve race condition in user creation

The user creation endpoint had a race condition when multiple
requests were made simultaneously. This fix adds proper locking
mechanism to prevent duplicate user creation.

Fixes #234"

# 破壞性變更
git commit -m "feat(api)!: change authentication flow

BREAKING CHANGE: The authentication endpoint now requires
a refresh token in addition to access token. Clients need
to update their implementation.

Closes #345"
```

## 🔀 Pull Request 流程

### 1. 推送分支

```bash
git push origin feature/your-feature-name
```

### 2. 創建 Pull Request

在 GitHub 上創建 PR，使用提供的模板填寫：

- **標題**: 清晰描述變更
- **描述**: 使用 PR 模板完整填寫
- **關聯 Issue**: 使用 `Closes #123` 自動關閉 Issue
- **標籤**: 添加適當的標籤（bug, enhancement, documentation 等）
- **審查者**: 指定至少一位審查者
- **專案**: 將 PR 添加到專案看板

### 3. 代碼審查

#### 作為提交者

- 回應所有審查意見
- 進行必要的修改
- 推送更新到同一分支
- 標記已解決的對話

#### 作為審查者

使用 Copilot 輔助審查：

```
@workspace 審查這個 PR，重點關注：
1. 代碼品質
2. 安全性
3. 性能
4. 測試覆蓋率
5. 最佳實踐
```

**審查檢查清單：**

- [ ] 代碼符合專案規範
- [ ] 功能實作正確
- [ ] 包含適當的測試
- [ ] 文檔已更新
- [ ] 沒有明顯的安全問題
- [ ] 性能影響可接受
- [ ] Commit 訊息清晰
- [ ] No unnecessary changes

### 4. 合併

PR 必須滿足以下條件才能合併：

- [ ] 至少一位審查者批准
- [ ] 所有 CI 檢查通過
- [ ] 解決所有對話
- [ ] 分支與 main 沒有衝突
- [ ] 測試覆蓋率達標

**合併方式：**

- **Squash and Merge**: 用於多個小提交的功能（默認）
- **Rebase and Merge**: 用於清晰的提交歷史
- **Merge Commit**: 用於合併大型功能分支

## 🤖 使用 Copilot 的最佳實踐

### 代碼生成

```
# 明確的需求描述
@workspace 實作用戶註冊 API，需要：
1. 驗證郵件格式
2. 檢查郵件是否已存在
3. 加密密碼
4. 儲存到資料庫
5. 返回 JWT token
使用 Express 和 PostgreSQL
```

### 代碼審查

```
# 全面的審查
@workspace 審查這個檔案，檢查：
- 代碼品質和可讀性
- 潛在的 bug
- 安全漏洞
- 性能問題
- 最佳實踐違反
```

### 測試生成

```
# 完整的測試要求
@workspace 為這個函數生成測試，包含：
- 正常情況
- 邊界條件
- 錯誤處理
- 模擬外部依賴
使用 Jest 和 TypeScript
```

### 重構建議

```
# 具體的重構目標
@workspace 重構這段代碼以：
1. 減少複雜度
2. 提高可讀性
3. 改善性能
4. 增加可測試性
```

## ❓ 常見問題

### Q: 如何同步上游的變更？

```bash
# 添加上游遠端（僅需一次）
git remote add upstream https://github.com/original-org/original-repo.git

# 獲取上游變更
git fetch upstream

# 合併到本地 main 分支
git checkout main
git merge upstream/main

# 推送到您的 fork
git push origin main
```

### Q: 如何處理合併衝突？

```bash
# 拉取最新的 main
git checkout main
git pull origin main

# 回到功能分支
git checkout feature/your-feature

# 合併 main
git merge main

# 使用 VSCode 解決衝突
# 或使用 Copilot 協助
# "@workspace 分析這個合併衝突並建議解決方案"

# 完成合併
git add .
git commit -m "merge: resolve conflicts with main"
git push origin feature/your-feature
```

### Q: 如何回退錯誤的提交？

```bash
# 回退最後一次提交（保留變更）
git reset --soft HEAD~1

# 回退最後一次提交（丟棄變更）
git reset --hard HEAD~1

# 創建一個新的回退提交
git revert HEAD
```

## 📧 獲取幫助

如果您有任何問題：

- 📖 查看 [README.md](README.md) 和其他文檔
- 💬 在相關 Issue 中提問
- 👥 聯繫團隊成員
- 🤖 使用 Copilot: `@workspace 如何...`

## 🙏 感謝

感謝您的貢獻！每一個 PR 都讓專案變得更好。

---

**維護者:** 全體團隊成員
**最後更新:** 2026年3月2日
