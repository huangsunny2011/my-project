# ai-dashboard.ps1 - AI 协作仪表板
# 用途：监控和管理 AI 协作任务

$aiWorkspace = "ai-workspace"

function Show-Dashboard {
    Clear-Host
    Write-Host "`n"
    Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║              🤖 AI 协作仪表板                            ║" -ForegroundColor Cyan
    Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  ⏰ $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray
    Write-Host ""
    
    # 检查工作区
    if (-not (Test-Path $aiWorkspace)) {
        Write-Host "  ⚠️  AI 工作区不存在" -ForegroundColor Yellow
        Write-Host "  💡 运行 .\ai-agent.ps1 来初始化" -ForegroundColor Cyan
        return
    }
    
    # 1. 任务统计
    Write-Host "  📊 任务统计" -ForegroundColor Yellow
    Write-Host "  " -NoNewline
    Write-Host ("─" * 60) -ForegroundColor DarkGray
    Write-Host ""
    
    $pending = @(Get-ChildItem "$aiWorkspace/tasks/*-pending.md" -ErrorAction SilentlyContinue).Count
    $working = @(Get-ChildItem "$aiWorkspace/tasks/*-working.md" -ErrorAction SilentlyContinue).Count
    $review = @(Get-ChildItem "$aiWorkspace/tasks/*-review.md" -ErrorAction SilentlyContinue).Count
    $done = @(Get-ChildItem "$aiWorkspace/tasks/*-done.md" -ErrorAction SilentlyContinue).Count
    $total = $pending + $working + $review + $done
    
    Write-Host "     🟡 待处理   : " -NoNewline
    Write-Host $pending.ToString().PadLeft(3) -ForegroundColor Yellow
    
    Write-Host "     🔵 进行中   : " -NoNewline
    Write-Host $working.ToString().PadLeft(3) -ForegroundColor Cyan
    
    Write-Host "     🟣 待审查   : " -NoNewline
    Write-Host $review.ToString().PadLeft(3) -ForegroundColor Magenta
    
    Write-Host "     🟢 已完成   : " -NoNewline
    Write-Host $done.ToString().PadLeft(3) -ForegroundColor Green
    
    Write-Host "     ━━━━━━━━━━━━━" -ForegroundColor DarkGray
    Write-Host "     📈 总计     : " -NoNewline
    Write-Host $total.ToString().PadLeft(3) -ForegroundColor White
    Write-Host ""
    
    # 2. 最近任务
    Write-Host "  📋 最近任务" -ForegroundColor Yellow
    Write-Host "  " -NoNewline
    Write-Host ("─" * 60) -ForegroundColor DarkGray
    Write-Host ""
    
    $recentTasks = Get-ChildItem "$aiWorkspace/tasks/*.md" -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 5
    
    if ($recentTasks) {
        foreach ($task in $recentTasks) {
            $status = switch -Regex ($task.Name) {
                "-pending.md" { "🟡 待处理"; break }
                "-working.md" { "🔵 进行中"; break }
                "-review.md"  { "🟣 待审查"; break }
                "-done.md"    { "🟢 已完成"; break }
                default       { "⚪ 未知" }
            }
            
            $title = ""
            $content = Get-Content $task.FullName -Raw
            if ($content -match '# Task #\d+ : (.+)') {
                $title = $Matches[1]
            }
            
            $time = $task.LastWriteTime.ToString("MM-dd HH:mm")
            
            Write-Host "     $status  " -NoNewline
            Write-Host $title.Substring(0, [Math]::Min($title.Length, 35)).PadRight(35) -NoNewline -ForegroundColor White
            Write-Host "  $time" -ForegroundColor Gray
        }
    } else {
        Write-Host "     暂无任务" -ForegroundColor Gray
    }
    Write-Host ""
    
    # 3. AI 活跃度
    Write-Host "  🤖 AI 活跃度（最近工作）" -ForegroundColor Yellow
    Write-Host "  " -NoNewline
    Write-Host ("─" * 60) -ForegroundColor DarkGray
    Write-Host ""
    
    $allTasks = Get-ChildItem "$aiWorkspace/tasks/*.md" -ErrorAction SilentlyContinue
    $aiActivity = @{}
    
    foreach ($task in $allTasks) {
        $content = Get-Content $task.FullName -Raw
        $matches = [regex]::Matches($content, '\[(.+?) AI\]')
        
        foreach ($match in $matches) {
            $aiName = $match.Groups[1].Value
            if ($aiActivity.ContainsKey($aiName)) {
                $aiActivity[$aiName]++
            } else {
                $aiActivity[$aiName] = 1
            }
        }
    }
    
    if ($aiActivity.Count -gt 0) {
        $maxCount = ($aiActivity.Values | Measure-Object -Maximum).Maximum
        
        foreach ($ai in $aiActivity.Keys | Sort-Object -Descending { $aiActivity[$_] }) {
            $count = $aiActivity[$ai]
            $barLength = [Math]::Ceiling(($count / $maxCount) * 30)
            $bar = "█" * $barLength
            
            Write-Host "     $($ai.PadRight(15)): " -NoNewline -ForegroundColor Cyan
            Write-Host $bar -NoNewline -ForegroundColor Green
            Write-Host " $count" -ForegroundColor White
        }
    } else {
        Write-Host "     暂无 AI 活动记录" -ForegroundColor Gray
    }
    Write-Host ""
    
    # 4. 对话统计
    Write-Host "  💬 AI 对话" -ForegroundColor Yellow
    Write-Host "  " -NoNewline
    Write-Host ("─" * 60) -ForegroundColor DarkGray
    Write-Host ""
    
    $conversations = @(Get-ChildItem "$aiWorkspace/conversations/*.md" -ErrorAction SilentlyContinue).Count
    $plans = @(Get-ChildItem "$aiWorkspace/plans/*.md" -ErrorAction SilentlyContinue).Count
    $reviews = @(Get-ChildItem "$aiWorkspace/code-reviews/*.md" -ErrorAction SilentlyContinue).Count
    $decisions = @(Get-ChildItem "$aiWorkspace/decisions/*.md" -ErrorAction SilentlyContinue).Count
    
    Write-Host "     💬 对话记录  : $conversations" -ForegroundColor White
    Write-Host "     📝 工作计划  : $plans" -ForegroundColor White
    Write-Host "     🔍 代码审查  : $reviews" -ForegroundColor White
    Write-Host "     ✅ 决策记录  : $decisions" -ForegroundColor White
    Write-Host ""
    
    # 5. Git 状态
    Write-Host "  🔄 Git 同步状态" -ForegroundColor Yellow
    Write-Host "  " -NoNewline
    Write-Host ("─" * 60) -ForegroundColor DarkGray
    Write-Host ""
    
    $gitStatus = git status --porcelain 2>&1
    if ($LASTEXITCODE -eq 0) {
        if ($gitStatus) {
            $changes = ($gitStatus | Measure-Object -Line).Lines
            Write-Host "     ⚠️  有 $changes 个未提交的变化" -ForegroundColor Yellow
        } else {
            Write-Host "     ✅ 工作区干净" -ForegroundColor Green
        }
        
        $branch = git branch --show-current
        Write-Host "     🌿 分支: $branch" -ForegroundColor Cyan
        
        # 检查远程更新
        git fetch origin main --quiet 2>&1 | Out-Null
        $behind = git rev-list --count HEAD..origin/main 2>&1
        $ahead = git rev-list --count origin/main..HEAD 2>&1
        
        if ($behind -and $behind -match '^\d+$' -and [int]$behind -gt 0) {
            Write-Host "     📥 落后远程 $behind 个提交" -ForegroundColor Yellow
        }
        
        if ($ahead -and $ahead -match '^\d+$' -and [int]$ahead -gt 0) {
            Write-Host "     📤 领先远程 $ahead 个提交" -ForegroundColor Cyan
        }
        
        if ((-not $behind -or $behind -eq '0') -and (-not $ahead -or $ahead -eq '0')) {
            Write-Host "     ✅ 与远程同步" -ForegroundColor Green
        }
    } else {
        Write-Host "     ⚠️  无法获取 Git 状态" -ForegroundColor Yellow
    }
    Write-Host ""
}

function Show-Menu {
    Write-Host "  📌 操作菜单" -ForegroundColor Yellow
    Write-Host "  " -NoNewline
    Write-Host ("─" * 60) -ForegroundColor DarkGray
    Write-Host ""
    Write-Host "     [1] 创建新任务        [5] 查看对话" -ForegroundColor White
    Write-Host "     [2] 查看所有任务      [6] Git 同步" -ForegroundColor White
    Write-Host "     [3] 启动 AI 代理      [7] 打开工作区" -ForegroundColor White
    Write-Host "     [4] 查看进行中任务    [R] 刷新" -ForegroundColor White
    Write-Host ""
    Write-Host "     [Q] 退出" -ForegroundColor Red
    Write-Host ""
}

# 主循环
while ($true) {
    Show-Dashboard
    Show-Menu
    
    $choice = Read-Host "  请选择"
    
    switch ($choice.ToUpper()) {
        '1' {
            $title = Read-Host "`n  任务标题"
            $desc = Read-Host "  任务描述"
            Write-Host ""
            & "$PSScriptRoot\create-ai-task.ps1" -Title $title -Description $desc
            Write-Host "`n  按任意键继续..."
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }
        
        '2' {
            Clear-Host
            Write-Host "`n  📋 所有任务" -ForegroundColor Yellow
            Write-Host ""
            
            $allTasks = Get-ChildItem "$aiWorkspace/tasks/*.md" -ErrorAction SilentlyContinue |
                Sort-Object Name
            
            if ($allTasks) {
                foreach ($task in $allTasks) {
                    $status = switch -Regex ($task.Name) {
                        "-pending.md" { "🟡"; break }
                        "-working.md" { "🔵"; break }
                        "-review.md"  { "🟣"; break }
                        "-done.md"    { "🟢"; break }
                        default       { "⚪" }
                    }
                    
                    Write-Host "  $status $($task.Name)" -ForegroundColor White
                }
            } else {
                Write-Host "  暂无任务" -ForegroundColor Gray
            }
            
            Write-Host "`n  按任意键继续..."
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }
        
        '3' {
            $deviceName = Read-Host "`n  输入设备名称（默认: $env:COMPUTERNAME）"
            if (-not $deviceName) {
                $deviceName = $env:COMPUTERNAME
            }
            
            Write-Host "`n  🚀 启动 AI 代理..." -ForegroundColor Green
            Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `"$PSScriptRoot\ai-agent.ps1`" -DeviceName `"$deviceName`""
            
            Write-Host "  ✅ AI 代理已在新窗口启动" -ForegroundColor Green
            Start-Sleep -Seconds 2
        }
        
        '4' {
            Clear-Host
            Write-Host "`n  🔵 进行中的任务" -ForegroundColor Cyan
            Write-Host ""
            
            $workingTasks = Get-ChildItem "$aiWorkspace/tasks/*-working.md" -ErrorAction SilentlyContinue
            
            if ($workingTasks) {
                foreach ($task in $workingTasks) {
                    Write-Host "  📋 $($task.Name)" -ForegroundColor White
                    Start-Process code -ArgumentList $task.FullName
                }
                Write-Host "`n  ✅ 已在 VSCode 中打开" -ForegroundColor Green
            } else {
                Write-Host "  暂无进行中的任务" -ForegroundColor Gray
            }
            
            Write-Host "`n  按任意键继续..."
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }
        
        '5' {
            Clear-Host
            Write-Host "`n  💬 AI 对话" -ForegroundColor Magenta
            Write-Host ""
            
            $convs = Get-ChildItem "$aiWorkspace/conversations/*.md" -ErrorAction SilentlyContinue
            
            if ($convs) {
                foreach ($conv in $convs) {
                    Write-Host "  💬 $($conv.Name)" -ForegroundColor White
                }
            } else {
                Write-Host "  暂无对话记录" -ForegroundColor Gray
            }
            
            Write-Host "`n  按任意键继续..."
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }
        
        '6' {
            Write-Host "`n  🔄 Git 同步..." -ForegroundColor Cyan
            
            Write-Host "  📥 拉取更新..." -NoNewline
            git pull origin main 2>&1 | Out-Null
            Write-Host " ✓" -ForegroundColor Green
            
            $status = git status --porcelain
            if ($status) {
                Write-Host "  📤 推送更改..." -NoNewline
                git add .
                git commit -m "chore: 同步 AI 工作区"
                git push origin main 2>&1 | Out-Null
                Write-Host " ✓" -ForegroundColor Green
            }
            
            Write-Host "  ✅ 同步完成" -ForegroundColor Green
            Start-Sleep -Seconds 2
        }
        
        '7' {
            Write-Host "`n  📂 打开工作区..." -ForegroundColor Cyan
            Start-Process explorer $aiWorkspace
            Start-Sleep -Seconds 1
        }
        
        'R' {
            # 刷新，继续循环
        }
        
        'Q' {
            Write-Host "`n  👋 再见！`n" -ForegroundColor Cyan
            exit
        }
        
        default {
            Write-Host "`n  ⚠️  无效选择" -ForegroundColor Red
            Start-Sleep -Seconds 1
        }
    }
}
