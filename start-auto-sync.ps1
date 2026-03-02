# start-auto-sync.ps1 - 启动自动同步的便捷脚本
# 用途：提供简单的菜单选择不同的同步方式

param(
    [string]$DeviceName = $env:COMPUTERNAME
)

function Show-Menu {
    Clear-Host
    Write-Host "`n"
    Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║              🚀 Git 自动同步启动器                      ║" -ForegroundColor Cyan
    Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  当前设备: " -NoNewline
    Write-Host $DeviceName -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  请选择同步方式:" -ForegroundColor White
    Write-Host ""
    Write-Host "  [1] 定时自动同步 (每 5 分钟)" -ForegroundColor Green
    Write-Host "      适合日常协作，平衡性能和实时性" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  [2] 快速同步 (每 3 分钟)" -ForegroundColor Green
    Write-Host "      更频繁的同步，适合紧密协作" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  [3] 实时监控同步" -ForegroundColor Green
    Write-Host "      监控文件变化立即同步（10秒防抖）" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  [4] 后台运行定时同步" -ForegroundColor Green
    Write-Host "      在后台窗口运行，不干扰工作" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  [5] 仅拉取一次更新" -ForegroundColor Cyan
    Write-Host "      手动同步，不持续运行" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  [6] 查看同步状态" -ForegroundColor Cyan
    Write-Host "      检查是否有运行中的同步进程" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  [Q] 退出" -ForegroundColor Red
    Write-Host ""
    Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""
}

function Start-ManualSync {
    Write-Host "`n🔄 手动同步中..." -ForegroundColor Cyan

    # 拉取更新
    Write-Host "  📥 拉取远程更新..." -NoNewline
    $pullResult = git pull origin main --no-edit 2>&1

    if ($LASTEXITCODE -eq 0) {
        Write-Host " ✅" -ForegroundColor Green

        if ($pullResult -notmatch "Already up to date") {
            $files = git diff --name-only HEAD@{1} HEAD
            $count = ($files | Measure-Object -Line).Lines
            Write-Host "  📝 更新了 $count 个文件" -ForegroundColor Yellow
        }
        else {
            Write-Host "  ✓ 已是最新版本" -ForegroundColor Gray
        }
    }
    else {
        Write-Host " ❌" -ForegroundColor Red
        Write-Host "  错误: $pullResult" -ForegroundColor Red
    }

    # 检查本地变化
    $status = git status --porcelain
    if ($status) {
        $count = ($status | Measure-Object -Line).Lines
        Write-Host "`n  📝 发现 $count 个本地变化" -ForegroundColor Yellow
        Write-Host "  是否提交并推送? [Y/N]: " -NoNewline -ForegroundColor Cyan

        $response = Read-Host
        if ($response -eq 'Y' -or $response -eq 'y') {
            git add .
            $commitMsg = "manual-sync: $DeviceName at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
            git commit -m $commitMsg

            Write-Host "  🔼 推送到 GitHub..." -NoNewline
            git push origin main 2>&1 | Out-Null

            if ($LASTEXITCODE -eq 0) {
                Write-Host " ✅" -ForegroundColor Green
            }
            else {
                Write-Host " ❌" -ForegroundColor Red
            }
        }
    }
    else {
        Write-Host "  ✓ 无本地变化" -ForegroundColor Gray
    }

    Write-Host "`n✅ 同步完成！" -ForegroundColor Green
    Write-Host "`n按任意键返回菜单..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Show-SyncStatus {
    Write-Host "`n📊 检查同步进程状态..." -ForegroundColor Cyan
    Write-Host ""

    # 检查是否有 auto-sync 进程
    $syncProcesses = Get-Process powershell -ErrorAction SilentlyContinue |
        Where-Object { $_.CommandLine -like "*auto-sync.ps1*" -or $_.CommandLine -like "*watch-sync.ps1*" }

    if ($syncProcesses) {
        Write-Host "  ✅ 发现运行中的同步进程:" -ForegroundColor Green
        $syncProcesses | ForEach-Object {
            Write-Host "     - 进程 ID: $($_.Id)" -ForegroundColor White
            Write-Host "       启动时间: $($_.StartTime)" -ForegroundColor Gray
        }

        Write-Host "`n  是否停止这些进程? [Y/N]: " -NoNewline -ForegroundColor Yellow
        $response = Read-Host

        if ($response -eq 'Y' -or $response -eq 'y') {
            $syncProcesses | Stop-Process -Force
            Write-Host "  ✓ 已停止同步进程" -ForegroundColor Green
        }
    }
    else {
        Write-Host "  ℹ️  没有运行中的同步进程" -ForegroundColor Gray
    }

    # 显示 Git 状态
    Write-Host "`n  Git 仓库状态:" -ForegroundColor Cyan
    git status --short

    Write-Host "`n  最近的提交:" -ForegroundColor Cyan
    git log --oneline -5

    Write-Host "`n按任意键返回菜单..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

# 主循环
while ($true) {
    Show-Menu

    $choice = Read-Host "请选择"

    switch ($choice.ToUpper()) {
        '1' {
            Write-Host "`n启动定时同步（每 5 分钟）..." -ForegroundColor Green
            Write-Host "按 Ctrl+C 可以停止`n" -ForegroundColor Yellow
            & "$PSScriptRoot\auto-sync.ps1" -IntervalMinutes 5 -DeviceName $DeviceName
        }
        '2' {
            Write-Host "`n启动快速同步（每 3 分钟）..." -ForegroundColor Green
            Write-Host "按 Ctrl+C 可以停止`n" -ForegroundColor Yellow
            & "$PSScriptRoot\auto-sync.ps1" -IntervalMinutes 3 -DeviceName $DeviceName
        }
        '3' {
            Write-Host "`n启动实时监控同步..." -ForegroundColor Green
            Write-Host "按 Ctrl+C 可以停止`n" -ForegroundColor Yellow
            & "$PSScriptRoot\watch-sync.ps1" -DeviceName $DeviceName -DebounceSeconds 10
        }
        '4' {
            Write-Host "`n启动后台同步..." -ForegroundColor Green
            Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `"$PSScriptRoot\auto-sync.ps1`" -IntervalMinutes 5 -DeviceName `"$DeviceName`"" -WindowStyle Normal
            Write-Host "✅ 已在新窗口启动后台同步" -ForegroundColor Green
            Write-Host "你可以最小化那个窗口" -ForegroundColor Cyan
            Write-Host "`n按任意键返回菜单..."
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }
        '5' {
            Start-ManualSync
        }
        '6' {
            Show-SyncStatus
        }
        'Q' {
            Write-Host "`n再见！👋`n" -ForegroundColor Cyan
            exit
        }
        default {
            Write-Host "`n⚠️  无效选择，请重试" -ForegroundColor Red
            Start-Sleep -Seconds 1
        }
    }
}
