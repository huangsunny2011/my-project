# ai-agent.ps1 - AI 代理脚本
# 用途：监控 AI 任务，自动打开并提示用户让 Copilot 处理

param(
    [string]$DeviceName = $env:COMPUTERNAME,
    [int]$CheckIntervalMinutes = 3
)

$aiWorkspace = "ai-workspace"

# 初始化工作区
function Initialize-AIWorkspace {
    $dirs = @(
        "$aiWorkspace",
        "$aiWorkspace/tasks",
        "$aiWorkspace/conversations",
        "$aiWorkspace/plans",
        "$aiWorkspace/code-reviews",
        "$aiWorkspace/decisions"
    )

    foreach ($dir in $dirs) {
        if (-not (Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
        }
    }

    # 创建 README
    if (-not (Test-Path "$aiWorkspace/README.md")) {
        $readme = @"
# AI 协作工作区

这是 AI 代理的工作区，用于多设备 AI 协作。

## 目录结构

- **tasks/** - AI 任务（pending/working/review/done）
- **conversations/** - AI 之间的对话
- **plans/** - AI 生成的工作计划
- **code-reviews/** - AI 代码审查记录
- **decisions/** - AI 决策记录

## 使用方法

1. 创建任务：``.\create-ai-task.ps1 -Title "任务标题" -Description "详细描述"``
2. 启动代理：``.\ai-agent.ps1 -DeviceName "你的设备名"``
3. 等待 AI 代理发现任务
4. 使用 Copilot (Ctrl+I) 完成任务

## 协作流程

```
用户创建任务 → AI代理检测 → Copilot 处理 → 推送 GitHub
                                                   ↓
其他设备 AI代理 ← Git Pull ← GitHub ← 循环协作
```
"@
        Set-Content -Path "$aiWorkspace/README.md" -Value $readme -Encoding UTF8
    }
}

# 创建 AI 提示
function Create-AIPrompt {
    param(
        [string]$TaskFile,
        [string]$TaskContent
    )

    $taskName = Split-Path -Leaf $TaskFile
    $promptFile = "$aiWorkspace/.ai-prompt-$DeviceName.md"

    $prompt = @"
# 🤖 AI 任务通知

**设备**: $DeviceName
**时间**: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
**任务文件**: ``$taskName``

---

## 📋 任务内容

$TaskContent

---

## 🎯 你的任务（给 AI Copilot）

1. **阅读并理解任务**
   - 理解用户需求
   - 查看其他 AI 的工作记录
   - 了解当前进度

2. **执行工作**
   根据任务状态：

   **如果是新任务（PENDING）**：
   - 分析需求并分解任务
   - 生成工作计划
   - 提出需要讨论的问题
   - 开始实现第一部分

   **如果有其他 AI 的问题**：
   - 回答问题
   - 提供技术建议
   - 继续实现代码

   **如果需要审查（REVIEW）**：
   - 审查代码质量
   - 提出改进建议
   - 指出问题

   **如果需要继续工作（WORKING）**：
   - 读取前一个 AI 的工作
   - 继续实现剩余部分
   - 更新进度

3. **更新任务文件**
   在 ``$taskName`` 末尾追加：

   ``````markdown
   ### [$DeviceName AI] - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')

   **我的工作**：
   [描述你做了什么]

   **创建的文件**：
   - file1.js
   - file2.js

   **遇到的问题**：
   [如果有问题，描述并 @其他AI]

   **下一步**：
   [建议下一步做什么]
   ``````

4. **提交更改**
   完成后运行：
   ``````powershell
   git add .
   git commit -m "ai: $DeviceName 完成任务 $taskName"
   git push origin main
   ``````

---

## 💡 AI 协作提示

- 使用 ``@设备名-AI`` 来询问其他 AI
- 遇到技术决策时，在 conversations/ 创建讨论
- 完成代码后，更新状态为 REVIEW
- 所有决策记录在 decisions/ 目录

---

## 🚀 立即开始

按 **Ctrl+I** 打开 GitHub Copilot Chat，然后说：

**"请阅读 @$promptFile 和 @$TaskFile，然后按照指示完成任务"**

---

✨ AI 协作，让编程更智能！
"@

    Set-Content -Path $promptFile -Value $prompt -Encoding UTF8
    return $promptFile
}

# 主程序
Clear-Host
Write-Host "`n"
Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║            🤖 AI 代理已启动                              ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Write-Host "  🖥️  设备名称: " -NoNewline -ForegroundColor Yellow
Write-Host $DeviceName -ForegroundColor White
Write-Host "  ⏱️  检查间隔: " -NoNewline -ForegroundColor Yellow
Write-Host "每 $CheckIntervalMinutes 分钟" -ForegroundColor White
Write-Host "  📂 工作区: " -NoNewline -ForegroundColor Yellow
Write-Host $aiWorkspace -ForegroundColor White
Write-Host ""
Write-Host "  💡 AI 代理会自动检测任务并打开文件" -ForegroundColor Cyan
Write-Host "  💡 看到提示后，用 Ctrl+I 让 Copilot 完成任务" -ForegroundColor Cyan
Write-Host "  ⌨️  按 Ctrl+C 停止代理" -ForegroundColor Gray
Write-Host ""

# 初始化
Initialize-AIWorkspace

# 记录检查时间
$lastCheckFile = "$aiWorkspace/.last-check-$DeviceName"

# 主循环
$iteration = 0
while ($true) {
    $iteration++
    $timestamp = Get-Date -Format "HH:mm:ss"

    Write-Host "[$timestamp] " -NoNewline -ForegroundColor Gray
    Write-Host "🔄 第 $iteration 次检查..." -ForegroundColor Cyan

    try {
        # 1. 同步最新内容
        Write-Host "  📥 同步 GitHub..." -NoNewline
        $gitResult = git pull origin main --quiet 2>&1

        if ($LASTEXITCODE -eq 0) {
            Write-Host " ✓" -ForegroundColor Green
        } else {
            Write-Host " ⚠️" -ForegroundColor Yellow
        }

        # 2. 检查待处理任务
        $pendingTasks = Get-ChildItem "$aiWorkspace/tasks/*-pending.md" -ErrorAction SilentlyContinue

        if ($pendingTasks) {
            Write-Host ""
            Write-Host "  🎯 发现 $($pendingTasks.Count) 个待处理任务！" -ForegroundColor Yellow
            Write-Host ""

            foreach ($task in $pendingTasks) {
                $taskName = $task.Name
                Write-Host "  📋 任务: " -NoNewline -ForegroundColor Cyan
                Write-Host $taskName -ForegroundColor White

                # 读取任务内容
                $content = Get-Content $task.FullName -Raw

                # 检查是否已被认领
                if ($content -match "\[$DeviceName AI\]") {
                    Write-Host "     ✓ 你已在处理此任务" -ForegroundColor Gray
                    continue
                }

                # 创建 AI 提示
                Write-Host "     🤖 生成 AI 提示..." -NoNewline
                $promptFile = Create-AIPrompt -TaskFile $task.FullName -TaskContent $content
                Write-Host " ✓" -ForegroundColor Green

                # 打开文件
                Write-Host "     📂 打开文件..." -NoNewline
                Start-Process code -ArgumentList $task.FullName
                Start-Sleep -Milliseconds 500
                Start-Process code -ArgumentList $promptFile
                Write-Host " ✓" -ForegroundColor Green

                Write-Host ""
                Write-Host "  ⭐ " -NoNewline -ForegroundColor Yellow
                Write-Host "请在 VSCode 中按 " -NoNewline -ForegroundColor White
                Write-Host "Ctrl+I" -NoNewline -ForegroundColor Cyan
                Write-Host " 打开 Copilot，然后说：" -ForegroundColor White
                Write-Host "     " -NoNewline
                Write-Host '"请阅读 ' -NoNewline -ForegroundColor Gray
                Write-Host "@.ai-prompt-$DeviceName.md" -NoNewline -ForegroundColor Yellow
                Write-Host ' 和 ' -NoNewline -ForegroundColor Gray
                Write-Host "@$taskName" -NoNewline -ForegroundColor Yellow
                Write-Host '，完成任务"' -ForegroundColor Gray
                Write-Host ""
            }
        }

        # 3. 检查需要审查的任务
        $reviewTasks = Get-ChildItem "$aiWorkspace/tasks/*-review.md" -ErrorAction SilentlyContinue

        if ($reviewTasks) {
            Write-Host ""
            Write-Host "  🔍 发现 $($reviewTasks.Count) 个需要审查的任务" -ForegroundColor Magenta

            foreach ($task in $reviewTasks) {
                Write-Host "     - $($task.Name)" -ForegroundColor White
                Start-Process code -ArgumentList $task.FullName
            }
            Write-Host ""
        }

        # 4. 检查进行中的任务
        $workingTasks = Get-ChildItem "$aiWorkspace/tasks/*-working.md" -ErrorAction SilentlyContinue

        if ($workingTasks) {
            Write-Host "  ⚙️  进行中: $($workingTasks.Count) 个任务" -ForegroundColor Cyan
        }

        # 5. 检查新对话
        if (Test-Path $lastCheckFile) {
            $lastCheck = Get-Date (Get-Content $lastCheckFile)
            $newConvs = Get-ChildItem "$aiWorkspace/conversations/*.md" -ErrorAction SilentlyContinue |
                Where-Object { $_.LastWriteTime -gt $lastCheck }

            if ($newConvs) {
                Write-Host ""
                Write-Host "  💬 新的 AI 对话:" -ForegroundColor Magenta
                foreach ($conv in $newConvs) {
                    Write-Host "     - $($conv.Name)" -ForegroundColor White
                }
            }
        }

        # 更新检查时间
        Get-Date -Format "o" | Set-Content $lastCheckFile

    } catch {
        Write-Host "  ❌ 错误: $_" -ForegroundColor Red
    }

    # 等待
    $nextCheck = (Get-Date).AddMinutes($CheckIntervalMinutes).ToString("HH:mm")
    Write-Host ""
    Write-Host "  😴 下次检查: $nextCheck" -ForegroundColor Gray
    Write-Host "  " -NoNewline
    Write-Host ("─" * 60) -ForegroundColor DarkGray
    Write-Host ""

    Start-Sleep -Seconds ($CheckIntervalMinutes * 60)
}
