# AI 自动协作框架

**目标：让两台（或多台）设备的 GitHub Copilot AI 自动讨论并完成任务**

---

## 🎯 核心理念

### 现实限制
GitHub Copilot **不能直接跨设备通信**。每个 Copilot 实例都是独立的。

### 解决方案
通过 **"AI 对话文件"** 作为中介：
```
设备 1 AI → 写入想法到文件 → Git push
                                    ↓
设备 2 AI ← 读取文件 ← Git pull ← GitHub
         ↓
      继续工作，写入响应
         ↓
      Git push → 循环...
```

---

## 🏗️ 架构设计

### 1. AI 任务工作区结构

```
ai-workspace/
  ├── tasks/                    # AI 任务列表
  │   ├── task-001-pending.md   # 待处理任务
  │   ├── task-002-working.md   # 进行中任务
  │   └── task-003-done.md      # 已完成任务
  │
  ├── conversations/            # AI 对话记录
  │   ├── conv-001.md           # AI 间的讨论
  │   └── conv-002.md
  │
  ├── plans/                    # AI 生成的工作计划
  │   ├── plan-001.md
  │   └── plan-002.md
  │
  ├── code-reviews/             # AI 代码审查
  │   └── review-001.md
  │
  └── decisions/                # AI 决策记录
      └── decision-001.md
```

### 2. AI 协作流程

```
用户：创建任务 "实现用户登录功能"
  ↓
设备 1 AI：
  1. 读取任务
  2. 分析需求
  3. 生成计划（写入 plans/plan-001.md）
  4. 提出问题（写入 conversations/conv-001.md）
  5. Git push
  ↓
设备 2 AI（自动触发）：
  1. Git pull
  2. 读取计划和问题
  3. 回答问题（追加到 conv-001.md）
  4. 开始实现（创建代码文件）
  5. 记录进度（更新 tasks/task-001-working.md）
  6. Git push
  ↓
设备 1 AI（自动触发）：
  1. Git pull
  2. 读取设备 2 的实现
  3. 审查代码（写入 code-reviews/review-001.md）
  4. 提出改进建议
  5. Git push
  ↓
设备 2 AI：
  1. 读取审查意见
  2. 改进代码
  3. 标记任务完成（task-001-done.md）
  4. Git push
```

---

## 🤖 AI 协作协议

### 任务文件格式

**tasks/task-001-pending.md**：
```markdown
# Task #001: 实现用户登录功能

## 状态
- Status: PENDING / WORKING / REVIEW / DONE
- Created: 2026-03-02 10:00:00
- Assigned: AUTO (由第一个拉取的 AI 接手)
- Current Device: [空 / Device-1 / Device-2]

## 用户需求
实现一个用户登录功能，包括：
- 用户名和密码输入
- 表单验证
- 后端 API 调用
- 错误处理
- 登录成功后跳转

## AI 工作区

### [Device-1 AI] - 2026-03-02 10:05:00
我已认领此任务。让我先分析需求：

**需求分解**：
1. 前端登录表单 (React)
2. 表单验证逻辑
3. API 调用封装
4. 状态管理
5. 路由跳转

**技术选型问题** → 请 Device-2 AI 回答：
- Q1: 使用 Redux 还是 Context API？
- Q2: 表单库用 Formik 还是 React Hook Form？

我会先创建文件结构，等待你的建议。

### [Device-2 AI] - 2026-03-02 10:15:00
收到！我的建议：

**A1**: 推荐 Context API
- 理由：登录状态管理相对简单，不需要 Redux 的复杂性
- 实现：创建 AuthContext

**A2**: 推荐 React Hook Form
- 理由：更轻量，性能更好
- 实现：使用 useForm hook

我已创建以下文件：
- src/contexts/AuthContext.jsx
- src/hooks/useAuth.js

接下来我会实现登录表单组件。请 Device-1 AI 审查我的 Context 实现。

### [Device-1 AI] - 2026-03-02 10:25:00
审查完毕！你的 AuthContext 实现很好。

我添加了：
- src/components/LoginForm.jsx (使用你的 AuthContext)
- src/api/auth.js (API 调用)

请 Device-2 AI 帮忙：
1. 添加错误处理
2. 实现表单验证规则
3. 测试登录流程

### [Device-2 AI] - 2026-03-02 10:35:00
已完成！

添加的内容：
- 错误处理中间件
- Yup 验证 schema
- 单元测试

任务完成，请审查。如无问题，我会标记为 DONE。

### [Device-1 AI] - 2026-03-02 10:45:00
✅ 审查通过！代码质量很好。

状态更新：DONE
文件重命名：task-001-done.md
```

---

## 🔧 实现方案

### 方案 1：基于 GitHub Copilot Chat（半自动）

#### 1.1 创建 AI 任务启动器

**ai-agent.ps1**：
```powershell
# AI 代理脚本 - 让 AI 自动工作

param(
    [string]$DeviceName = $env:COMPUTERNAME,
    [int]$CheckIntervalMinutes = 3
)

$aiWorkspace = "ai-workspace"

# 确保工作区存在
if (-not (Test-Path $aiWorkspace)) {
    New-Item -ItemType Directory -Path $aiWorkspace -Force
    New-Item -ItemType Directory -Path "$aiWorkspace/tasks" -Force
    New-Item -ItemType Directory -Path "$aiWorkspace/conversations" -Force
    New-Item -ItemType Directory -Path "$aiWorkspace/plans" -Force
    New-Item -ItemType Directory -Path "$aiWorkspace/code-reviews" -Force
    New-Item -ItemType Directory -Path "$aiWorkspace/decisions" -Force
}

Write-Host "🤖 AI 代理已启动 - $DeviceName" -ForegroundColor Green
Write-Host "   监控 AI 任务，间隔 $CheckIntervalMinutes 分钟`n" -ForegroundColor Cyan

while ($true) {
    # 1. 同步最新内容
    git pull origin main --quiet 2>&1 | Out-Null

    # 2. 检查待处理任务
    $pendingTasks = Get-ChildItem "$aiWorkspace/tasks/*-pending.md" -ErrorAction SilentlyContinue

    if ($pendingTasks) {
        foreach ($task in $pendingTasks) {
            Write-Host "[$(Get-Date -Format 'HH:mm:ss')] 📋 发现新任务: $($task.Name)" -ForegroundColor Yellow

            # 打开任务文件在 VSCode 中
            code $task.FullName

            # 在 VSCode 中显示提示消息
            $content = Get-Content $task.FullName -Raw

            # 创建 AI 提示文件
            $promptFile = "$aiWorkspace/.ai-prompt-$DeviceName.md"

            $prompt = @"
# 🤖 AI 任务通知

**设备**: $DeviceName
**时间**: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')

## 发现新任务

文件: ``$($task.Name)``

## 任务内容

$content

---

## 🎯 请执行以下操作：

1. **阅读任务**: 理解用户需求和其他 AI 的讨论
2. **继续工作**:
   - 如果是新任务：分析需求，生成计划
   - 如果有问题：回答其他 AI 的问题
   - 如果需要实现：编写代码
   - 如果需要审查：审查代码并提供反馈
3. **更新任务文件**: 在任务文件末尾追加你的工作内容
   - 使用格式: ``### [$DeviceName AI] - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')``
   - 记录你的思考、决策和输出
4. **提交更改**:
   - ``git add .``
   - ``git commit -m "ai: $DeviceName 工作在任务 $($task.BaseName)"``
   - ``git push origin main``

## 💡 提示

- 查看 conversations/ 目录了解讨论历史
- 查看 plans/ 目录了解已有计划
- 如有疑问，在任务中提问，等待其他 AI 回答
- 完成后更新状态为 WORKING 或 DONE

---

**按 Ctrl+I 打开 Copilot Chat 开始工作！**
"@

            Set-Content -Path $promptFile -Value $prompt -Encoding UTF8
            code $promptFile

            Write-Host "   ✅ 已打开任务文件，请用 Copilot 完成任务" -ForegroundColor Green
            Write-Host "   📝 任务文件: $($task.FullName)" -ForegroundColor Cyan
            Write-Host "   🤖 AI 提示: $promptFile`n" -ForegroundColor Cyan
        }
    }

    # 3. 检查需要审查的代码
    $reviewTasks = Get-ChildItem "$aiWorkspace/tasks/*-review.md" -ErrorAction SilentlyContinue

    if ($reviewTasks) {
        foreach ($task in $reviewTasks) {
            Write-Host "[$(Get-Date -Format 'HH:mm:ss')] 🔍 需要代码审查: $($task.Name)" -ForegroundColor Cyan
            code $task.FullName
        }
    }

    # 4. 检查更新的对话
    $lastCheckFile = ".last-ai-check-$DeviceName"
    $lastCheckTime = Get-Date

    if (Test-Path $lastCheckFile) {
        $lastCheckTime = Get-Date (Get-Content $lastCheckFile)
    }

    $newConversations = Get-ChildItem "$aiWorkspace/conversations/*.md" -ErrorAction SilentlyContinue |
        Where-Object { $_.LastWriteTime -gt $lastCheckTime }

    if ($newConversations) {
        Write-Host "[$(Get-Date -Format 'HH:mm:ss')] 💬 发现新的 AI 对话" -ForegroundColor Magenta
        foreach ($conv in $newConversations) {
            Write-Host "   - $($conv.Name)" -ForegroundColor White
        }
    }

    # 更新检查时间
    Get-Date -Format "o" | Set-Content $lastCheckFile

    # 等待下一次检查
    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] 😴 等待 $CheckIntervalMinutes 分钟..`n" -ForegroundColor Gray
    Start-Sleep -Seconds ($CheckIntervalMinutes * 60)
}
```

#### 1.2 创建任务创建工具

**create-ai-task.ps1**：
```powershell
# 创建 AI 任务

param(
    [Parameter(Mandatory=$true)]
    [string]$Title,

    [Parameter(Mandatory=$true)]
    [string]$Description,

    [string]$Priority = "NORMAL"  # LOW / NORMAL / HIGH
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

# 创建任务内容
$content = @"
# Task #$taskNumber : $Title

## 元数据
- **状态**: PENDING
- **优先级**: $Priority
- **创建时间**: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
- **创建者**: 用户
- **当前负责设备**: [待认领]

---

## 📋 任务描述

$Description

---

## 🎯 期望结果

[请第一个接手的 AI 完善此部分]

---

## 📝 AI 工作记录

> AI 们会在下方追加工作内容，格式：
> ### [设备名 AI] - 时间
> 工作内容...

---

### 等待 AI 认领任务...

💡 **提示**: 运行 ``ai-agent.ps1`` 的设备会自动发现并处理此任务。
"@

# 保存任务文件
Set-Content -Path $taskFile -Value $content -Encoding UTF8

Write-Host "`n✅ AI 任务已创建！" -ForegroundColor Green
Write-Host ""
Write-Host "   📋 任务 ID: $taskNumber" -ForegroundColor Cyan
Write-Host "   📄 文件: $taskFile" -ForegroundColor Cyan
Write-Host "   🎯 标题: $Title" -ForegroundColor Yellow
Write-Host ""
Write-Host "📤 提交到 GitHub..." -ForegroundColor Cyan

# 提交到 Git
git add $taskFile
git commit -m "task: 创建任务 #$taskNumber - $Title"
git push origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ 任务已推送到 GitHub" -ForegroundColor Green
    Write-Host ""
    Write-Host "🤖 下一步:" -ForegroundColor Yellow
    Write-Host "   1. 在各设备上运行: .\ai-agent.ps1" -ForegroundColor White
    Write-Host "   2. AI 代理会自动发现并打开此任务" -ForegroundColor White
    Write-Host "   3. 使用 Copilot (Ctrl+I) 完成任务" -ForegroundColor White
    Write-Host ""
}
else {
    Write-Host "❌ 推送失败，请检查网络连接" -ForegroundColor Red
}

# 打开任务文件
code $taskFile
```

---

## 🚀 使用方法

### 第一步：在所有设备上启动 AI 代理

#### 设备 1：
```powershell
# 启动 AI 代理（后台运行）
Start-Process powershell -ArgumentList "-File", "ai-agent.ps1", "-DeviceName", "Desktop" -WindowStyle Normal

# 或前台运行
.\ai-agent.ps1 -DeviceName "Desktop" -CheckIntervalMinutes 3
```

#### 设备 2：
```powershell
.\ai-agent.ps1 -DeviceName "Laptop" -CheckIntervalMinutes 3
```

#### 设备 3（如果有）：
```powershell
.\ai-agent.ps1 -DeviceName "Office-PC" -CheckIntervalMinutes 3
```

### 第二步：创建任务

在**任意设备**上：
```powershell
.\create-ai-task.ps1 -Title "实现用户登录功能" -Description @"
创建一个完整的用户登录系统：

要求：
- 前端: React 登录表单
- 后端: Node.js API
- 数据库: MongoDB
- 功能:
  * 用户名密码登录
  * JWT 令牌
  * 记住我功能
  * 错误处理
  * 表单验证

技术栈：
- React + React Hook Form
- Express.js
- MongoDB + Mongoose
- JWT

请 AI 们协作完成！
"@
```

### 第三步：AI 自动协作（神奇的部分！）

```
1. 任务推送到 GitHub
   ↓
2. 设备 1 的 ai-agent.ps1 检测到新任务（3分钟后）
   ↓
3. 自动打开任务文件和 AI 提示文件
   ↓
4. **你在设备 1 按 Ctrl+I，告诉 Copilot**：
   "请阅读 .ai-prompt-Desktop.md 和 task-001-pending.md，
    然后按照提示完成任务"
   ↓
5. Copilot 分析需求，生成计划，写入任务文件
   ↓
6. **你运行**：
   git add .
   git commit -m "ai: Desktop AI 完成需求分析"
   git push
   ↓
7. 设备 2 的 ai-agent.ps1 检测到更新（3分钟后）
   ↓
8. 自动打开更新的任务文件
   ↓
9. **你在设备 2 按 Ctrl+I**：
   "继续 task-001 的工作，实现 Desktop AI 提出的计划"
   ↓
10. Copilot 阅读任务历史，开始实现代码
    ↓
11. 循环往复，直到任务完成！
```

---

## 🎯 实际操作示例

### 示例 1：完整的 AI 协作流程

#### 在设备 1（创建任务）：
```powershell
.\create-ai-task.ps1 `
  -Title "创建待办事项 API" `
  -Description "实现 RESTful API，包括 GET, POST, PUT, DELETE 操作"

# 输出：
# ✅ 任务已创建: task-001-pending.md
# ✅ 已推送到 GitHub
```

#### 在设备 2（AI 代理自动检测）：
```powershell
# ai-agent.ps1 自动输出：
[10:15:00] 📋 发现新任务: task-001-pending.md
   ✅ 已打开任务文件
   按 Ctrl+I 开始工作！
```

#### 在设备 2 的 Copilot Chat：
```
你: "@workspace 阅读 ai-workspace/tasks/task-001-pending.md 和
     ai-workspace/.ai-prompt-Laptop.md，完成任务"

Copilot: 我已分析任务。这是我的计划：

1. 创建 Express 服务器
2. 定义 Todo 数据模型
3. 实现 CRUD 路由
4. 添加错误处理

我会开始实现。首先创建项目结构...

[Copilot 开始生成代码]
```

#### Copilot 完成后，你手动更新任务文件：
```powershell
# 在 task-001-pending.md 末尾追加：

### [Laptop AI] - 2026-03-02 10:20:00

我已完成以下工作：

✅ **已创建文件**：
- server/index.js - Express 服务器
- server/models/Todo.js - 数据模型
- server/routes/todos.js - API 路由
- server/middleware/errorHandler.js - 错误处理

✅ **实现的功能**：
- GET /api/todos - 获取所有待办
- POST /api/todos - 创建待办
- PUT /api/todos/:id - 更新待办
- DELETE /api/todos/:id - 删除待办

🔍 **需要 Desktop AI 审查**：
- 代码质量
- 错误处理是否完善
- 是否需要添加测试

状态更新: PENDING → REVIEW
```

```powershell
# 提交
git add .
git commit -m "ai: Laptop AI 实现待办 API"
git push
```

#### 设备 1（检测到更新）：
```powershell
# ai-agent.ps1 自动输出：
[10:25:00] 🔍 需要代码审查: task-001-review.md
```

#### 在设备 1 的 Copilot Chat：
```
你: "@workspace 审查 ai-workspace/tasks/task-001-review.md
     中 Laptop AI 的实现，提供改进建议"

Copilot: 我已审查代码。整体实现很好！建议：

1. ✅ 代码结构清晰
2. ⚠️ 建议添加输入验证（使用 Joi）
3. ⚠️ 建议添加单元测试
4. ✅ 错误处理良好

我会添加这些改进...
```

#### 来回几轮后：
```powershell
# task-001-done.md 最终内容：

### [Desktop AI] - 2026-03-02 10:35:00

✅ **审查完成，所有改进已实施**

最终成果：
- 完整的待办 API（包括验证和测试）
- 代码覆盖率: 95%
- API 文档已生成

**状态: DONE**
```

---

## 🎨 高级功能

### 1. AI 对话文件

创建 **conversations/conv-001.md** 专门用于 AI 讨论：

```markdown
# AI 对话 #001: 技术选型讨论

## 主题
决定使用哪个数据库

---

### [Desktop AI] - 10:00:00
我认为应该用 MongoDB，因为：
1. 灵活的 Schema
2. 易于扩展
3. 团队熟悉

@Laptop-AI 你觉得呢？

---

### [Laptop AI] - 10:05:00
@Desktop-AI 我同意！补充理由：
4. JSON 友好
5. 有成熟的 ODM (Mongoose)

建议添加 Redis 做缓存，提高性能。

---

### [Desktop AI] - 10:10:00
@Laptop-AI 好主意！

**决策记录** → decisions/decision-001.md
- 数据库: MongoDB
- 缓存: Redis
- ORM: Mongoose

我会开始实现数据层。
```

### 2. 自动代码审查

创建 **.ai-review-rules.md**：

```markdown
# AI 代码审查规则

当检测到新的代码提交时，AI 应审查以下方面：

## 必查项
- [ ] 代码风格符合规范
- [ ] 没有安全漏洞
- [ ] 错误处理完善
- [ ] 有适当的注释
- [ ] 函数不超过 50 行

## 建议项
- [ ] 是否需要单元测试
- [ ] 性能是否可以优化
- [ ] 代码是否可以复用

## 输出格式
```markdown
### [设备名 AI] 代码审查 - 时间

**文件**: xxx.js

✅ 通过项:
- 代码风格良好

⚠️ 建议:
- 建议添加错误处理

❌ 必须修改:
- 安全问题：SQL 注入风险
```
```

---

## 🌟 最佳实践

### 1. 任务粒度
```powershell
# ✅ 好 - 任务明确
.\create-ai-task.ps1 `
  -Title "实现用户注册表单验证" `
  -Description "使用 Yup 验证邮箱、密码强度、确认密码"

# ❌ 不好 - 任务太大
.\create-ai-task.ps1 `
  -Title "完成整个项目" `
  -Description "做完所有功能"
```

### 2. AI 沟通格式
```markdown
# ✅ 好 - 清晰的结构
### [Desktop AI] - 10:00:00

**完成内容**:
- 创建了 X 文件
- 实现了 Y 功能

**遇到的问题**:
- Z 需要决策

**请其他 AI 帮忙**:
@Laptop-AI 请实现数据库部分

# ❌ 不好 - 混乱的记录
完成了一些东西，还有些没做
```

### 3. 定期同步
```powershell
# 每台设备的 ai-agent.ps1 应该：
# - 每 3-5 分钟检查一次
# - 自动 pull 最新内容
# - 提示用户有新任务
```

---

## ⚡ 完全自动化版本（实验性）

### 使用 GitHub Actions 触发 AI

创建 **.github/workflows/ai-collaboration.yml**：

```yaml
name: AI Collaboration Trigger

on:
  push:
    paths:
      - 'ai-workspace/tasks/*-pending.md'
      - 'ai-workspace/tasks/*-review.md'

jobs:
  notify-devices:
    runs-on: ubuntu-latest
    steps:
      - name: Trigger AI Agents
        run: |
          echo "新任务已创建，通知所有设备"
          # 可以发送 webhook 到各设备
          # 或使用其他通知机制
```

---

## 📊 监控 AI 协作

创建 **ai-dashboard.ps1**：

```powershell
# AI 协作仪表板

Write-Host "`n╔══════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║      🤖 AI 协作仪表板              ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════╝`n" -ForegroundColor Cyan

# 统计任务
$pending = (Get-ChildItem "ai-workspace/tasks/*-pending.md").Count
$working = (Get-ChildItem "ai-workspace/tasks/*-working.md").Count
$review = (Get-ChildItem "ai-workspace/tasks/*-review.md").Count
$done = (Get-ChildItem "ai-workspace/tasks/*-done.md").Count

Write-Host "📊 任务统计:" -ForegroundColor Yellow
Write-Host "   待处理: $pending" -ForegroundColor White
Write-Host "   进行中: $working" -ForegroundColor Cyan
Write-Host "   待审查: $review" -ForegroundColor Magenta
Write-Host "   已完成: $done" -ForegroundColor Green

# AI 活跃度
Write-Host "`n🤖 AI 活跃度:" -ForegroundColor Yellow

$tasks = Get-ChildItem "ai-workspace/tasks/*.md"
$aiActivity = @{}

foreach ($task in $tasks) {
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

foreach ($ai in $aiActivity.Keys | Sort-Object) {
    $count = $aiActivity[$ai]
    $bar = "█" * [Math]::Min($count, 20)
    Write-Host "   $ai : " -NoNewline -ForegroundColor Cyan
    Write-Host "$bar $count" -ForegroundColor Green
}

Write-Host ""
```

---

## 🎉 总结

### 你现在拥有：

1. ✅ **AI 任务系统** - 创建和管理 AI 任务
2. ✅ **AI 代理** - 自动检测和处理任务
3. ✅ **AI 对话框架** - AI 之间的沟通协议
4. ✅ **自动同步** - Git 作为 AI 通信管道

### 工作流程：

```
用户创建任务
    ↓
推送到 GitHub
    ↓
设备 1 AI 代理检测到 → 打开文件 → 你用 Copilot 处理 → 推送
    ↓
设备 2 AI 代理检测到 → 打开文件 → 你用 Copilot 继续 → 推送
    ↓
设备 3 AI 代理检测到 → 打开文件 → 你用 Copilot 审查 → 推送
    ↓
任务完成！
```

### 关键点：

⭐ **半自动化**：AI 代理自动检测任务，但需要人工触发 Copilot
⭐ **异步协作**：通过文件和 Git 实现 AI 间的"对话"
⭐ **可追溯**：所有 AI 决策都记录在文件中

---

## 🔮 未来展望

完全自动化需要：
1. API 调用 GitHub Copilot（目前不支持）
2. AI Agent 框架（如 AutoGPT, LangChain）
3. 自定义 AI 工作流引擎

但现在的方案已经**非常接近"AI 自动协作"**了！
