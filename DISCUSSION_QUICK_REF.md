# 討論空間快速參考

## 🚀 快速命令

### 建立新專案討論空間
```powershell
.\create-discussion-space.ps1 -ProjectName "專案名稱"
```

### 建立新討論
```powershell
cd discussions\專案名稱
.\new-discussion.ps1 -Category "technical" -Title "討論主題"
```

### 搜尋討論
```powershell
.\search-discussion.ps1 -Keyword "關鍵字"
```

### 查看統計
```powershell
.\stats.ps1
```

## 📂 討論分類

- **general** - 一般討論、進度更新
- **ideas** - 想法和建議、新功能提案
- **technical** - 技術問題、實作細節
- **architecture** - 架構設計、技術選型
- **troubleshooting** - 問題排查、Bug 調查
- **decisions** - 決策記錄、ADR
- **meetings** - 會議記錄、站會

## 📝 討論模板範例

```markdown
# 討論標題

**日期:** YYYY-MM-DD
**作者:** 姓名
**分類:** technical/ideas/etc

## 📝 討論內容
內容描述...

## 👥 參與者
- @開發者A
- @開發者B

## 💬 討論記錄

### 開發者A - 10:00
意見內容...

### 開發者B - 11:30
回應內容...

## 📌 結論
最終決定...

## ✅ 後續行動
- [ ] 任務 1 (@負責人)
- [ ] 任務 2 (@負責人)
```

## 🤖 與 Copilot 整合

### 在討論中使用 Copilot

```
# 分析技術問題
@workspace 分析 [技術問題] 並提供解決方案建議

# 生成討論摘要
@workspace 總結這個討論的主要觀點和結論

# 建議實作方案
@workspace 基於討論提供 3 個可行的實作方案

# 生成代碼範例
@workspace 根據討論需求生成範例代碼
```

## 🎯 使用場景

### 場景 1：技術決策
1. 開發者A 在 `technical/` 創建討論
2. 使用 Copilot 分析選項
3. 團隊異步討論
4. 在 `decisions/` 記錄最終決策

### 場景 2：問題排查
1. 開發者B 在 `troubleshooting/` 記錄問題
2. 使用 Copilot 診斷
3. 開發者C 提供意見
4. 記錄解決方案

### 場景 3：功能提案
1. 開發者C 在 `ideas/` 提出想法
2. 團隊討論可行性
3. 達成共識後創建 Issue
4. 開始實作

## 🔗 工作流程整合

```
討論 → Issue → 開發 → PR → 合併

1. 在討論空間討論想法
   └─> discussions/project/ideas/new-feature.md

2. 創建 GitHub Issue
   └─> Issue #123: Implement new feature
   └─> 引用討論連結

3. 開發分支
   └─> git checkout -b feature/new-feature

4. 創建 PR
   └─> 引用 Issue 和討論
   └─> Closes #123

5. 更新討論狀態
   └─> 標記"已實作"
```

## 💡 最佳實踐

- ✅ 使用清晰的標題和日期格式
- ✅ 標註所有參與者
- ✅ 記錄討論過程和結論
- ✅ 連結相關 Issue 和 PR
- ✅ 定期更新討論狀態
- ✅ 使用 Copilot 輔助分析
- ✅ 異步協作，尊重時區差異

---

**完整指南:** [DISCUSSION_GUIDE.md](DISCUSSION_GUIDE.md)
