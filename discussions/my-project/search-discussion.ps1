# Search discussions

param(
    [Parameter(Mandatory=$false)]
    [string]$Keyword,
    
    [Parameter(Mandatory=$false)]
    [string]$Category
)

$ProjectPath = $PSScriptRoot

Write-Host "Searching discussions..." -ForegroundColor Yellow
Write-Host ""

$SearchPath = if ($Category) {
    Join-Path $ProjectPath $Category
} else {
    $ProjectPath
}

if ($Keyword) {
    $Results = Get-ChildItem -Path $SearchPath -Filter "*.md" -Recurse | 
        Where-Object { $_.Name -ne "README.md" } |
        Select-String -Pattern $Keyword -Context 0,2 |
        Select-Object -Unique Path, Line
    
    if ($Results) {
        Write-Host "Found $($Results.Count) matches:" -ForegroundColor Green
        $Results | ForEach-Object {
            Write-Host "  $($_.Path)" -ForegroundColor Cyan
            Write-Host "    $($_.Line)" -ForegroundColor Gray
            Write-Host ""
        }
    } else {
        Write-Host "No matches found for: $Keyword" -ForegroundColor Yellow
    }
} else {
    $Files = Get-ChildItem -Path $SearchPath -Filter "*.md" -Recurse | 
        Where-Object { $_.Name -ne "README.md" } |
        Sort-Object Name -Descending
    
    if ($Files) {
        Write-Host "All discussions ($($Files.Count) files):" -ForegroundColor Green
        Write-Host ""
        $Files | ForEach-Object {
            $RelPath = $_.FullName.Replace($ProjectPath, "").TrimStart("\")
            Write-Host "  $RelPath" -ForegroundColor Cyan
        }
    } else {
        Write-Host "No discussions found" -ForegroundColor Yellow
    }
}
