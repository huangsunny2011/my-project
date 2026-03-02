# create-ai-task.ps1 - 创建 AI 任务
# 用途：创建一个新的 AI 协作任务

param(
    [Parameter(Mandatory=$true)]
    [string]$Title,

    [Parameter(Mandatory=$true)]
    [string]$Description,

    [string]$Priority = "NORMAL",  # LOW / NORMAL / HIGH / URGENT

    [string[]]$Tags = @(),

    [switch]$NoPush  # 不自动推送到 GitHub
)

$aiWorkspace = "ai-workspace"
$tasksDir = "$aiWorkspace/tasks"

# 确保目录存在
if (-not (Test-Path $tasksDir)) {
    New-Item -ItemType Directory -Path $tasksDir -Force | Out-Null
}

# 生成任务 ID
$existingTasks = Get-ChildItem "$tasksDir/task-*.md" -ErrorAction SilentlyContinue
$taskNumber = ($existingTasks.Count + 1).ToString("000")
$taskFile = "$tasksDir/task-$taskNumber-pending.md"

# 优先级图标
$priorityIcon = switch ($Priority) {
    "LOW"    { "🟢" }
    "NORMAL" { "🟡" }
    "HIGH"   { "🟠" }
    "URGENT" { "🔴" }
    default  { "🟡" }
}

# 标签字符串
$tagsStr = if ($Tags.Count -gt 0) {
    ($Tags | ForEach-Object { "``$_``" }) -join ", "
} else {
    "_无标签_"
}

# 创建任务内容
$content = @"
# Task #$taskNumber : $Title

## 📊 元数据

| 属性 | 值 |
|------|-----|
| **状态** | 🟡 PENDING |
| **优先级** | $priorityIcon $Priority |
| **创建时间** | $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') |
| **创建者** | 用户 |
| **当前负责设备** | _待认领_ |
| **标签** | $tagsStr |

---

## 📋 任务描述

$Description

---

## 🎯 期望结果

> 💡 **给第一个接手任务的 AI**：请在这里描述期望的最终结果

_待 AI 完善..._

---

## 📝 技术要求

> 💡 如有特定技术栈或实现要求，请在这里说明

_待补充..._

---

## ✅ 验收标准

> 💡 如何判断任务完成？

_待定义..._

---

## 🤖 AI 协作记录

> **协作规则**：
> - 每个 AI 追加记录时使用格式：``### [设备名 AI] - 时间``
> - 使用 ``@设备名-AI`` 来询问其他 AI
> - 完成阶段性工作后更新任务状态
> - 需要讨论时创建 conversations/ 文件

---

### 等待 AI 认领...

💡 **下一步**：
1. 在各设备运行 ``.\ai-agent.ps1``
2. AI 代理会自动发现此任务
3. 使用 Copilot 完成任务
4. AI 们通过此文件协作

---

<details>
<summary>📚 AI 协作指南</summary>

### 任务状态流转

\`\`\`
PENDING → WORKING → REVIEW → DONE
   ↓         ↓         ↓        ↓
 待认领    进行中    待审查   已完成
\`\`\`

### AI 工作示例

\`\`\`markdown
### [Desktop AI] - 2026-03-02 10:00:00

✅ **我已认领此任务**

**需求分析**：
1. 需要实现 X 功能
2. 需要 Y 技术栈
3. 预估工作量：Z 小时

**技术方案**：
- 使用 A 框架
- 数据库：B
- API：C

**待讨论问题**：
@Laptop-AI 你觉得使用 Redux 还是 Context API？

**状态更新**: PENDING → WORKING
\`\`\`

### 文件命名规则

- ``task-XXX-pending.md`` - 待处理
- ``task-XXX-working.md`` - 进行中
- ``task-XXX-review.md`` - 待审查
- ``task-XXX-done.md`` - 已完成

改变状态时请重命名文件！

</details>

---

_Created by AI Task System v1.0_
"@

# 保存任务文件
Set-Content -Path $taskFile -Value $content -Encoding UTF8

# 显示结果
Clear-Host
Write-Host "`n"
Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║            ✅ AI 任务创建成功！                          ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "  📋 任务信息" -ForegroundColor Yellow
Write-Host "  " -NoNewline
Write-Host ("─" * 60) -ForegroundColor DarkGray
Write-Host "  任务 ID    : " -NoNewline -ForegroundColor Cyan
Write-Host "#$taskNumber" -ForegroundColor White
Write-Host "  标题       : " -NoNewline -ForegroundColor Cyan
Write-Host $Title -ForegroundColor White
Write-Host "  优先级     : " -NoNewline -ForegroundColor Cyan
Write-Host "$priorityIcon $Priority" -ForegroundColor White
Write-Host "  文件       : " -NoNewline -ForegroundColor Cyan
Write-Host $taskFile -ForegroundColor White

if ($Tags.Count -gt 0) {
    Write-Host "  标签       : " -NoNewline -ForegroundColor Cyan
    Write-Host ($Tags -join ", ") -ForegroundColor White
}

Write-Host ""

# Git 操作
if (-not $NoPush) {
    Write-Host "  📤 推送到 GitHub" -ForegroundColor Yellow
    Write-Host "  " -NoNewline
    Write-Host ("─" * 60) -ForegroundColor DarkGray

    try {
        Write-Host "  🔄 添加文件..." -NoNewline
        git add $taskFile 2>&1 | Out-Null
        Write-Host " ✓" -ForegroundColor Green

        Write-Host "  💾 提交..." -NoNewline
        $commitMsg = "task: 创建任务 #$taskNumber - $Title"
        git commit -m $commitMsg 2>&1 | Out-Null
        Write-Host " ✓" -ForegroundColor Green

        Write-Host "  🚀 推送..." -NoNewline
        git push origin main 2>&1 | Out-Null

        if ($LASTEXITCODE -eq 0) {
            Write-Host " ✅" -ForegroundColor Green
            Write-Host ""
            Write-Host "  🎉 任务已成功推送到 GitHub！" -ForegroundColor Green
        } else {
            Write-Host " ⚠️" -ForegroundColor Yellow
            Write-Host ""
            Write-Host "  ⚠️  推送失败，请手动推送" -ForegroundColor Yellow
        }
    } catch {
        Write-Host " ❌" -ForegroundColor Red
        Write-Host "  错误: $_" -ForegroundColor Red
    }
} else {
    Write-Host "  ℹ️  跳过 GitHub 推送（使用了 -NoPush）" -ForegroundColor Gray
}

Write-Host ""
Write-Host "  🚀 下一步操作" -ForegroundColor Yellow
Write-Host "  " -NoNewline
Write-Host ("─" * 60) -ForegroundColor DarkGray
Write-Host ""
Write-Host "  1️⃣  在各设备上启动 AI 代理：" -ForegroundColor White
Write-Host "      " -NoNewline
Write-Host ".\ai-agent.ps1 -DeviceName " -NoNewline -ForegroundColor Cyan
Write-Host '"你的设备名"' -ForegroundColor Yellow
Write-Host ""
Write-Host "  2️⃣  AI 代理会自动发现并打开此任务" -ForegroundColor White
Write-Host ""
Write-Host "  3️⃣  在 VSCode 中按 " -NoNewline -ForegroundColor White
Write-Host "Ctrl+I" -NoNewline -ForegroundColor Cyan
Write-Host " 打开 Copilot，说：" -ForegroundColor White
Write-Host "      " -NoNewline
Write-Host '"请阅读任务文件并完成任务"' -ForegroundColor Gray
Write-Host ""
Write-Host "  4️⃣  AI 们会通过此文件自动协作！" -ForegroundColor White
Write-Host ""

# 打开任务文件
Write-Host "  📂 正在打开任务文件..." -ForegroundColor Cyan
Start-Process code -ArgumentList $taskFile
Start-Sleep -Milliseconds 500

Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║              🤖 AI 协作即将开始！                        ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# 显示任务预览
Write-Host "  📝 任务描述预览：" -ForegroundColor Yellow
Write-Host ""
$desc = $Description -split "`n" | Select-Object -First 3
foreach ($line in $desc) {
    Write-Host "     $line" -ForegroundColor Gray
}
if (($Description -split "`n").Count -gt 3) {
    Write-Host "     ..." -ForegroundColor DarkGray
}
Write-Host ""

# 返回任务文件路径
return $taskFile
