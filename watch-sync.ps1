# watch-sync.ps1 - 文件监控实时同步脚本
# 用途：监控文件变化，自动提交和推送到 Git

param(
    [string]$Path = $PSScriptRoot,
    [string]$DeviceName = $env:COMPUTERNAME,
    [int]$DebounceSeconds = 10  # 防抖时间（秒）
)

if (-not $Path) {
    $Path = Get-Location
}

Set-Location $Path

Write-Host "`n" -NoNewline
Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║       👁️  文件监控实时同步已启动                        ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "  📂 监控路径: " -NoNewline -ForegroundColor Yellow
Write-Host $Path -ForegroundColor White
Write-Host "  💻 设备名称: " -NoNewline -ForegroundColor Yellow
Write-Host $DeviceName -ForegroundColor White
Write-Host "  ⏱️  防抖时间: " -NoNewline -ForegroundColor Yellow
Write-Host "$DebounceSeconds 秒" -ForegroundColor White
Write-Host ""
Write-Host "  💡 保存文件后会自动同步到 GitHub" -ForegroundColor Cyan
Write-Host "  ⌨️  按 Ctrl+C 停止监控" -ForegroundColor Gray
Write-Host ""

# 排除不需要监控的目录
$excludeDirs = @('.git', 'node_modules', '.vscode', 'bin', 'obj', 'dist', 'build')

# 最后同步时间
$script:lastSyncTime = [DateTime]::MinValue
$script:pendingChanges = $false
$script:changedFiles = @{}

# 同步函数
function Sync-Repository {
    $now = Get-Date
    
    # 防抖：如果距离上次同步小于防抖时间，跳过
    if (($now - $script:lastSyncTime).TotalSeconds -lt $DebounceSeconds) {
        return
    }
    
    if (-not $script:pendingChanges) {
        return
    }
    
    $timestamp = Get-Date -Format "HH:mm:ss"
    
    try {
        # 先拉取（避免冲突）
        Write-Host "[$timestamp] " -NoNewline -ForegroundColor Gray
        Write-Host "🔄 开始同步..." -ForegroundColor Cyan
        
        git pull origin main --no-edit 2>&1 | Out-Null
        
        # 检查是否有变化
        $status = git status --porcelain
        if ($status) {
            $changeCount = ($status | Measure-Object -Line).Lines
            
            # 显示变化的文件
            Write-Host "  📝 发现 $changeCount 个变化:" -ForegroundColor Yellow
            $script:changedFiles.Keys | Select-Object -First 3 | ForEach-Object {
                Write-Host "     - $_" -ForegroundColor White
            }
            
            if ($script:changedFiles.Count -gt 3) {
                Write-Host "     ... 还有 $($script:changedFiles.Count - 3) 个文件" -ForegroundColor Gray
            }
            
            # 提交变化
            git add . 2>&1 | Out-Null
            $commitMsg = "auto: $DeviceName - $(Get-Date -Format 'HH:mm:ss')"
            git commit -m $commitMsg 2>&1 | Out-Null
            
            # 推送
            Write-Host "  🔼 推送中..." -NoNewline -ForegroundColor Cyan
            $pushResult = git push origin main 2>&1
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host " ✅" -ForegroundColor Green
                Write-Host "  🎉 成功同步到 GitHub！`n" -ForegroundColor Green
                
                $script:pendingChanges = $false
                $script:lastSyncTime = $now
                $script:changedFiles.Clear()
            }
            else {
                Write-Host " ❌" -ForegroundColor Red
                Write-Host "  ⚠️  推送失败: $pushResult`n" -ForegroundColor Yellow
            }
        }
    }
    catch {
        Write-Host "  ❌ 同步出错: $_`n" -ForegroundColor Red
    }
}

# 创建文件监控器
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $Path
$watcher.Filter = "*.*"
$watcher.IncludeSubdirectories = $true
$watcher.NotifyFilter = [System.IO.NotifyFilters]::LastWrite -bor 
                        [System.IO.NotifyFilters]::FileName -bor
                        [System.IO.NotifyFilters]::DirectoryName
$watcher.EnableRaisingEvents = $true

# 文件变化事件处理
$onChange = {
    param($sender, $e)
    
    # 检查是否在排除目录中
    $relativePath = $e.FullPath.Replace($Path, "").TrimStart('\', '/')
    $inExcluded = $false
    
    foreach ($dir in $excludeDirs) {
        if ($relativePath -like "$dir\*" -or $relativePath -like "$dir/*" -or $relativePath -eq $dir) {
            $inExcluded = $true
            break
        }
    }
    
    if (-not $inExcluded) {
        $timestamp = Get-Date -Format "HH:mm:ss"
        $fileName = Split-Path -Leaf $e.FullPath
        
        Write-Host "[$timestamp] " -NoNewline -ForegroundColor Gray
        Write-Host "📝 检测: " -NoNewline -ForegroundColor Yellow
        Write-Host $fileName -ForegroundColor White
        
        $script:pendingChanges = $true
        $script:changedFiles[$relativePath] = $true
    }
}

# 注册事件
$handlers = @()
$handlers += Register-ObjectEvent -InputObject $watcher -EventName Changed -Action $onChange
$handlers += Register-ObjectEvent -InputObject $watcher -EventName Created -Action $onChange
$handlers += Register-ObjectEvent -InputObject $watcher -EventName Deleted -Action $onChange
$handlers += Register-ObjectEvent -InputObject $watcher -EventName Renamed -Action $onChange

Write-Host "✅ 监控已就绪，等待文件变化...`n" -ForegroundColor Green

# 主循环
$script:lastPullTime = [DateTime]::Now

try {
    while ($true) {
        Start-Sleep -Seconds 1
        
        # 检查是否需要同步本地更改
        if ($script:pendingChanges) {
            $timeSinceLastChange = ([DateTime]::Now - $script:lastSyncTime).TotalSeconds
            if ($timeSinceLastChange -ge $DebounceSeconds) {
                Sync-Repository
            }
        }
        
        # 每 30 秒拉取一次远程更新
        $timeSincePull = ([DateTime]::Now - $script:lastPullTime).TotalSeconds
        if ($timeSincePull -ge 30) {
            $pullResult = git pull origin main --no-edit 2>&1
            
            if ($pullResult -notmatch "Already up to date") {
                $timestamp = Get-Date -Format "HH:mm:ss"
                Write-Host "[$timestamp] " -NoNewline -ForegroundColor Gray
                Write-Host "📥 收到远程更新`n" -ForegroundColor Green
            }
            
            $script:lastPullTime = [DateTime]::Now
        }
    }
}
finally {
    # 清理
    Write-Host "`n正在停止监控..." -ForegroundColor Yellow
    $watcher.EnableRaisingEvents = $false
    $watcher.Dispose()
    
    foreach ($handler in $handlers) {
        Unregister-Event -SubscriptionId $handler.Id
    }
    
    Write-Host "✓ 监控已停止" -ForegroundColor Green
}
