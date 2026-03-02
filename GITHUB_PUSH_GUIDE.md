# GitHub Push Authentication Guide

## Current Issue
Push failed with error: `Permission denied to acronhuang`
Target repository: https://github.com/huangsunny2011/my-project.git

## Why This Happens
- Local Git is using cached credentials for wrong GitHub account (acronhuang)
- You need to authenticate as huangsunny2011

---

## Solution: Use Personal Access Token (Recommended)

### Step 1: Create Personal Access Token

1. **Login to GitHub** as **huangsunny2011**
   - Go to: https://github.com/login

2. **Navigate to Token Settings**
   - Go to: https://github.com/settings/tokens
   - Or: Profile → Settings → Developer settings → Personal access tokens → Tokens (classic)

3. **Generate New Token**
   - Click **"Generate new token"** → **"Generate new token (classic)"**
   - Note: `TEJ-Project-Deployment`
   - Expiration: Choose duration (e.g., 90 days or No expiration)
   - **Select scopes**:
     - ✅ **repo** (Full control of private repositories)
       - repo:status
       - repo_deployment
       - public_repo
       - repo:invite
       - security_events
   - Click **"Generate token"** at bottom

4. **Copy Token**
   - ⚠️ **IMPORTANT**: Copy the token NOW (you won't see it again!)
   - It looks like: `ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`

### Step 2: Configure Git with Token

Open PowerShell in `D:\TEJ` and run:

```powershell
# Replace YOUR_TOKEN with the actual token you copied
git remote set-url origin https://YOUR_TOKEN@github.com/huangsunny2011/my-project.git
```

**Example**:
```powershell
# If your token is: ghp_abc123xyz789
git remote set-url origin https://ghp_abc123xyz789@github.com/huangsunny2011/my-project.git
```

### Step 3: Verify Remote URL

```powershell
git remote -v
```

Should show:
```
origin  https://ghp_YOUR_TOKEN@github.com/huangsunny2011/my-project.git (fetch)
origin  https://ghp_YOUR_TOKEN@github.com/huangsunny2011/my-project.git (push)
```

### Step 4: Push to GitHub

```powershell
git push -u origin main
```

This should now work! ✅

---

## Alternative: Use SSH (More Secure)

### If you prefer SSH authentication:

1. **Generate SSH Key**
   ```powershell
   ssh-keygen -t ed25519 -C "huangsunny2011@users.noreply.github.com"
   ```
   Press Enter to accept default location
   Enter passphrase (optional but recommended)

2. **Add SSH Key to GitHub**
   ```powershell
   # Copy public key to clipboard
   Get-Content ~/.ssh/id_ed25519.pub | Set-Clipboard
   ```

   Then:
   - Go to: https://github.com/settings/keys
   - Click **"New SSH key"**
   - Title: `TEJ-Device`
   - Paste key
   - Click **"Add SSH key"**

3. **Update Remote URL to SSH**
   ```powershell
   git remote set-url origin git@github.com:huangsunny2011/my-project.git
   ```

4. **Test and Push**
   ```powershell
   ssh -T git@github.com  # Test connection
   git push -u origin main
   ```

---

## Alternative: Use GitHub CLI (Easiest)

### Install GitHub CLI:

1. **Download**: https://cli.github.com/
2. **Install** the downloaded .msi file
3. **Restart PowerShell**

### Authenticate and Push:

```powershell
# Login to GitHub
gh auth login
# Follow prompts and select: GitHub.com → HTTPS → Login with web browser

# Remove old remote
git remote remove origin

# Create repo and push (if repo doesn't exist yet)
gh repo create huangsunny2011/my-project --private --source=. --remote=origin --push

# Or if repo already exists:
git remote add origin https://github.com/huangsunny2011/my-project.git
git push -u origin main
```

---

## Verification

After successful push, verify at:
- **Repository**: https://github.com/huangsunny2011/my-project
- You should see all 7 commits
- All 39 files should be present

---

## Current Repository Status

**Local commits ready to push**: 7 commits
- e97b091 - Initial commit (37 files)
- a923c9c - Documentation updates
- dbba364 - Script encoding fixes
- a6b3206 - Deployment status report
- 1b09db9 - Script encoding prevention guide
- 87941d8 - Script recreation
- 37f46ae - Discussion space example

**Files to push**: 39 files including:
- 20 documentation files
- 3 working PowerShell scripts
- Configuration files
- Example discussion space (my-project)

---

## Quick Command Reference

```powershell
# Check current remote
git remote -v

# Update remote with token
git remote set-url origin https://TOKEN@github.com/huangsunny2011/my-project.git

# Check status
git status

# Push to GitHub
git push -u origin main

# View commit history
git log --oneline

# If push fails, check authentication
gh auth status  # If using GitHub CLI
```

---

## Need Help?

If you're still having issues:

1. **Verify repository exists**: Go to https://github.com/huangsunny2011/my-project
2. **Check you're logged in as huangsunny2011** on GitHub website
3. **Try the GitHub CLI method** (usually easiest)
4. **Check token permissions** if using PAT

---

**Created**: 2026-03-02
**Status**: Awaiting token creation and push
