# auto-sync.ps1 - 自动 Git 同步脚本
# 用途：自动拉取和推送 Git 仓库更改，实现多设备协作

param(
    [int]$IntervalMinutes = 5,  # 同步间隔（分钟）
    [string]$DeviceName = $env:COMPUTERNAME  # 设备名称
)

$projectPath = $PSScriptRoot  # 使用脚本所在目录
if (-not $projectPath) {
    $projectPath = Get-Location
}

Set-Location $projectPath

Write-Host "`n" -NoNewline
Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║         🔄 Git 自动同步已启动                            ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Write-Host "  📂 项目路径: " -NoNewline -ForegroundColor Yellow
Write-Host $projectPath -ForegroundColor White
Write-Host "  💻 设备名称: " -NoNewline -ForegroundColor Yellow
Write-Host $DeviceName -ForegroundColor White
Write-Host "  ⏱️  同步间隔: " -NoNewline -ForegroundColor Yellow
Write-Host "每 $IntervalMinutes 分钟" -ForegroundColor White
Write-Host ""
Write-Host "  ⌨️  按 Ctrl+C 停止同步" -ForegroundColor Gray
Write-Host ""

while ($true) {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    
    try {
        # 1. 拉取远程更新
        Write-Host "[$timestamp] " -NoNewline -ForegroundColor Gray
        Write-Host "🔽 检查远程更新..." -NoNewline -ForegroundColor Cyan
        
        $pullResult = git pull origin main --no-edit 2>&1
        
        if ($LASTEXITCODE -ne 0) {
            Write-Host " ❌" -ForegroundColor Red
            Write-Host "  ⚠️  拉取失败: $pullResult" -ForegroundColor Red
        }
        elseif ($pullResult -match "Already up to date") {
            Write-Host " ✓" -ForegroundColor Gray
        }
        else {
            Write-Host " ✅" -ForegroundColor Green
            
            # 显示更新的文件
            $changedFiles = git diff --name-only HEAD@{1} HEAD
            $fileCount = ($changedFiles | Measure-Object -Line).Lines
            
            Write-Host "  🎉 收到远程更新！" -ForegroundColor Yellow
            Write-Host "  📝 更新了 $fileCount 个文件:" -ForegroundColor Cyan
            
            $changedFiles | ForEach-Object {
                Write-Host "     - $_" -ForegroundColor White
            }
            Write-Host ""
        }
        
        # 2. 检查本地变化
        $status = git status --porcelain
        
        if ($status) {
            $timestamp2 = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            Write-Host "[$timestamp2] " -NoNewline -ForegroundColor Gray
            Write-Host "📝 检测到本地变化" -ForegroundColor Yellow
            
            # 显示变化的文件
            $changedFiles = $status | ForEach-Object { $_.Substring(3) }
            $changeCount = ($changedFiles | Measure-Object).Count
            
            Write-Host "  📋 变化的文件 ($changeCount):" -ForegroundColor Cyan
            $changedFiles | Select-Object -First 5 | ForEach-Object {
                Write-Host "     - $_" -ForegroundColor White
            }
            
            if ($changeCount -gt 5) {
                Write-Host "     ... 还有 $($changeCount - 5) 个文件" -ForegroundColor Gray
            }
            
            # 自动提交
            git add . 2>&1 | Out-Null
            $commitMsg = "auto-sync: $DeviceName at $(Get-Date -Format 'HH:mm:ss')"
            git commit -m $commitMsg 2>&1 | Out-Null
            
            Write-Host "  💾 已自动提交" -ForegroundColor Green
            
            # 推送到远程
            Write-Host "  🔼 推送到 GitHub..." -NoNewline -ForegroundColor Cyan
            
            $pushResult = git push origin main 2>&1
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host " ✅" -ForegroundColor Green
                Write-Host "  🎊 成功！其他设备将在下次同步时收到更新" -ForegroundColor Green
            }
            else {
                Write-Host " ❌" -ForegroundColor Red
                Write-Host "  ⚠️  推送失败: $pushResult" -ForegroundColor Red
                Write-Host "  💡 可能有冲突，请手动检查" -ForegroundColor Yellow
            }
            
            Write-Host ""
        }
        
    }
    catch {
        Write-Host "[$timestamp] ❌ 同步出错: $_" -ForegroundColor Red
    }
    
    # 等待下一个周期
    $nextSync = (Get-Date).AddMinutes($IntervalMinutes).ToString("HH:mm:ss")
    Write-Host "[$timestamp] " -NoNewline -ForegroundColor Gray
    Write-Host "😴 下次同步时间: $nextSync" -ForegroundColor Gray
    Write-Host ""
    
    Start-Sleep -Seconds ($IntervalMinutes * 60)
}
