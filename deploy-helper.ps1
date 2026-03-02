# Deployment Helper Script
# This script helps you configure Git and deploy on this device

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Multi-Device AI Collaboration" -ForegroundColor Cyan
Write-Host "       Deployment Helper" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check current directory
$currentDir = Get-Location
Write-Host "Current directory: $currentDir" -ForegroundColor Green
Write-Host ""

# ====================================
# Step 1: Check Git configuration
# ====================================
Write-Host "Step 1: Checking Git configuration..." -ForegroundColor Yellow

# Check if Git is initialized
if (-not (Test-Path ".git")) {
    Write-Host "! Git not initialized" -ForegroundColor Red
    $initGit = Read-Host "Initialize Git repository? (Y/n)"
    if ($initGit -ne "n") {
        git init
        Write-Host "Success: Git repository initialized" -ForegroundColor Green
    } else {
        Write-Host "Error: Cancelled" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "Success: Git repository exists" -ForegroundColor Green
}

Write-Host ""

# Check Git user configuration
$gitUserName = git config user.name
$gitUserEmail = git config user.email

if (-not $gitUserName -or -not $gitUserEmail) {
    Write-Host "! Git user information not set" -ForegroundColor Red
    Write-Host ""

    $userName = Read-Host "Enter your Git username"
    $userEmail = Read-Host "Enter your Git email"

    git config user.name "$userName"
    git config user.email "$userEmail"

    Write-Host "Success: Git user information set" -ForegroundColor Green
    Write-Host "  Name: $userName" -ForegroundColor Gray
    Write-Host "  Email: $userEmail" -ForegroundColor Gray
} else {
    Write-Host "Success: Git user information configured" -ForegroundColor Green
    Write-Host "  Name: $gitUserName" -ForegroundColor Gray
    Write-Host "  Email: $gitUserEmail" -ForegroundColor Gray
}

Write-Host ""

# ====================================
# Step 2: Check remote repository
# ====================================
Write-Host "Step 2: Checking remote repository..." -ForegroundColor Yellow

$remotes = git remote -v
if (-not $remotes) {
    Write-Host "! Remote repository not configured" -ForegroundColor Red
    Write-Host ""
    Write-Host "Choose an option:" -ForegroundColor Cyan
    Write-Host "  1. I have created a GitHub repo, enter URL" -ForegroundColor Gray
    Write-Host "  2. Auto-create repo with GitHub CLI (requires gh)" -ForegroundColor Gray
    Write-Host "  3. Skip for now" -ForegroundColor Gray
    Write-Host ""

    $choice = Read-Host "Select option (1/2/3)"

    switch ($choice) {
        "1" {
            Write-Host ""
            Write-Host "GitHub repository URL examples:" -ForegroundColor Gray
            Write-Host "  HTTPS: https://github.com/username/repo.git" -ForegroundColor Gray
            Write-Host "  SSH:   git@github.com:username/repo.git" -ForegroundColor Gray
            Write-Host ""

            $repoUrl = Read-Host "Enter repository URL"
            git remote add origin $repoUrl
            Write-Host "Success: Remote repository added" -ForegroundColor Green
        }
        "2" {
            Write-Host ""
            $repoName = Read-Host "Enter repository name (e.g., multi-device-ai-collab)"
            $repoType = Read-Host "Repository type: public or private? (enter public or private)"

            if ($repoType -eq "public") {
                gh repo create $repoName --public --source=. --remote=origin
            } else {
                gh repo create $repoName --private --source=. --remote=origin
            }

            if ($LASTEXITCODE -eq 0) {
                Write-Host "Success: GitHub repository created and configured" -ForegroundColor Green
            } else {
                Write-Host "Error: Creation failed. Make sure gh CLI is installed and authenticated" -ForegroundColor Red
                Write-Host "  Install: https://cli.github.com/" -ForegroundColor Gray
                Write-Host "  Login: gh auth login" -ForegroundColor Gray
            }
        }
        "3" {
            Write-Host "Warning: Please add remote repository later:" -ForegroundColor Yellow
            Write-Host "  git remote add origin your-repo-url" -ForegroundColor Gray
        }
        default {
            Write-Host "Error: Invalid option" -ForegroundColor Red
        }
    }
} else {
    Write-Host "Success: Remote repository configured" -ForegroundColor Green
    Write-Host $remotes -ForegroundColor Gray
}

Write-Host ""

# ====================================
# Step 3: Check and commit files
# ====================================
Write-Host "Step 3: Checking file status..." -ForegroundColor Yellow

# Ensure .gitignore exists
if (-not (Test-Path ".gitignore")) {
    Write-Host "! .gitignore not found, creating..." -ForegroundColor Yellow

    $gitignoreLines = @(
        "node_modules/",
        ".env",
        "coverage/",
        "*.log",
        ".DS_Store",
        "dist/",
        "build/",
        ".vscode/.history",
        "*.backup"
    )

    $gitignoreLines -join "`n" | Out-File -FilePath ".gitignore" -Encoding utf8
    Write-Host "Success: .gitignore created" -ForegroundColor Green
}

# Check uncommitted files
$status = git status --short
if ($status) {
    Write-Host "Found uncommitted files:" -ForegroundColor Yellow
    Write-Host $status -ForegroundColor Gray
    Write-Host ""

    $shouldCommit = Read-Host "Commit these files? (Y/n)"
    if ($shouldCommit -ne "n") {
        # Add all files
        git add .

        # Show files to be committed
        Write-Host ""
        Write-Host "Files to be committed:" -ForegroundColor Green
        git status --short
        Write-Host ""

        # Commit
        $commitMsg = Read-Host "Enter commit message (press Enter for default)"
        if (-not $commitMsg) {
            $commitLines = @(
                "feat: add multi-device AI collaboration framework",
                "",
                "- Add complete documentation system",
                "- Add AI agent collaboration guides",
                "- Add discussion space management system",
                "- Add automation scripts and configurations",
                "- Add deployment guide"
            )
            $commitMsg = $commitLines -join "`n"
        }

        git commit -m "$commitMsg"

        if ($LASTEXITCODE -eq 0) {
            Write-Host "Success: Files committed" -ForegroundColor Green
        } else {
            Write-Host "Error: Commit failed" -ForegroundColor Red
        }
    }
} else {
    Write-Host "Success: No uncommitted files" -ForegroundColor Green
}

Write-Host ""

# ====================================
# Step 4: Push to remote repository
# ====================================
Write-Host "Step 4: Pushing to remote repository..." -ForegroundColor Yellow

# Check current branch
$currentBranch = git branch --show-current
if (-not $currentBranch) {
    Write-Host "! No current branch, creating main branch..." -ForegroundColor Yellow
    git checkout -b main
    $currentBranch = "main"
}

Write-Host "Current branch: $currentBranch" -ForegroundColor Gray

# Check if remote exists
$hasRemote = git remote -v
if ($hasRemote) {
    Write-Host ""
    $shouldPush = Read-Host "Push to remote repository? (Y/n)"

    if ($shouldPush -ne "n") {
        Write-Host "Pushing..." -ForegroundColor Yellow

        # Try to push
        git push -u origin $currentBranch

        if ($LASTEXITCODE -eq 0) {
            Write-Host "Success: Pushed to remote repository!" -ForegroundColor Green
        } else {
            Write-Host "Error: Push failed" -ForegroundColor Red
            Write-Host ""
            Write-Host "Possible causes and solutions:" -ForegroundColor Yellow
            Write-Host "  1. Authentication failed - Run: gh auth login" -ForegroundColor Gray
            Write-Host "  2. Remote not empty - Run: git pull origin main --allow-unrelated-histories" -ForegroundColor Gray
            Write-Host "  3. Branch name mismatch - Run: git branch -M main" -ForegroundColor Gray
        }
    }
} else {
    Write-Host "Warning: No remote repository configured, skipping push" -ForegroundColor Yellow
    Write-Host "Add remote first: git remote add origin repo-url" -ForegroundColor Gray
}

Write-Host ""

# ====================================
# Step 5: Check Node.js environment
# ====================================
Write-Host "Step 5: Checking Node.js environment..." -ForegroundColor Yellow

try {
    $nodeVersion = node --version
    $npmVersion = npm --version
    Write-Host "Success: Node.js: $nodeVersion" -ForegroundColor Green
    Write-Host "Success: npm: $npmVersion" -ForegroundColor Green

    # Check if dependencies are installed
    if (-not (Test-Path "node_modules")) {
        Write-Host ""
        $shouldInstall = Read-Host "Install Node.js dependencies? (Y/n)"
        if ($shouldInstall -ne "n") {
            Write-Host "Installing dependencies..." -ForegroundColor Yellow
            npm install

            if ($LASTEXITCODE -eq 0) {
                Write-Host "Success: Dependencies installed" -ForegroundColor Green
            } else {
                Write-Host "Error: Installation failed" -ForegroundColor Red
            }
        }
    } else {
        Write-Host "Success: Node.js dependencies installed" -ForegroundColor Green
    }
} catch {
    Write-Host "Error: Node.js not installed" -ForegroundColor Red
    Write-Host "Download from https://nodejs.org/ (LTS version recommended)" -ForegroundColor Yellow
}

Write-Host ""

# ====================================
# Step 6: Check VSCode extensions
# ====================================
Write-Host "Step 6: Checking VSCode extensions..." -ForegroundColor Yellow

try {
    $extensions = code --list-extensions 2>&1
    $hasCopilot = $extensions -match "github.copilot"
    $hasCopilotChat = $extensions -match "github.copilot-chat"

    if ($hasCopilot) {
        Write-Host "Success: GitHub Copilot installed" -ForegroundColor Green
    } else {
        Write-Host "Error: GitHub Copilot not installed" -ForegroundColor Red
        Write-Host "  Install: code --install-extension GitHub.copilot" -ForegroundColor Gray
    }

    if ($hasCopilotChat) {
        Write-Host "Success: GitHub Copilot Chat installed" -ForegroundColor Green
    } else {
        Write-Host "Error: GitHub Copilot Chat not installed" -ForegroundColor Red
        Write-Host "  Install: code --install-extension GitHub.copilot-chat" -ForegroundColor Gray
    }

    if (-not $hasCopilot -or -not $hasCopilotChat) {
        Write-Host ""
        $shouldInstallExt = Read-Host "Install missing extensions? (Y/n)"
        if ($shouldInstallExt -ne "n") {
            if (-not $hasCopilot) {
                code --install-extension GitHub.copilot
            }
            if (-not $hasCopilotChat) {
                code --install-extension GitHub.copilot-chat
            }
            Write-Host "Success: Extensions installed, please restart VSCode" -ForegroundColor Green
        }
    }
} catch {
    Write-Host "Warning: Cannot check VSCode extensions (VSCode may not be installed or not in PATH)" -ForegroundColor Yellow
}

Write-Host ""

# ====================================
# Completion
# ====================================
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "       Deployment Check Complete!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  1. Quick AI Test (5 minutes)" -ForegroundColor Green
Write-Host "     View: AI_QUICK_START.md" -ForegroundColor Gray
Write-Host "     Press Ctrl+I in VSCode to start" -ForegroundColor Gray
Write-Host ""
Write-Host "  2. Learn AI Collaboration" -ForegroundColor Green
Write-Host "     View: AI_AGENT_COLLABORATION_GUIDE.md" -ForegroundColor Gray
Write-Host ""
Write-Host "  3. Create Your First Discussion Space" -ForegroundColor Green
Write-Host "     Run: .\create-discussion-space.ps1 -ProjectName my-project" -ForegroundColor Gray
Write-Host ""
Write-Host "Full deployment guide: DEPLOY_THIS_DEVICE.md" -ForegroundColor Cyan
Write-Host "Documentation index: DOCS_INDEX.md" -ForegroundColor Cyan
Write-Host ""
Write-Host "Happy collaborating! " -ForegroundColor Green
Write-Host ""
