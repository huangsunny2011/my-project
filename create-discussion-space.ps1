# 自動建立專案討論空間腳本
# 此腳本會為不同專案建立獨立的討論路徑和結構

param(
    [Parameter(Mandatory=$false)]
    [string]$ProjectName = "",
    
    [Parameter(Mandatory=$false)]
    [string]$ProjectPath = "",
    
    [Parameter(Mandatory=$false)]
    [switch]$CreateGitHubDiscussions = $false
)

Write-Host "==================================" -ForegroundColor Cyan
Write-Host "專案討論空間建立工具" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# 如果沒有提供專案名稱，詢問用戶
if ([string]::IsNullOrWhiteSpace($ProjectName)) {
    $ProjectName = Read-Host "請輸入專案名稱（例如：user-auth-system）"
}

# 清理專案名稱（移除特殊字符）
$CleanProjectName = $ProjectName -replace '[^a-zA-Z0-9-_]', '-'
$CleanProjectName = $CleanProjectName.ToLower()

Write-Host "專案名稱: $CleanProjectName" -ForegroundColor Green

# 如果沒有提供路徑，使用當前目錄
if ([string]::IsNullOrWhiteSpace($ProjectPath)) {
    $ProjectPath = Get-Location
}

# 建立討論空間目錄結構
$DiscussionsRoot = Join-Path $ProjectPath "discussions"
$ProjectDiscussionPath = Join-Path $DiscussionsRoot $CleanProjectName

Write-Host ""
Write-Host "建立討論空間目錄..." -ForegroundColor Yellow

# 建立主討論目錄
if (-not (Test-Path $DiscussionsRoot)) {
    New-Item -ItemType Directory -Path $DiscussionsRoot | Out-Null
    Write-Host "✓ 建立目錄: $DiscussionsRoot" -ForegroundColor Green
}

# 建立專案特定討論目錄
if (-not (Test-Path $ProjectDiscussionPath)) {
    New-Item -ItemType Directory -Path $ProjectDiscussionPath | Out-Null
    Write-Host "✓ 建立目錄: $ProjectDiscussionPath" -ForegroundColor Green
}

# 建立討論分類目錄
$Categories = @(
    "general",          # 一般討論
    "ideas",           # 想法和建議
    "technical",       # 技術討論
    "architecture",    # 架構設計
    "troubleshooting", # 問題排查
    "decisions",       # 決策記錄
    "meetings"         # 會議記錄
)

foreach ($category in $Categories) {
    $categoryPath = Join-Path $ProjectDiscussionPath $category
    if (-not (Test-Path $categoryPath)) {
        New-Item -ItemType Directory -Path $categoryPath | Out-Null
        Write-Host "✓ 建立分類: $category" -ForegroundColor Green
    }
}

# 建立討論索引文件
$IndexContent = @"
# $ProjectName - 討論空間

> 建立時間: $(Get-Date -Format "yyyy年MM月dd日 HH:mm:ss")
> 專案路徑: $ProjectPath

## 📂 討論分類

### 📢 [General - 一般討論](./general/)
日常討論、進度更新、團隊溝通

### 💡 [Ideas - 想法和建議](./ideas/)
新功能提案、改進建議、創新想法

### 🔧 [Technical - 技術討論](./technical/)
技術問題、實作細節、程式碼討論

### 🏗️ [Architecture - 架構設計](./architecture/)
系統架構、設計模式、技術選型

### 🐛 [Troubleshooting - 問題排查](./troubleshooting/)
Bug 調查、問題診斷、解決方案

### 📋 [Decisions - 決策記錄](./decisions/)
重要決策、架構決策記錄（ADR）

### 🗓️ [Meetings - 會議記錄](./meetings/)
團隊會議、站會記錄、回顧會議

---

## 🎯 使用指南

### 建立新討論

``````powershell
# 使用腳本建立討論
.\new-discussion.ps1 -Category "technical" -Title "如何實作用戶認證"
``````

### 討論命名規範

``````
格式: YYYY-MM-DD-討論主題.md
範例: 2026-03-02-user-authentication-implementation.md
``````

### 討論模板

每個討論應包含：
- 標題和日期
- 參與者
- 討論內容
- 決策或結論
- 後續行動

---

## 👥 參與者

- 開發者 A: [GitHub 用戶名]
- 開發者 B: [GitHub 用戶名]
- 開發者 C: [GitHub 用戶名]

## 📊 討論統計

- 總討論數: 0
- 本週新增: 0
- 待解決: 0

---

**最後更新:** $(Get-Date -Format "yyyy年MM月dd日")
"@

$IndexPath = Join-Path $ProjectDiscussionPath "README.md"
$IndexContent | Out-File -FilePath $IndexPath -Encoding UTF8
Write-Host "✓ 建立索引文件: README.md" -ForegroundColor Green

# 為每個分類建立 README
$CategoryTemplates = @{
    "general" = @"
# 一般討論

## 📢 關於此分類

這裡是團隊日常討論、進度更新和一般溝通的空間。

## 討論指南

- 使用清晰的標題
- 標註參與者
- 記錄重要結論
- 連結相關 Issues 或 PRs

## 最近討論

<!-- 自動更新 -->

---

**分類管理員:** 全體成員
"@
    "ideas" = @"
# 想法和建議

## 💡 關於此分類

分享新功能提案、改進建議和創新想法。

## 提案格式

``````markdown
# [提案] 功能名稱

## 背景
為什麼需要這個功能？

## 提案內容
具體的實作想法

## 預期效益
帶來什麼好處？

## 實作難度
初步評估

## 討論
團隊意見
``````

---

**分類管理員:** 全體成員
"@
    "technical" = @"
# 技術討論

## 🔧 關於此分類

技術問題、實作細節、程式碼討論的空間。

## 討論主題

- API 設計
- 資料庫設計
- 演算法選擇
- 程式碼重構
- 效能優化

## 使用 Copilot 協助討論

``````
@workspace 分析這個技術問題並提供建議
``````

---

**分類管理員:** 技術負責人
"@
    "architecture" = @"
# 架構設計

## 🏗️ 關於此分類

系統架構、設計模式、技術選型的討論。

## 架構決策記錄（ADR）

使用 ADR 格式記錄重要的架構決策：

``````markdown
# ADR-001: 選擇資料庫系統

## 狀態
已接受

## 背景
需要選擇適合的資料庫系統

## 決策
選擇 PostgreSQL

## 理由
1. 關聯式資料庫
2. 成熟穩定
3. 豐富的功能

## 後果
- 優點: 資料一致性強
- 缺點: 擴展性相對較低
``````

---

**分類管理員:** 架構師
"@
    "troubleshooting" = @"
# 問題排查

## 🐛 關於此分類

Bug 調查、問題診斷、解決方案的討論。

## 問題報告格式

``````markdown
# [問題] 簡短描述

## 現象
發生了什麼？

## 重現步驟
如何重現？

## 分析
可能的原因

## 解決方案
嘗試的解決方法

## 結果
解決了嗎？
``````

---

**分類管理員:** 全體成員
"@
    "decisions" = @"
# 決策記錄

## 📋 關於此分類

記錄專案的重要決策和架構決策記錄（ADR）。

## 決策模板

``````markdown
# 決策-001: 決策標題

**日期:** YYYY-MM-DD
**狀態:** [提議/已接受/已拒絕/已廢棄]
**決策者:** 參與決策的人員

## 背景
為什麼需要做這個決策？

## 選項
1. 選項 A - 描述、優缺點
2. 選項 B - 描述、優缺點
3. 選項 C - 描述、優缺點

## 決策
選擇了哪個選項？

## 理由
為什麼選擇這個？

## 影響
這個決策會帶來什麼影響？

## 後續行動
需要做什麼？
``````

---

**分類管理員:** 團隊領導
"@
    "meetings" = @"
# 會議記錄

## 🗓️ 關於此分類

團隊會議、站會、回顧會議的記錄。

## 會議記錄模板

``````markdown
# 會議記錄 - YYYY-MM-DD

**類型:** [站會/計劃會議/回顧會議/技術討論]
**時間:** YYYY-MM-DD HH:MM
**參與者:** A, B, C
**主持人:** X
**記錄人:** Y

## 議程
1. 議題 1
2. 議題 2

## 討論內容

### 議題 1
討論內容...

### 議題 2
討論內容...

## 決議事項
1. 決議 1
2. 決議 2

## 行動項目
- [ ] 任務 1 - 負責人 (@username) - 截止日期
- [ ] 任務 2 - 負責人 (@username) - 截止日期

## 下次會議
**時間:** YYYY-MM-DD HH:MM
**主題:** 下次會議主題
``````

---

**分類管理員:** 會議主持人
"@
}

foreach ($category in $Categories) {
    $categoryReadmePath = Join-Path (Join-Path $ProjectDiscussionPath $category) "README.md"
    if ($CategoryTemplates.ContainsKey($category)) {
        $CategoryTemplates[$category] | Out-File -FilePath $categoryReadmePath -Encoding UTF8
        Write-Host "✓ 建立分類說明: $category/README.md" -ForegroundColor Green
    }
}

# 建立新討論的輔助腳本
$NewDiscussionScriptPath = Join-Path $ProjectDiscussionPath "new-discussion.ps1"
$NewDiscussionScript = @"
# 建立新討論的輔助腳本

param(
    [Parameter(Mandatory=`$true)]
    [ValidateSet("general", "ideas", "technical", "architecture", "troubleshooting", "decisions", "meetings")]
    [string]`$Category,
    
    [Parameter(Mandatory=`$true)]
    [string]`$Title,
    
    [Parameter(Mandatory=`$false)]
    [string]`$Author = `$env:USERNAME
)

`$Date = Get-Date -Format "yyyy-MM-dd"
`$FileName = "`$Date-`$(`$Title -replace '[^a-zA-Z0-9-_]', '-' -replace '--+', '-').md"
`$FilePath = Join-Path `$PSScriptRoot "`$Category/`$FileName"

`$Content = @"
# `$Title

**日期:** `$Date
**作者:** `$Author
**分類:** `$Category

---

## 📝 討論內容

<!-- 在此輸入討論內容 -->


## 👥 參與者

- @`$Author

## 🎯 目標

<!-- 這次討論想要達成什麼目標？ -->


## 💬 討論記錄

### `$Author - `$(Get-Date -Format "HH:mm")

<!-- 您的意見 -->


## 📌 結論

<!-- 討論的結論或決議 -->


## ✅ 後續行動

- [ ] 任務 1
- [ ] 任務 2

---

**相關連結:**
- Issue #
- PR #
- 其他討論 #

**標籤:** ``````討論中``````
"@

`$Content | Out-File -FilePath `$FilePath -Encoding UTF8

Write-Host "✓ 已建立新討論: `$FileName" -ForegroundColor Green
Write-Host "  路徑: `$FilePath" -ForegroundColor Gray

# 在 VSCode 中開啟討論文件
if (Get-Command code -ErrorAction SilentlyContinue) {
    code `$FilePath
}
"@

$NewDiscussionScript | Out-File -FilePath $NewDiscussionScriptPath -Encoding UTF8
Write-Host "✓ 建立討論輔助腳本: new-discussion.ps1" -ForegroundColor Green

# 建立討論搜尋腳本
$SearchDiscussionScriptPath = Join-Path $ProjectDiscussionPath "search-discussion.ps1"
$SearchDiscussionScript = @"
# 搜尋討論的輔助腳本

param(
    [Parameter(Mandatory=`$true)]
    [string]`$Keyword,
    
    [Parameter(Mandatory=`$false)]
    [string]`$Category = "*"
)

Write-Host "搜尋關鍵字: `$Keyword" -ForegroundColor Yellow
Write-Host "搜尋範圍: `$Category" -ForegroundColor Yellow
Write-Host ""

`$SearchPath = if (`$Category -eq "*") { `$PSScriptRoot } else { Join-Path `$PSScriptRoot `$Category }
`$Results = Get-ChildItem -Path `$SearchPath -Include "*.md" -Recurse | Select-String -Pattern `$Keyword

if (`$Results) {
    Write-Host "找到 `$(`$Results.Count) 個結果:" -ForegroundColor Green
    Write-Host ""
    
    `$Results | ForEach-Object {
        Write-Host "📄 `$(`$_.Filename)" -ForegroundColor Cyan
        Write-Host "   `$(`$_.Line.Trim())" -ForegroundColor Gray
        Write-Host "   路徑: `$(`$_.Path)" -ForegroundColor DarkGray
        Write-Host ""
    }
} else {
    Write-Host "未找到相關討論" -ForegroundColor Red
}
"@

$SearchDiscussionScript | Out-File -FilePath $SearchDiscussionScriptPath -Encoding UTF8
Write-Host "✓ 建立搜尋腳本: search-discussion.ps1" -ForegroundColor Green

# 建立討論統計腳本
$StatsScriptPath = Join-Path $ProjectDiscussionPath "stats.ps1"
$StatsScript = @"
# 討論統計腳本

Write-Host "==================================" -ForegroundColor Cyan
Write-Host "$ProjectName - 討論統計" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

`$Categories = @("general", "ideas", "technical", "architecture", "troubleshooting", "decisions", "meetings")

foreach (`$cat in `$Categories) {
    `$catPath = Join-Path `$PSScriptRoot `$cat
    `$count = (Get-ChildItem -Path `$catPath -Filter "*.md" -Exclude "README.md" -ErrorAction SilentlyContinue).Count
    
    Write-Host "📂 `$cat" -ForegroundColor Yellow
    Write-Host "   討論數: `$count" -ForegroundColor White
}

Write-Host ""
`$totalDiscussions = (Get-ChildItem -Path `$PSScriptRoot -Include "*.md" -Recurse -Exclude "README.md" -ErrorAction SilentlyContinue).Count
Write-Host "總討論數: `$totalDiscussions" -ForegroundColor Green

`$lastWeek = (Get-Date).AddDays(-7)
`$recentDiscussions = Get-ChildItem -Path `$PSScriptRoot -Include "*.md" -Recurse -Exclude "README.md" -ErrorAction SilentlyContinue | Where-Object { `$_.LastWriteTime -gt `$lastWeek }
Write-Host "最近 7 天新增/更新: `$(`$recentDiscussions.Count)" -ForegroundColor Green
"@

$StatsScript | Out-File -FilePath $StatsScriptPath -Encoding UTF8
Write-Host "✓ 建立統計腳本: stats.ps1" -ForegroundColor Green

Write-Host ""
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "討論空間建立完成！" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📂 討論空間路徑:" -ForegroundColor Yellow
Write-Host "   $ProjectDiscussionPath" -ForegroundColor White
Write-Host ""
Write-Host "📖 快速開始:" -ForegroundColor Yellow
Write-Host "   1. 查看討論空間: " -NoNewline -ForegroundColor White
Write-Host "code '$ProjectDiscussionPath'" -ForegroundColor Cyan
Write-Host ""
Write-Host "   2. 建立新討論: " -NoNewline -ForegroundColor White
Write-Host "cd '$ProjectDiscussionPath' ; .\new-discussion.ps1 -Category 'technical' -Title '討論主題'" -ForegroundColor Cyan
Write-Host ""
Write-Host "   3. 搜尋討論: " -NoNewline -ForegroundColor White
Write-Host ".\search-discussion.ps1 -Keyword '關鍵字'" -ForegroundColor Cyan
Write-Host ""
Write-Host "   4. 查看統計: " -NoNewline -ForegroundColor White
Write-Host ".\stats.ps1" -ForegroundColor Cyan
Write-Host ""

# 如果指定了建立 GitHub Discussions
if ($CreateGitHubDiscussions) {
    Write-Host "==================================" -ForegroundColor Cyan
    Write-Host "GitHub Discussions 設置" -ForegroundColor Cyan
    Write-Host "==================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "請前往 GitHub 儲存庫設置啟用 Discussions:" -ForegroundColor Yellow
    Write-Host "1. 前往儲存庫設置頁面" -ForegroundColor White
    Write-Host "2. 在 Features 區塊勾選 'Discussions'" -ForegroundColor White
    Write-Host "3. 建立討論分類對應本地結構" -ForegroundColor White
    Write-Host ""
}

Write-Host "🎉 完成！祝您團隊協作順利！" -ForegroundColor Green
Write-Host ""
