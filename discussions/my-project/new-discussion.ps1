# Create a new discussion file

param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectName,
    
    [Parameter(Mandatory=$true)]
    [ValidateSet("ideas","technical","architecture","meetings","troubleshooting","reviews","notes")]
    [string]$Category,
    
    [Parameter(Mandatory=$true)]
    [string]$Title
)

$Date = Get-Date -Format "yyyy-MM-dd"
$FileName = "$Date-$Title.md"
$FilePath = ".\discussions\$ProjectName\$Category\$FileName"

if (Test-Path $FilePath) {
    Write-Host "Error: File already exists: $FilePath" -ForegroundColor Red
    exit 1
}

$ContentLines = @(
    "# $Title",
    "",
    "**Date**: $Date",
    "**Participants**: @",
    "**Status**: Open",
    "",
    "## Context",
    "",
    "<!-- Describe the background and context of this discussion -->",
    "",
    "## Key Points",
    "",
    "- ",
    "",
    "## Decisions Made",
    "",
    "<!-- Document any decisions made during this discussion -->",
    "",
    "## Action Items",
    "",
    "- [ ] Task 1 - @assignee",
    "",
    "## Related Discussions",
    "",
    "<!-- Link to related discussions -->"
)

$ContentLines -join "`n" | Out-File -FilePath $FilePath -Encoding utf8
Write-Host "Created: $FilePath" -ForegroundColor Green
Write-Host "Opening in default editor..." -ForegroundColor Yellow
& $FilePath
