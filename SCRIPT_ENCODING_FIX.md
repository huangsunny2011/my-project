# Script Encoding Issue - Prevention Guide

## Problem 
The PowerShell scripts (`create-discussion-space.ps1` and `deploy-helper.ps1`) were getting corrupted by VSCode's auto-formatter, causing encoding issues with Chinese characters and malformed code blocks.

## Root Cause
1. VSCode auto-save or formatter converting encoding
2. Here-strings with complex content getting mangled
3. Chinese characters in comments causing UTF-8 BOM issues

## Solution Applied
Scripts were rebuilt using:
- Simple English comments only
- Line arrays instead of here-strings  
- `$lines -join "\`n"` for multi-line content
- UTF-8 encoding without BOM

## How to Prevent Recurrence

### Option 1: Disable Auto-Format for .ps1 Files
Add to `.vscode/settings.json`:
```json
{
  "[powershell]": {
    "editor.formatOnSave": false,
    "files.encoding": "utf8"
  }
}
```

### Option 2: Lock Script Files (Recommended)
Make scripts read-only after they're working:
```powershell
Set-ItemProperty *.ps1 -Name IsReadOnly -Value $true
```

To edit later:
```powershell
Set-ItemProperty <script-name>.ps1 -Name IsReadOnly -Value $false
# Edit the file
Set-ItemProperty <script-name>.ps1 -Name IsReadOnly -Value $true
```

### Option 3: Use Git Attributes
Add to `.gitattributes`:
```
*.ps1 text eol=crlf working-tree-encoding=UTF-8
```

## Current Status
✅ Both scripts rebuilt and working
✅ Tested successfully
✅ Committed to Git (commit 87941d8)
✅ Backup files (.backup) available if needed

## If Scripts Break Again
Run this to restore from Git:
```powershell
git checkout HEAD -- create-discussion-space.ps1 deploy-helper.ps1
```

Or restore from backups in repo history:
```powershell
git log --oneline -- create-discussion-space.ps1
git show <commit-hash>:create-discussion-space.ps1 > create-discussion-space.ps1
```

## Testing Scripts
Always test after any editor changes:
```powershell
# Test syntax
Get-Command .\create-discussion-space.ps1
Get-Command .\deploy-helper.ps1

# Test functionality
.\create-discussion-space.ps1 -ProjectName "test"
Remove-Item discussions\test -Recurse -Force
```

## Safe Editing Tips
1. **Don't use Chinese characters** in PowerShell scripts
2. **Don't use complex here-strings** - use arrays instead
3. **Always test** after editing
4. **Commit working versions** immediately to Git

---

**Last Fixed**: 2026-03-02  
**Status**: ✅ RESOLVED
