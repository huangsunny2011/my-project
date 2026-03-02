# Task #001 : 创建待办事项应用（AI 协作演示）

## 📊 元数据

| 属性 | 值 |
|------|-----|
| **状态** | 🟡 PENDING |
| **优先级** | 🔴 HIGH |
| **创建时间** | 2026-03-02 10:30:00 |
| **创建者** | 用户 |
| **当前负责设备** | _待认领_ |
| **标签** | `React`, `Frontend`, `Demo` |

---

## 📋 任务描述

开发一个完整的**待办事项（Todo）应用**，用于演示多设备 AI 协作。

### 功能需求

1. ✅ **添加新待办事项**
   - 输入框 + 添加按钮
   - 支持回车快捷键
   
2. ✅ **标记完成/未完成**
   - 点击复选框切换状态
   - 已完成项目显示删除线
   
3. ✅ **删除待办事项**
   - 每项有删除按钮
   - 确认后删除
   
4. ✅ **编辑待办内容**
   - 双击进入编辑模式
   - 支持原地编辑
   
5. ✅ **过滤显示**
   - 全部/已完成/未完成
   - 底部切换按钮
   
6. ✅ **数据持久化**
   - 使用 localStorage
   - 刷新页面数据不丢失

---

## 🎯 期望结果

一个完整可运行的 React 应用，包括：

- ✅ 清晰的项目结构
- ✅ 响应式设计（支持手机/平板/桌面）
- ✅ 优雅的 UI 设计
- ✅ 完善的代码注释
- ✅ 基本的单元测试
- ✅ README 使用说明

---

## 📝 技术要求

### 技术栈

```
前端框架: React 18+ (使用 Hooks)
样式方案: CSS Modules 或 Tailwind CSS
状态管理: useState + useEffect
数据存储: localStorage
构建工具: Vite 或 Create React App
```

### 项目结构（建议）

```
todo-app/
├── src/
│   ├── components/
│   │   ├── TodoList.jsx       # 待办列表
│   │   ├── TodoItem.jsx       # 单个待办
│   │   ├── TodoInput.jsx      # 输入框
│   │   └── TodoFilter.jsx     # 过滤器
│   ├── hooks/
│   │   └── useTodos.js        # 自定义 Hook
│   ├── utils/
│   │   └── storage.js         # localStorage 工具
│   ├── App.jsx
│   └── index.jsx
├── package.json
└── README.md
```

---

## ✅ 验收标准

### 功能验收
- [ ] 可以添加新的待办事项
- [ ] 可以标记完成/未完成
- [ ] 可以删除待办事项
- [ ] 可以编辑待办内容
- [ ] 过滤功能正常工作
- [ ] 刷新页面数据保持

### 代码质量
- [ ] 代码结构清晰
- [ ] 组件拆分合理
- [ ] 有适当的注释
- [ ] 遵循 React 最佳实践

### 用户体验
- [ ] UI 美观易用
- [ ] 交互流畅
- [ ] 响应式设计
- [ ] 无明显 bug

---

## 🤖 AI 协作记录

> **协作规则**：
> - 每个 AI 追加记录时使用格式：`### [设备名 AI] - 时间`
> - 使用 `@设备名-AI` 来询问其他 AI
> - 完成阶段性工作后更新任务状态
> - 需要讨论时创建 conversations/ 文件

---

### 等待第一个 AI 认领任务...

💡 **第一个接手的 AI 应该做什么？**

1. **需求分析**
   - 确认技术选型
   - 规划开发步骤
   - 列出需要创建的文件

2. **项目初始化**
   - 创建项目结构
   - 配置开发环境
   - 安装依赖

3. **开始实现**
   - 从最核心的功能开始
   - 实现基本的组件结构
   - 确保代码可运行

4. **提出问题**
   - 有技术决策需要讨论的，@其他 AI
   - 记录你的进度和遇到的问题

5. **更新状态**
   - 认领后：重命名文件为 `task-001-working.md`
   - 完成第一部分后：在此追加工作记录
   - 需要审查时：重命名为 `task-001-review.md`

---

### 🎬 AI 协作示例

这是一个协作示例，展示 AI 们应该如何互动：

```markdown
### [Desktop AI] - 2026-03-02 10:35:00

✅ **我已认领此任务！**

**需求分析**：
经过分析，我建议采用以下技术方案：
- 使用 Vite + React（启动更快）
- Tailwind CSS（快速开发）
- 使用自定义 Hook `useTodos` 管理状态

**开发计划**：
1. 项目初始化（我来做） ✓
2. 核心组件开发（请 @Laptop-AI 帮忙）
3. 样式美化（请 @Office-AI 审查）
4. 测试和优化（一起完成）

**已完成**：
- ✅ 创建项目结构
- ✅ 配置 Vite + React
- ✅ 安装 Tailwind CSS
- ✅ 实现 `useTodos` Hook
- ✅ 实现 `storage.js` 工具

**下一步**：
请 @Laptop-AI 实现以下组件：
- TodoInput.jsx
- TodoList.jsx
- TodoItem.jsx

我已经创建了基础结构和 Hook，你可以直接使用。

**状态更新**: PENDING → WORKING
```

---

<details>
<summary>📚 快速参考：AI 工作流程</summary>

### 任务状态流转

```
PENDING → WORKING → REVIEW → DONE
  ↓         ↓         ↓        ↓
待认领    进行中    待审查   已完成
```

### 常用命令

```powershell
# 认领任务（重命名文件）
Rename-Item "task-001-pending.md" "task-001-working.md"

# 提交进度
git add .
git commit -m "ai: Desktop AI 完成项目初始化"
git push origin main

# 请求审查（重命名文件）
Rename-Item "task-001-working.md" "task-001-review.md"

# 标记完成（重命名文件）
Rename-Item "task-001-review.md" "task-001-done.md"
```

### AI 沟通礼仪

- ✅ 使用 `@设备名-AI` 询问特定 AI
- ✅ 清晰描述你做了什么
- ✅ 说明下一步需要什么
- ✅ 遇到问题及时提出
- ❌ 不要重复其他 AI 的工作
- ❌ 不要忘记更新任务状态

</details>

---

## 📖 相关文档

- [AI_AUTO_COLLABORATION.md](../AI_AUTO_COLLABORATION.md) - AI 协作框架完整文档
- [AI_QUICK_START.md](../AI_QUICK_START.md) - GitHub Copilot 快速入门
- [DOCS_INDEX.md](../DOCS_INDEX.md) - 所有文档索引

---

**🚀 准备好开始了吗？**

1. 在各设备运行：`.\ai-agent.ps1 -DeviceName "你的设备名"`
2. AI 代理会自动发现此任务
3. 按 `Ctrl+I` 让 Copilot 开始工作
4. AI 们会通过此文件协作完成整个应用！

---

_Created by AI Task System v1.0 - 演示任务_
