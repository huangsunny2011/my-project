# 实现两台 VSCode 自动通信指南

**目标：让两台（或三台）VSCode 尽可能"自动"地同步和通信**

---

## 🎯 四种实现方案

### 方案对比

| 方案 | 实时性 | 复杂度 | 适用场景 |
|------|--------|--------|----------|
| **Live Share** | ⭐⭐⭐⭐⭐ 实时 | 简单 | 同时在线协作 |
| **自动 Git 同步** | ⭐⭐⭐ 1-5分钟 | 中等 | 异步协作 |
| **文件监控同步** | ⭐⭐⭐⭐ 秒级 | 复杂 | 持续同步 |
| **云端同步盘** | ⭐⭐ 分钟级 | 简单 | 简单同步 |

---

## 🚀 方案 1：VSCode Live Share（推荐用于实时协作）

### ✨ 特点
- ✅ **真正的实时同步**：看到对方的光标和编辑
- ✅ **共享终端**：可以共享运行的服务器
- ✅ **语音通话**：内置音频通话
- ❌ **需要同时在线**：两台设备必须都开着

### 📥 安装步骤

#### 所有设备执行：

```powershell
# 1. 安装 Live Share 扩展
code --install-extension MS-vsliveshare.vsliveshare

# 2. 安装音频扩展（可选）
code --install-extension MS-vsliveshare.vsliveshare-audio

# 3. 重启 VSCode
```

### 🔧 使用方法

#### 设备 1（主机）：

```
1. 打开 VSCode
2. 登录 GitHub 账号
   - 左下角点击账号图标
   - 选择 "Sign in to Sync Settings"
   - 使用 GitHub 登录

3. 开始共享会话
   - 按 F1 或 Ctrl+Shift+P
   - 输入：Live Share: Start Collaboration Session
   - 或点击底部状态栏的 "Live Share" 按钮

4. 复制链接
   - 会自动生成一个链接（如：https://prod.liveshare.vsengsaas.visualstudio.com/join?xxx）
   - 链接自动复制到剪贴板
   - 发送给设备 2
```

#### 设备 2（加入者）：

```
1. 收到链接后
   - 在浏览器打开链接
   - 或在 VSCode 中：Ctrl+Shift+P
   - 输入：Live Share: Join Collaboration Session
   - 粘贴链接

2. 现在可以：
   - 实时看到设备 1 的编辑
   - 共同编辑同一个文件
   - 共享运行的服务器（如 localhost:3000）
   - 使用共享终端
```

### 💡 Live Share 高级用法

```powershell
# 设备 1 开启后，设备 2 可以：

# 1. 跟随主机的光标
#    点击状态栏的参与者名称 → "Follow"

# 2. 共享服务器
#    设备 1 运行：npm start (localhost:3000)
#    设备 2 自动可以访问这个端口

# 3. 共享终端
#    设备 1 右键终端 → Share Terminal (Read/Write)
#    设备 2 可以在同一个终端输入命令

# 4. 设置只读模式
#    设备 1 在共享时选择 "Read-only"
```

### ⚠️ 限制

- 需要网络连接
- 两台设备需要同时在线
- 会话结束后不保留历史（需要手动 commit）

---

## 🔄 方案 2：自动 Git 同步（推荐用于异步协作）

### ✨ 特点
- ✅ **不需要同时在线**
- ✅ **自动推送和拉取**
- ✅ **保留完整历史**
- ⭐ **准实时**：1-5 分钟同步一次

### 📥 设置步骤

#### 第一步：创建自动同步脚本

在每台设备上创建 `auto-sync.ps1`：

```powershell
# 创建自动同步脚本
code auto-sync.ps1
```

复制以下内容：

```powershell
# auto-sync.ps1 - 自动 Git 同步脚本

param(
    [int]$IntervalMinutes = 5,  # 同步间隔（分钟）
    [string]$DeviceName = $env:COMPUTERNAME  # 设备名称
)

$projectPath = "D:\TEJ"  # 修改为你的项目路径
cd $projectPath

Write-Host "🔄 自动同步已启动" -ForegroundColor Green
Write-Host "设备：$DeviceName" -ForegroundColor Cyan
Write-Host "间隔：每 $IntervalMinutes 分钟" -ForegroundColor Cyan
Write-Host "按 Ctrl+C 停止`n" -ForegroundColor Yellow

while ($true) {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    
    try {
        # 1. 拉取远程更新
        Write-Host "[$timestamp] 🔽 拉取远程更新..." -ForegroundColor Cyan
        $pullResult = git pull origin main 2>&1
        
        if ($pullResult -match "Already up to date") {
            Write-Host "[$timestamp] ✓ 已是最新版本" -ForegroundColor Gray
        } else {
            Write-Host "[$timestamp] ✅ 成功拉取更新：" -ForegroundColor Green
            Write-Host $pullResult -ForegroundColor White
            
            # 触发通知
            Write-Host "`n🔔 检测到新更新！请查看文件变化。`n" -ForegroundColor Yellow
        }
        
        # 2. 检查本地变化
        $status = git status --porcelain
        
        if ($status) {
            Write-Host "[$timestamp] 📝 检测到本地变化" -ForegroundColor Cyan
            
            # 显示变化的文件
            $changedFiles = $status | ForEach-Object { $_.Substring(3) }
            Write-Host "变化的文件：" -ForegroundColor Yellow
            $changedFiles | ForEach-Object { Write-Host "  - $_" -ForegroundColor White }
            
            # 自动提交
            git add .
            $commitMsg = "auto-sync: $DeviceName at $timestamp"
            git commit -m $commitMsg
            
            Write-Host "[$timestamp] 💾 已自动提交" -ForegroundColor Green
            
            # 推送到远程
            Write-Host "[$timestamp] 🔼 推送到远程..." -ForegroundColor Cyan
            $pushResult = git push origin main 2>&1
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "[$timestamp] ✅ 成功推送到 GitHub" -ForegroundColor Green
                Write-Host "`n🎉 其他设备将在下次同步时收到更新！`n" -ForegroundColor Yellow
            } else {
                Write-Host "[$timestamp] ⚠️ 推送失败（可能有冲突）" -ForegroundColor Red
                Write-Host $pushResult -ForegroundColor Red
            }
        } else {
            Write-Host "[$timestamp] ✓ 无本地变化" -ForegroundColor Gray
        }
        
    } catch {
        Write-Host "[$timestamp] ❌ 同步出错：$_" -ForegroundColor Red
    }
    
    # 等待下一个周期
    Write-Host "[$timestamp] 😴 等待 $IntervalMinutes 分钟...`n" -ForegroundColor Gray
    Start-Sleep -Seconds ($IntervalMinutes * 60)
}
```

#### 第二步：启动自动同步

```powershell
# 在每台设备上运行（在 VSCode 终端中）
.\auto-sync.ps1 -IntervalMinutes 5 -DeviceName "Device-1"

# 或使用后台模式（推荐）
Start-Process powershell -ArgumentList "-NoExit", "-File", "auto-sync.ps1", "-IntervalMinutes", "3", "-DeviceName", "Device-1"
```

#### 第三步：设置开机自动启动（可选）

```powershell
# 创建计划任务
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" `
    -Argument "-ExecutionPolicy Bypass -File `"D:\TEJ\auto-sync.ps1`" -IntervalMinutes 5 -DeviceName `"$env:COMPUTERNAME`""

$trigger = New-ScheduledTaskTrigger -AtLogOn

$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

Register-ScheduledTask -TaskName "GitAutoSync" `
    -Action $action `
    -Trigger $trigger `
    -Settings $settings `
    -Description "自动同步 Git 仓库"

# 查看任务
Get-ScheduledTask -TaskName "GitAutoSync"

# 删除任务（如果需要）
# Unregister-ScheduledTask -TaskName "GitAutoSync" -Confirm:$false
```

### 📊 效果演示

```
设备 1：
[2026-03-02 10:00:00] 🔽 拉取远程更新...
[2026-03-02 10:00:01] ✓ 已是最新版本
[2026-03-02 10:00:01] 📝 检测到本地变化
变化的文件：
  - src/app.js
  - README.md
[2026-03-02 10:00:02] 💾 已自动提交
[2026-03-02 10:00:03] 🔼 推送到远程...
[2026-03-02 10:00:05] ✅ 成功推送到 GitHub

🎉 其他设备将在下次同步时收到更新！

[2026-03-02 10:00:05] 😴 等待 5 分钟...

---

设备 2（5分钟后）：
[2026-03-02 10:05:00] 🔽 拉取远程更新...
[2026-03-02 10:05:02] ✅ 成功拉取更新：
Updating abc123..def456
Fast-forward
 src/app.js | 10 +++++-----
 README.md  |  5 +++--
 2 files changed, 8 insertions(+), 7 deletions(-)

🔔 检测到新更新！请查看文件变化。
```

### 🎨 添加桌面通知

创建 `sync-notifier.ps1`（更强大的版本）：

```powershell
# sync-notifier.ps1 - 带通知的自动同步

param(
    [int]$IntervalMinutes = 3,
    [string]$DeviceName = $env:COMPUTERNAME
)

$projectPath = "D:\TEJ"
cd $projectPath

# 加载 Windows Forms（用于通知）
Add-Type -AssemblyName System.Windows.Forms

function Show-Notification {
    param([string]$Title, [string]$Message)
    
    $notification = New-Object System.Windows.Forms.NotifyIcon
    $notification.Icon = [System.Drawing.SystemIcons]::Information
    $notification.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Info
    $notification.BalloonTipTitle = $Title
    $notification.BalloonTipText = $Message
    $notification.Visible = $true
    $notification.ShowBalloonTip(5000)
    
    Start-Sleep -Seconds 2
    $notification.Dispose()
}

Write-Host "🔄 智能同步已启动（带通知）" -ForegroundColor Green
Show-Notification "Git 自动同步" "已启动，间隔 $IntervalMinutes 分钟"

while ($true) {
    $timestamp = Get-Date -Format "HH:mm:ss"
    
    # 拉取更新
    $pullResult = git pull origin main 2>&1
    
    if ($pullResult -notmatch "Already up to date") {
        # 有新更新
        $files = git diff --name-only HEAD@{1} HEAD
        $fileCount = ($files | Measure-Object -Line).Lines
        
        Show-Notification "📥 收到新更新" "来自其他设备，更新了 $fileCount 个文件"
        Write-Host "[$timestamp] ✅ 拉取 $fileCount 个文件更新" -ForegroundColor Green
    }
    
    # 检查本地变化
    $status = git status --porcelain
    if ($status) {
        $changedCount = ($status | Measure-Object -Line).Lines
        
        git add .
        git commit -m "auto-sync: $DeviceName at $(Get-Date -Format 'HH:mm:ss')"
        git push origin main 2>&1 | Out-Null
        
        if ($LASTEXITCODE -eq 0) {
            Show-Notification "📤 已自动推送" "推送了 $changedCount 个文件到 GitHub"
            Write-Host "[$timestamp] ✅ 推送 $changedCount 个文件" -ForegroundColor Green
        }
    }
    
    Start-Sleep -Seconds ($IntervalMinutes * 60)
}
```

使用：
```powershell
.\sync-notifier.ps1 -IntervalMinutes 3 -DeviceName "Laptop"
```

---

## ⚡ 方案 3：文件监控实时同步（最接近"自动"）

### ✨ 特点
- ⭐⭐⭐⭐⭐ **几乎实时**：保存后 1-3 秒同步
- ✅ **完全自动**：不需要手动操作
- ⚠️ **可能频繁提交**：每次保存都会 commit

### 📥 实现方法

创建 `watch-sync.ps1`：

```powershell
# watch-sync.ps1 - 文件监控实时同步

param(
    [string]$Path = "D:\TEJ",
    [string]$DeviceName = $env:COMPUTERNAME,
    [int]$DebounceSeconds = 10  # 防抖时间
)

cd $Path

Write-Host "👁️ 文件监控同步已启动" -ForegroundColor Green
Write-Host "监控路径：$Path" -ForegroundColor Cyan
Write-Host "设备名称：$DeviceName" -ForegroundColor Cyan
Write-Host "防抖时间：$DebounceSeconds 秒`n" -ForegroundColor Cyan

# 创建文件监控器
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $Path
$watcher.Filter = "*.*"
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true

# 排除不需要监控的目录
$excludeDirs = @('.git', 'node_modules', '.vscode', 'bin', 'obj')

# 最后同步时间
$script:lastSyncTime = [DateTime]::MinValue
$script:pendingChanges = $false

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
    
    $timestamp = $now.ToString("yyyy-MM-dd HH:mm:ss")
    
    try {
        # 先拉取（避免冲突）
        Write-Host "[$timestamp] 🔄 同步中..." -ForegroundColor Cyan
        git pull origin main --no-edit 2>&1 | Out-Null
        
        # 检查是否有变化
        $status = git status --porcelain
        if ($status) {
            # 提交变化
            git add .
            $commitMsg = "auto: $DeviceName - $(Get-Date -Format 'HH:mm:ss')"
            git commit -m $commitMsg 2>&1 | Out-Null
            
            # 推送
            $pushResult = git push origin main 2>&1
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "[$timestamp] ✅ 已同步到 GitHub" -ForegroundColor Green
                $script:pendingChanges = $false
                $script:lastSyncTime = $now
            } else {
                Write-Host "[$timestamp] ⚠️ 推送失败" -ForegroundColor Yellow
            }
        }
    } catch {
        Write-Host "[$timestamp] ❌ 同步出错: $_" -ForegroundColor Red
    }
}

# 文件变化事件
$onChange = {
    param($sender, $e)
    
    # 检查是否在排除目录中
    $relativePath = $e.FullPath.Replace($Path, "").TrimStart('\')
    $inExcluded = $false
    
    foreach ($dir in $excludeDirs) {
        if ($relativePath -like "$dir\*" -or $relativePath -eq $dir) {
            $inExcluded = $true
            break
        }
    }
    
    if (-not $inExcluded) {
        $timestamp = Get-Date -Format "HH:mm:ss"
        Write-Host "[$timestamp] 📝 检测到变化: $($e.Name)" -ForegroundColor Yellow
        $script:pendingChanges = $true
    }
}

# 注册事件
Register-ObjectEvent -InputObject $watcher -EventName Changed -Action $onChange | Out-Null
Register-ObjectEvent -InputObject $watcher -EventName Created -Action $onChange | Out-Null
Register-ObjectEvent -InputObject $watcher -EventName Deleted -Action $onChange | Out-Null
Register-ObjectEvent -InputObject $watcher -EventName Renamed -Action $onChange | Out-Null

Write-Host "✅ 监控已就绪，保存文件后会自动同步`n" -ForegroundColor Green

# 定期检查并同步
try {
    while ($true) {
        # 每秒检查一次是否需要同步
        Start-Sleep -Seconds 1
        
        if ($script:pendingChanges) {
            Sync-Repository
        }
        
        # 每 30 秒拉取一次远程更新
        if (([DateTime]::Now - $script:lastSyncTime).TotalSeconds -gt 30) {
            $pullResult = git pull origin main --no-edit 2>&1
            if ($pullResult -notmatch "Already up to date") {
                Write-Host "[$(Get-Date -Format 'HH:mm:ss')] 📥 收到远程更新" -ForegroundColor Green
            }
            $script:lastSyncTime = [DateTime]::Now
        }
    }
} finally {
    # 清理
    $watcher.EnableRaisingEvents = $false
    $watcher.Dispose()
    Get-EventSubscriber | Unregister-Event
}
```

使用：
```powershell
# 启动监控（前台）
.\watch-sync.ps1 -DeviceName "Device-1"

# 或后台启动
Start-Process powershell -ArgumentList "-NoExit", "-File", "watch-sync.ps1", "-DeviceName", "Device-1" -WindowStyle Minimized
```

### 📊 效果

```
保存文件 → 1-3秒后 → 自动 commit → 自动 push → 其他设备 30秒内 pull
```

实际使用：
```
设备 1：编辑 src/app.js → Ctrl+S 保存
[10:30:15] 📝 检测到变化: app.js
[10:30:25] 🔄 同步中...
[10:30:27] ✅ 已同步到 GitHub

设备 2：（30秒内自动）
[10:30:40] 📥 收到远程更新
  - src/app.js 已更新
```

---

## 🌐 方案 4：云端同步盘（最简单但不推荐）

### 使用 OneDrive / Dropbox / Google Drive

```powershell
# 1. 将项目移到同步文件夹
Move-Item D:\TEJ "C:\Users\YourName\OneDrive\TEJ"

# 2. 创建符号链接
New-Item -ItemType SymbolicLink -Path "D:\TEJ" -Target "C:\Users\YourName\OneDrive\TEJ"

# 3. 在 VSCode 中打开
code D:\TEJ
```

⚠️ **注意**：
- ❌ 可能导致 Git 冲突
- ❌ 不保留清晰的历史
- ❌ 同时编辑会混乱
- ✅ 但设置最简单

---

## 🎯 推荐配置方案

### 根据需求选择：

#### 场景 1：需要实时协作（同时在线）
```powershell
# 使用 Live Share
code --install-extension MS-vsliveshare.vsliveshare

# 设备 1：开始会话
# 设备 2：加入会话
# ✅ 实时看到对方编辑
```

#### 场景 2：日常协作（不同时在线）
```powershell
# 使用自动 Git 同步（5分钟间隔）
.\auto-sync.ps1 -IntervalMinutes 5 -DeviceName "MyLaptop"

# 在每台设备后台运行
# ✅ 自动提交和推送
# ✅ 不会错过更新
```

#### 场景 3：紧密协作（快速迭代）
```powershell
# 使用文件监控实时同步
.\watch-sync.ps1 -DeviceName "Desktop" -DebounceSeconds 10

# 保存后几秒内自动同步
# ✅ 接近实时
# ⚠️ 会产生较多提交
```

#### 场景 4：混合方案（最佳实践）
```powershell
# 平时：自动同步（后台）
Start-Process powershell -ArgumentList "-File", "auto-sync.ps1", "-IntervalMinutes", "5" -WindowStyle Hidden

# 重要协作：Live Share（实时）
# Ctrl+Shift+P → Live Share: Start
```

---

## 📋 完整部署清单

### 在每台设备上执行：

```powershell
# 1. 克隆仓库（如果是新设备）
git clone https://github.com/huangsunny2011/my-project.git
cd my-project

# 2. 安装 Live Share（实时协作）
code --install-extension MS-vsliveshare.vsliveshare

# 3. 创建自动同步脚本
# 复制上面的 auto-sync.ps1 内容

# 4. 测试自动同步
.\auto-sync.ps1 -IntervalMinutes 1 -DeviceName "Test"
# Ctrl+C 停止

# 5. 设置开机启动（可选）
# 使用上面的计划任务方法

# 6. 创建快捷方式（方便启动）
# 桌面右键 → 新建快捷方式
# 目标：powershell.exe -File "D:\TEJ\auto-sync.ps1" -IntervalMinutes 5
```

### 验证设置

```powershell
# 测试 1：Live Share
# 设备 1：Ctrl+Shift+P → Live Share: Start
# 设备 2：加入会话
# ✅ 能看到对方的编辑

# 测试 2：自动同步
# 设备 1：启动 auto-sync.ps1
# 编辑一个文件，等待 5 分钟
# 设备 2：应该自动拉取更新
# ✅ 看到设备 1 的修改

# 测试 3：文件监控
# 设备 1：启动 watch-sync.ps1
# 保存文件
# 10 秒内应该自动推送
# ✅ GitHub 上看到新提交
```

---

## 🔧 故障排除

### 问题 1：自动同步冲突

```powershell
# 现象：推送失败，提示冲突

# 解决：
git pull origin main --rebase
# 解决冲突后
git add .
git rebase --continue
git push origin main
```

### 问题 2：Live Share 连接失败

```powershell
# 检查网络
Test-NetConnection github.com -Port 443

# 重新登录
# VSCode 左下角 → 注销 → 重新登录

# 检查防火墙
# 确保允许 VSCode 访问网络
```

### 问题 3：自动同步占用太多 CPU

```powershell
# 增加同步间隔
.\auto-sync.ps1 -IntervalMinutes 10  # 从 5 改成 10

# 或使用定时任务代替持续运行
```

### 问题 4：太多自动提交

```powershell
# 合并最近的自动提交
git rebase -i HEAD~10

# 在编辑器中，将多个 auto-sync 提交合并
# 将 'pick' 改为 'squash'

# 或使用更大的防抖时间
.\watch-sync.ps1 -DebounceSeconds 60  # 1分钟内的多次修改只提交一次
```

---

## 💡 最佳实践

### 1. 混合使用多种方案

```powershell
# 日常：后台自动同步
Start-Process powershell -ArgumentList "-File", "auto-sync.ps1" -WindowStyle Hidden

# 紧急协作：Live Share
# 按需开启，不常驻

# 独立工作：关闭自动同步
# Stop-Process -Name powershell -Force  # 停止后台同步
```

### 2. 使用有意义的设备名

```powershell
# ❌ 不好
.\auto-sync.ps1 -DeviceName "PC1"

# ✅ 好
.\auto-sync.ps1 -DeviceName "Office-Desktop"
.\auto-sync.ps1 -DeviceName "Home-Laptop"
.\auto-sync.ps1 -DeviceName "Mobile-Surface"
```

### 3. 定期清理自动提交历史

```powershell
# 每周手动整理一次提交历史
git rebase -i HEAD~50

# 或在重要节点做标签
git tag -a v1.0 -m "Feature complete"
git push origin v1.0
```

### 4. 设置同步规则

创建 `.gitignore` 排除不需要同步的文件：

```
# .gitignore
node_modules/
.vscode/settings.json  # 个人设置不同步
*.log
.DS_Store
Thumbs.db
*.tmp

# 设备特定配置
device-local/
```

---

## 🎉 总结

### 达到"自动通信"的完整方案：

**第一阶段：基础设置**
```powershell
# 每台设备
git clone https://github.com/huangsunny2011/my-project.git
code --install-extension MS-vsliveshare.vsliveshare
```

**第二阶段：启用自动同步**
```powershell
# 后台运行（开机自动）
.\auto-sync.ps1 -IntervalMinutes 5 -DeviceName "$(hostname)"

# 效果：5分钟内看到其他设备的更新
```

**第三阶段：实时协作**
```powershell
# 需要实时协作时
# Ctrl+Shift+P → Live Share: Start
# 发送链接给其他设备

# 效果：立即看到对方编辑
```

### 最终效果：

```
设备 1：编辑文件 → 保存
   ↓ (10秒，watch-sync)
GitHub：收到提交
   ↓ (30秒，自动拉取)
设备 2：文件自动更新，VSCode 提示重新加载
设备 3：文件自动更新，VSCode 提示重新加载

总延迟：约 30-60 秒（非常接近"自动"！）
```

---

**相关文档：**
- `AI_COLLABORATION_EXPLAINED.md` - 协作机制解释
- `OTHER_DEVICES_DEPLOYMENT.md` - 多设备部署
- `DEPLOYMENT_SUCCESS.md` - 完整部署记录

**现在你的 VSCode 就可以"自动通信"了！** 🚀
