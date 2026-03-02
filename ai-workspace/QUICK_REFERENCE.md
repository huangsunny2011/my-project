# 🚀 Copilot AI 协作快速参考

**当前任务**: Task #001 - 创建待办事项应用
**你的角色**: Desktop AI（第一个接手的 AI）

---

## 📋 给 Copilot 的提示词（复制使用）

```
请阅读当前打开的任务文件 task-001-pending.md。
我是第一个接手这个任务的 AI (Desktop AI)。

请帮我：
1. 分析任务需求
2. 制定技术方案和开发计划
3. 创建待办事项应用的项目结构
4. 实现核心的 useTodos Hook
5. 实现 localStorage 存储工具

完成后，生成一段我应该追加到任务文件末尾的工作记录，
格式为：### [Desktop AI] - 时间，并包含我的工作内容。
```

---

## ✅ 工作流程检查清单

### 第 1 步：让 Copilot 工作
- [ ] 按 `Ctrl+I` 打开 Copilot Chat
- [ ] 粘贴上面的提示词
- [ ] 等待 Copilot 生成代码

### 第 2 步：保存 Copilot 的工作
- [ ] 保存所有 Copilot 创建的文件
- [ ] 复制 Copilot 生成的工作记录
- [ ] 追加到 `task-001-pending.md` 末尾

### 第 3 步：更新任务状态
```powershell
# 重命名任务文件（pending → working）
Rename-Item "ai-workspace\tasks\task-001-pending.md" `
            "ai-workspace\tasks\task-001-working.md"
```

### 第 4 步：提交到 GitHub
```powershell
git add .
git commit -m "ai: Desktop AI 完成项目初始化和核心 Hook"
git push origin main
```

---

## 🤖 AI 工作记录模板

在任务文件末尾追加（Copilot 会生成类似内容）：

```markdown
### [Desktop AI] - 2026-03-02 10:45:00

✅ **我已认领此任务！**

**技术方案**：
- 使用 Vite + React 18
- Tailwind CSS 样式
- 自定义 useTodos Hook

**已完成**：
- ✅ 创建项目结构
- ✅ 实现 useTodos.js Hook
- ✅ 实现 storage.js 工具
- ✅ 配置 Tailwind CSS

**创建的文件**：
- src/hooks/useTodos.js
- src/utils/storage.js
- package.json
- vite.config.js

**下一步建议**：
请 @Laptop-AI 实现以下组件：
- TodoInput.jsx - 输入框组件
- TodoList.jsx - 列表组件
- TodoItem.jsx - 单项组件

**状态更新**: PENDING → WORKING
```

---

## 💬 AI 之间的沟通方式

### 询问其他 AI
```markdown
@Laptop-AI 你觉得用 Tailwind 还是 CSS Modules？
```

### 回应其他 AI
```markdown
@Desktop-AI 我建议用 Tailwind，开发更快。
```

### 请求审查
```markdown
@Office-AI 请审查我实现的组件，提供改进建议。
```

---

## 🎯 其他设备如何继续工作

### 在设备 2（Laptop）：

1. **同步任务**
   ```powershell
   git pull origin main
   ```

2. **打开任务文件**
   ```powershell
   code ai-workspace\tasks\task-001-working.md
   ```

3. **用 Copilot 继续**
   ```
   请阅读 task-001-working.md，我是 Laptop AI。

   Desktop AI 已经完成了项目初始化和核心 Hook。
   请帮我实现：
   1. TodoInput.jsx - 输入框组件
   2. TodoList.jsx - 列表组件
   3. TodoItem.jsx - 单个待办项组件

   使用 Desktop AI 创建的 useTodos Hook。
   完成后生成我的工作记录。
   ```

4. **追加工作记录并推送**

---

## 📊 任务状态说明

| 状态 | 文件名 | 含义 |
|------|--------|------|
| 🟡 PENDING | task-XXX-pending.md | 待认领 |
| 🔵 WORKING | task-XXX-working.md | 进行中 |
| 🟣 REVIEW | task-XXX-review.md | 待审查 |
| 🟢 DONE | task-XXX-done.md | 已完成 |

---

## 🆘 常见问题

**Q: Copilot 没有按预期工作？**
- 确保当前文件是 task-001-pending.md
- 试试更具体的提示词
- 可以说"请创建 src/hooks/useTodos.js 文件，实现..."

**Q: 如何创建讨论文件？**
```powershell
New-Item -ItemType Directory -Path "ai-workspace\conversations" -Force
code ai-workspace\conversations\conv-001-技术选型.md
```

**Q: 多个 AI 同时工作怎么办？**
- 使用 Git 分支隔离工作
- 或者在任务中明确分工

**Q: 如何查看所有任务？**
```powershell
.\ai-dashboard.ps1
```

---

## 🎉 完成后的效果

最终你会在 GitHub 仓库看到：
- ✅ 完整的 AI 协作历史
- ✅ 每个 AI 的工作记录
- ✅ 可运行的待办事项应用
- ✅ 清晰的决策过程

**这就是 AI 自动协作的魔力！** 🚀

---

_快速参考 v1.0 - 随时回来查看这个文件_
