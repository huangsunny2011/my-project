# Discussion statistics

$ProjectPath = $PSScriptRoot

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Discussion Statistics" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$AllFiles = Get-ChildItem -Path $ProjectPath -Filter "*.md" -Recurse | 
    Where-Object { $_.Name -ne "README.md" }

$TotalFiles = $AllFiles.Count
Write-Host "Total discussions: $TotalFiles" -ForegroundColor Green
Write-Host ""

$Categories = Get-ChildItem -Path $ProjectPath -Directory
foreach ($Cat in $Categories) {
    $CatFiles = Get-ChildItem -Path $Cat.FullName -Filter "*.md" | 
        Where-Object { $_.Name -ne "README.md" }
    
    Write-Host "$($Cat.Name): $($CatFiles.Count) discussions" -ForegroundColor Yellow
    
    if ($CatFiles.Count -gt 0) {
        $Latest = $CatFiles | Sort-Object LastWriteTime -Descending | Select-Object -First 1
        Write-Host "  Latest: $($Latest.Name)" -ForegroundColor Gray
        Write-Host "  Modified: $($Latest.LastWriteTime.ToString('yyyy-MM-dd HH:mm'))" -ForegroundColor Gray
    }
    Write-Host ""
}

# Recent activity
Write-Host "Recent activity (last 5):" -ForegroundColor Cyan
$Recent = $AllFiles | Sort-Object LastWriteTime -Descending | Select-Object -First 5
$Recent | ForEach-Object {
    $RelPath = $_.FullName.Replace($ProjectPath, "").TrimStart("\")
    Write-Host "  $($_.LastWriteTime.ToString('yyyy-MM-dd HH:mm')) - $RelPath" -ForegroundColor Gray
}
