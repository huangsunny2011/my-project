# Create Discussion Space Script
# This script helps create organized discussion directories for projects

param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectName
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Discussion Space Creation Tool" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Validate project name
if ($ProjectName -match '[\\/:*?"<>|]') {
    Write-Host "Error: Project name contains invalid characters" -ForegroundColor Red
    Write-Host "Please use only letters, numbers, hyphens, and underscores" -ForegroundColor Yellow
    exit 1
}

# Create discussions folder if not exists
$DiscussionsRoot = ".\discussions"
if (-not (Test-Path $DiscussionsRoot)) {
    New-Item -ItemType Directory -Path $DiscussionsRoot -Force | Out-Null
    Write-Host "Created discussions root folder" -ForegroundColor Green
}

# Create project folder
$ProjectPath = Join-Path $DiscussionsRoot $ProjectName
if (Test-Path $ProjectPath) {
    Write-Host "Warning: Project '$ProjectName' already exists" -ForegroundColor Yellow
    $overwrite = Read-Host "Overwrite existing project? (y/N)"
    if ($overwrite -ne "y") {
        Write-Host "Operation cancelled" -ForegroundColor Red
        exit 1
    }
    Remove-Item -Path $ProjectPath -Recurse -Force
}

New-Item -ItemType Directory -Path $ProjectPath -Force | Out-Null
Write-Host "Created project folder: $ProjectPath" -ForegroundColor Green
Write-Host ""

# Define discussion categories
$Categories = @(
    @{Name="ideas"; Icon="[IDEA]"; Description="Feature proposals and brainstorming"},
    @{Name="technical"; Icon="[TECH]"; Description="Technical discussions"},
    @{Name="architecture"; Icon="[ARCH]"; Description="Architecture decisions"},
    @{Name="meetings"; Icon="[MEET]"; Description="Meeting notes"},
    @{Name="troubleshooting"; Icon="[BUG]"; Description="Problem solving"},
    @{Name="reviews"; Icon="[REVIEW]"; Description="Code reviews"},
    @{Name="notes"; Icon="[NOTE]"; Description="Development notes"}
)

Write-Host "Creating discussion category folders..." -ForegroundColor Yellow
foreach ($Category in $Categories) {
    $CategoryPath = Join-Path $ProjectPath $Category.Name
    New-Item -ItemType Directory -Path $CategoryPath -Force | Out-Null
    
    # Create README for each category
    $readmeLines = @(
        "# $($Category.Icon) $($Category.Name)",
        "",
        "$($Category.Description)",
        "",
        "## File Naming Convention",
        "",
        "- Format: YYYY-MM-DD-topic-name.md",
        "- Example: 2026-03-02-feature-proposal.md",
        "",
        "## Discussion Template",
        "",
        "Each discussion file should include:",
        "",
        '```markdown',
        "# Discussion Title",
        "",
        "**Date**: YYYY-MM-DD",
        "**Participants**: @person1, @person2",
        "**Status**: Open / In Progress / Resolved",
        "",
        "## Context",
        "",
        "Background information about this discussion...",
        "",
        "## Key Points",
        "",
        "- Point 1",
        "- Point 2",
        "",
        "## Decisions Made",
        "",
        "Document any decisions here...",
        "",
        "## Action Items",
        "",
        "- [ ] Task 1 - @assignee",
        "- [ ] Task 2 - @assignee",
        "",
        "## Related Discussions",
        "",
        "- Link to related discussions",
        '```'
    )
    
    $readmeLines -join "`n" | Out-File -FilePath (Join-Path $CategoryPath "README.md") -Encoding utf8
    Write-Host "  Created: $($Category.Name)/" -ForegroundColor Gray
}

Write-Host ""
Write-Host "Creating helper scripts..." -ForegroundColor Yellow

# Create new discussion script
$newDiscussionLines = @(
    '# Create a new discussion file',
    '',
    'param(',
    '    [Parameter(Mandatory=$true)]',
    '    [string]$ProjectName,',
    '    ',
    '    [Parameter(Mandatory=$true)]',
    '    [ValidateSet("ideas","technical","architecture","meetings","troubleshooting","reviews","notes")]',
    '    [string]$Category,',
    '    ',
    '    [Parameter(Mandatory=$true)]',
    '    [string]$Title',
    ')',
    '',
    '$Date = Get-Date -Format "yyyy-MM-dd"',
    '$FileName = "$Date-$Title.md"',
    '$FilePath = ".\discussions\$ProjectName\$Category\$FileName"',
    '',
    'if (Test-Path $FilePath) {',
    '    Write-Host "Error: File already exists: $FilePath" -ForegroundColor Red',
    '    exit 1',
    '}',
    '',
    '$ContentLines = @(',
    '    "# $Title",',
    '    "",',
    '    "**Date**: $Date",',
    '    "**Participants**: @",',
    '    "**Status**: Open",',
    '    "",',
    '    "## Context",',
    '    "",',
    '    "<!-- Describe the background and context of this discussion -->",',
    '    "",',
    '    "## Key Points",',
    '    "",',
    '    "- ",',
    '    "",',
    '    "## Decisions Made",',
    '    "",',
    '    "<!-- Document any decisions made during this discussion -->",',
    '    "",',
    '    "## Action Items",',
    '    "",',
    '    "- [ ] Task 1 - @assignee",',
    '    "",',
    '    "## Related Discussions",',
    '    "",',
    '    "<!-- Link to related discussions -->"',
    ')',
    '',
    '$ContentLines -join "`n" | Out-File -FilePath $FilePath -Encoding utf8',
    'Write-Host "Created: $FilePath" -ForegroundColor Green',
    'Write-Host "Opening in default editor..." -ForegroundColor Yellow',
    '& $FilePath'
)

$newDiscussionLines -join "`n" | Out-File -FilePath (Join-Path $ProjectPath "new-discussion.ps1") -Encoding utf8
Write-Host "  Created: new-discussion.ps1" -ForegroundColor Gray

# Create search script
$searchLines = @(
    '# Search discussions',
    '',
    'param(',
    '    [Parameter(Mandatory=$false)]',
    '    [string]$Keyword,',
    '    ',
    '    [Parameter(Mandatory=$false)]',
    '    [string]$Category',
    ')',
    '',
    '$ProjectPath = $PSScriptRoot',
    '',
    'Write-Host "Searching discussions..." -ForegroundColor Yellow',
    'Write-Host ""',
    '',
    '$SearchPath = if ($Category) {',
    '    Join-Path $ProjectPath $Category',
    '} else {',
    '    $ProjectPath',
    '}',
    '',
    'if ($Keyword) {',
    '    $Results = Get-ChildItem -Path $SearchPath -Filter "*.md" -Recurse | ',
    '        Where-Object { $_.Name -ne "README.md" } |',
    '        Select-String -Pattern $Keyword -Context 0,2 |',
    '        Select-Object -Unique Path, Line',
    '    ',
    '    if ($Results) {',
    '        Write-Host "Found $($Results.Count) matches:" -ForegroundColor Green',
    '        $Results | ForEach-Object {',
    '            Write-Host "  $($_.Path)" -ForegroundColor Cyan',
    '            Write-Host "    $($_.Line)" -ForegroundColor Gray',
    '            Write-Host ""',
    '        }',
    '    } else {',
    '        Write-Host "No matches found for: $Keyword" -ForegroundColor Yellow',
    '    }',
    '} else {',
    '    $Files = Get-ChildItem -Path $SearchPath -Filter "*.md" -Recurse | ',
    '        Where-Object { $_.Name -ne "README.md" } |',
    '        Sort-Object Name -Descending',
    '    ',
    '    if ($Files) {',
    '        Write-Host "All discussions ($($Files.Count) files):" -ForegroundColor Green',
    '        Write-Host ""',
    '        $Files | ForEach-Object {',
    '            $RelPath = $_.FullName.Replace($ProjectPath, "").TrimStart("\")',
    '            Write-Host "  $RelPath" -ForegroundColor Cyan',
    '        }',
    '    } else {',
    '        Write-Host "No discussions found" -ForegroundColor Yellow',
    '    }',
    '}'
)

$searchLines -join "`n" | Out-File -FilePath (Join-Path $ProjectPath "search-discussion.ps1") -Encoding utf8
Write-Host "  Created: search-discussion.ps1" -ForegroundColor Gray

# Create stats script
$statsLines = @(
    '# Discussion statistics',
    '',
    '$ProjectPath = $PSScriptRoot',
    '',
    'Write-Host "========================================" -ForegroundColor Cyan',
    'Write-Host "   Discussion Statistics" -ForegroundColor Cyan',
    'Write-Host "========================================" -ForegroundColor Cyan',
    'Write-Host ""',
    '',
    '$AllFiles = Get-ChildItem -Path $ProjectPath -Filter "*.md" -Recurse | ',
    '    Where-Object { $_.Name -ne "README.md" }',
    '',
    '$TotalFiles = $AllFiles.Count',
    'Write-Host "Total discussions: $TotalFiles" -ForegroundColor Green',
    'Write-Host ""',
    '',
    '$Categories = Get-ChildItem -Path $ProjectPath -Directory',
    'foreach ($Cat in $Categories) {',
    '    $CatFiles = Get-ChildItem -Path $Cat.FullName -Filter "*.md" | ',
    '        Where-Object { $_.Name -ne "README.md" }',
    '    ',
    '    Write-Host "$($Cat.Name): $($CatFiles.Count) discussions" -ForegroundColor Yellow',
    '    ',
    '    if ($CatFiles.Count -gt 0) {',
    '        $Latest = $CatFiles | Sort-Object LastWriteTime -Descending | Select-Object -First 1',
    '        Write-Host "  Latest: $($Latest.Name)" -ForegroundColor Gray',
    '        Write-Host "  Modified: $($Latest.LastWriteTime.ToString(''yyyy-MM-dd HH:mm''))" -ForegroundColor Gray',
    '    }',
    '    Write-Host ""',
    '}',
    '',
    '# Recent activity',
    'Write-Host "Recent activity (last 5):" -ForegroundColor Cyan',
    '$Recent = $AllFiles | Sort-Object LastWriteTime -Descending | Select-Object -First 5',
    '$Recent | ForEach-Object {',
    '    $RelPath = $_.FullName.Replace($ProjectPath, "").TrimStart("\")',
    '    Write-Host "  $($_.LastWriteTime.ToString(''yyyy-MM-dd HH:mm'')) - $RelPath" -ForegroundColor Gray',
    '}'
)

$statsLines -join "`n" | Out-File -FilePath (Join-Path $ProjectPath "stats.ps1") -Encoding utf8
Write-Host "  Created: stats.ps1" -ForegroundColor Gray

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "         Setup Complete!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Discussion space created at: $ProjectPath" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  1. Create a new discussion:" -ForegroundColor Cyan
Write-Host "     cd $ProjectPath" -ForegroundColor Gray
Write-Host "     .\new-discussion.ps1 -ProjectName '$ProjectName' -Category 'ideas' -Title 'my-topic'" -ForegroundColor Gray
Write-Host ""
Write-Host "  2. Search discussions:" -ForegroundColor Cyan
Write-Host "     cd $ProjectPath" -ForegroundColor Gray
Write-Host "     .\search-discussion.ps1 -Keyword 'search-term'" -ForegroundColor Gray
Write-Host ""
Write-Host "  3. View statistics:" -ForegroundColor Cyan
Write-Host "     cd $ProjectPath" -ForegroundColor Gray
Write-Host "     .\stats.ps1" -ForegroundColor Gray
Write-Host ""
Write-Host "Happy collaborating! " -ForegroundColor Green
Write-Host ""
