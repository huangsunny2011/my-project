# 其他设备部署指南

**适用于：设备 2 和设备 3**
**前提：设备 1 已完成部署并推送到 GitHub**

---

## 📋 部署概览

设备 1（当前设备）已完成：
- ✅ 完整框架开发
- ✅ Git 仓库初始化
- ✅ 推送到 GitHub: https://github.com/huangsunny2011/my-project

现在要在其他设备上部署，只需：**克隆 → 配置 → 开始使用**

---

## 🚀 快速部署（3 步骤）

### 设备 2 / 设备 3 操作步骤

#### 步骤 1：克隆仓库（5 分钟）

在目标设备上打开 PowerShell 或终端：

```powershell
# 选择工作目录（例如 D:\Projects 或 ~/projects）
cd D:\Projects

# 克隆仓库
git clone https://github.com/huangsunny2011/my-project.git

# 进入项目目录
cd my-project

# 验证文件
ls
```

**预期结果**：看到所有 53 个文件，包括文档、脚本、配置等。

#### 步骤 2：运行部署助手（10 分钟）

```powershell
# 运行自动化部署脚本
.\deploy-helper.ps1
```

部署助手会自动检查并配置：
1. ✓ Git 配置（用户名、邮箱）
2. ✓ 远程仓库连接
3. ✓ Node.js 环境
4. ✓ npm 依赖安装
5. ✓ VSCode 扩展检查

**交互式提示**：
- 如果提示输入 Git 用户名/邮箱，输入你的信息
- 确认安装 Node.js 依赖：按 `Y`
- 确认安装 VSCode 扩展：按 `Y`

#### 步骤 3：验证部署（2 分钟）

```powershell
# 检查 Git 状态
git status

# 检查脚本是否正常
Get-Command .\create-discussion-space.ps1

# 测试创建讨论空间
.\create-discussion-space.ps1 -ProjectName "test-device-2"

# 查看 Node.js 环境
node --version
npm --version
```

**全部完成！** 🎉

---

## 📖 详细部署步骤（分步指南）

### 前置要求

每台设备需要安装：
- ✅ Git (https://git-scm.com/download/win)
- ✅ Node.js LTS (https://nodejs.org/)
- ✅ VSCode (https://code.visualstudio.com/)
- ✅ PowerShell 5.1+ (Windows 自带)

### 第一步：准备设备

#### Windows 设备

```powershell
# 检查 Git
git --version
# 如果没有：下载 https://git-scm.com/download/win

# 检查 Node.js
node --version
# 如果没有：下载 https://nodejs.org/ (LTS 版本)

# 检查 VSCode
code --version
# 如果没有：下载 https://code.visualstudio.com/
```

#### macOS/Linux 设备

```bash
# 检查 Git
git --version
# macOS: xcode-select --install
# Linux: sudo apt install git

# 检查 Node.js
node --version
# 安装: brew install node (macOS) 或 sudo apt install nodejs (Linux)

# 检查 VSCode
code --version
# 下载: https://code.visualstudio.com/
```

### 第二步：克隆项目

#### 方式 A：HTTPS（推荐新手）

```powershell
# 克隆仓库
git clone https://github.com/huangsunny2011/my-project.git

# 进入目录
cd my-project
```

如果需要认证（私有仓库）：
- 会弹出登录窗口
- 或使用 Personal Access Token

#### 方式 B：SSH（推荐高级用户）

```powershell
# 生成 SSH 密钥（如果没有）
ssh-keygen -t ed25519 -C "your-email@example.com"

# 复制公钥
cat ~/.ssh/id_ed25519.pub

# 添加到 GitHub:
# https://github.com/settings/keys → New SSH key

# 克隆
git clone git@github.com:huangsunny2011/my-project.git
cd my-project
```

### 第三步：配置 Git

```powershell
# 设置用户信息
git config user.name "你的名字"
git config user.email "your-email@example.com"

# 验证配置
git config --list | Select-String "user"
```

### 第四步：安装依赖

```powershell
# 安装 Node.js 包
npm install

# 等待安装完成（约 2-3 分钟）
# 预期：安装 387 个包
```

**常见问题**：
- 如果安装慢：配置淘宝镜像
  ```powershell
  npm config set registry https://registry.npmmirror.com
  ```
- 如果失败：删除 `node_modules` 重新安装

### 第五步：安装 VSCode 扩展

```powershell
# 打开 VSCode
code .

# 或手动安装扩展
code --install-extension GitHub.copilot
code --install-extension GitHub.copilot-chat
```

在 VSCode 中：
1. 会看到推荐扩展提示 → 点击 "Install"
2. 或者按 `Ctrl+Shift+X` 打开扩展面板
3. 搜索并安装：
   - GitHub Copilot
   - GitHub Copilot Chat

### 第六步：登录 GitHub Copilot

```
1. 按 Ctrl+I 或点击右侧的 Copilot Chat 图标
2. 点击 "Sign in to GitHub"
3. 在浏览器中授权
4. 返回 VSCode，应该显示已登录
```

### 第七步：测试功能

```powershell
# 测试讨论空间创建
.\create-discussion-space.ps1 -ProjectName "device-2-test"

# 检查创建的文件
ls discussions\device-2-test

# 测试脚本语法
Get-Command .\deploy-helper.ps1

# 运行测试（如果需要）
npm test
```

---

## 🔄 设备间同步工作流

### 场景 1：在设备 2 修改代码

```powershell
# 设备 2：修改代码后
git add .
git commit -m "feat: add new feature on device 2"
git push origin main

# 设备 1 或 3：获取更新
git pull origin main
```

### 场景 2：创建新讨论空间

```powershell
# 设备 2：创建讨论
.\create-discussion-space.ps1 -ProjectName "feature-x"
cd discussions\feature-x
.\new-discussion.ps1 -ProjectName "feature-x" -Category "ideas" -Title "new-idea"

# 提交并推送
git add discussions/feature-x
git commit -m "docs: add feature-x discussion space"
git push origin main

# 设备 1 或 3：同步讨论
git pull origin main
cd discussions\feature-x
.\stats.ps1  # 查看讨论统计
```

### 场景 3：多设备协同开发

```powershell
# 设备 1：开始工作前
git pull origin main  # 获取最新代码

# 工作...修改文件...

# 提交
git add .
git commit -m "your changes"
git push origin main

# 设备 2：同样操作
git pull origin main  # 先拉取更新
# 工作...
git add .
git commit -m "your changes"
git push origin main
```

**最佳实践**：
- ✅ 工作前先 `git pull`
- ✅ 频繁提交（小改动）
- ✅ 写清晰的 commit message
- ✅ 遇到冲突及时解决

---

## 🛠️ 故障排除

### 问题 1：克隆失败（私有仓库）

```
fatal: repository 'https://github.com/huangsunny2011/my-project.git/' not found
```

**解决方案**：
1. 确认仓库 URL 正确
2. 如果是私有仓库，需要认证：
   ```powershell
   # 使用 Personal Access Token
   git clone https://YOUR_TOKEN@github.com/huangsunny2011/my-project.git

   # 或使用 SSH
   git clone git@github.com:huangsunny2011/my-project.git
   ```

### 问题 2：npm install 失败

```
npm ERR! network timeout
```

**解决方案**：
```powershell
# 使用国内镜像
npm config set registry https://registry.npmmirror.com

# 清除缓存重试
npm cache clean --force
npm install
```

### 问题 3：PowerShell 脚本无法执行

```
无法载入，因为停用了执行脚本
```

**解决方案**：
```powershell
# 允许脚本执行（管理员权限）
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 或仅针对当前会话
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
```

### 问题 4：Git push 失败（权限问题）

```
remote: Permission denied
```

**解决方案**：
```powershell
# 方案 A：使用 Personal Access Token
git remote set-url origin https://YOUR_TOKEN@github.com/huangsunny2011/my-project.git

# 方案 B：使用 SSH
git remote set-url origin git@github.com:huangsunny2011/my-project.git

# 方案 C：使用 GitHub CLI
gh auth login
```

### 问题 5：VSCode 扩展未生效

**解决方案**：
1. 重启 VSCode
2. 检查是否登录 GitHub Copilot
3. 检查网络连接
4. 查看 VSCode 输出面板的错误信息

---

## 📊 部署验证清单

完成部署后，确认以下项目：

### ✅ Git 配置
- [ ] `git --version` 显示版本
- [ ] `git config user.name` 显示用户名
- [ ] `git remote -v` 显示正确的远程仓库
- [ ] `git status` 显示 "On branch main"

### ✅ Node.js 环境
- [ ] `node --version` 显示 v14+
- [ ] `npm --version` 显示版本
- [ ] `node_modules` 文件夹存在
- [ ] `npm test` 可以运行（可选）

### ✅ 项目文件
- [ ] 所有 53 个文件已克隆
- [ ] `README.md` 可读
- [ ] 脚本可执行：`Get-Command .\create-discussion-space.ps1`
- [ ] 配置文件完整

### ✅ VSCode 设置
- [ ] VSCode 可以打开项目：`code .`
- [ ] GitHub Copilot 扩展已安装
- [ ] GitHub Copilot Chat 扩展已安装
- [ ] 按 `Ctrl+I` 可以打开 Copilot Chat

### ✅ 功能测试
- [ ] 可以创建讨论空间
- [ ] 可以提交代码到 Git
- [ ] 可以推送到 GitHub
- [ ] AI 助手可以使用

---

## 🎯 快速参考

### 常用命令

```powershell
# 同步代码
git pull origin main

# 提交更改
git add .
git commit -m "your message"
git push origin main

# 创建讨论空间
.\create-discussion-space.ps1 -ProjectName "project-name"

# 查看状态
git status
npm list --depth=0

# 运行部署助手
.\deploy-helper.ps1

# 打开文档
code README.md
code DOCS_INDEX.md
```

### 重要文档

- `README.md` - 项目概述
- `AI_QUICK_START.md` - AI 快速入门（当前打开）
- `DEPLOYMENT_SUCCESS.md` - 设备 1 部署记录
- `DOCS_INDEX.md` - 完整文档索引
- `SETUP_FIX.md` - 故障排除

### 重要链接

- **GitHub 仓库**: https://github.com/huangsunny2011/my-project
- **克隆命令**: `git clone https://github.com/huangsunny2011/my-project.git`
- **Token 管理**: https://github.com/settings/tokens

---

## 💡 最佳实践

### 多设备开发建议

1. **保持同步**
   - 每天开始工作前：`git pull`
   - 完成工作后：提交并 push

2. **使用讨论空间**
   - 为每个项目创建独立讨论空间
   - 记录设备特定的配置和注意事项

3. **分支策略**（可选）
   ```powershell
   # 为特定功能创建分支
   git checkout -b feature/new-feature
   # 工作...
   git push origin feature/new-feature
   # 在 GitHub 创建 Pull Request
   ```

4. **备份重要文件**
   - 定期推送到 GitHub
   - 本地重要配置单独备份

---

## 🆘 需要帮助？

1. **查看文档**
   - `DOCS_INDEX.md` - 所有文档列表
   - `SETUP_FIX.md` - 常见问题解决

2. **运行部署助手**
   ```powershell
   .\deploy-helper.ps1
   ```

3. **检查 GitHub 仓库**
   - Issues: https://github.com/huangsunny2011/my-project/issues
   - Wiki: 可以在 GitHub 添加更多文档

---

**部署时间估计**：
- ⚡ 快速部署（有经验）：15-20 分钟
- 📖 详细部署（首次）：30-45 分钟

**完成后你就有了 3 台设备的完整 AI 协作环境！** 🎉
