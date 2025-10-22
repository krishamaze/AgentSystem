param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("repomix", "gitingest", "both", "clipboard")]
    [string]$Tool = "both",
    
    [Parameter(Mandatory=$false)]
    [string]$OutputDir = ".context",
    
    [Parameter(Mandatory=$false)]
    [switch]$CopyToClipboard
)

$ErrorActionPreference = "Stop"

Write-Host "`n=== AgentSystem Context Generator ===" -ForegroundColor Cyan
Write-Host "Tool: $Tool" -ForegroundColor Yellow
Write-Host "Output: $OutputDir`n" -ForegroundColor Yellow

New-Item -Path $OutputDir -ItemType Directory -Force | Out-Null

$results = @()

if ($Tool -eq "repomix" -or $Tool -eq "both") {
    Write-Host "[1/2] Generating Repomix context..." -ForegroundColor Green
    $repomixOutput = "$OutputDir\repomix-context.txt"
    repomix --output $repomixOutput 2>&1 | Out-Null
    $size = (Get-Item $repomixOutput).Length / 1KB
    $results += "Repomix: $([math]::Round($size, 2)) KB"
    Write-Host "  ✓ $repomixOutput ($([math]::Round($size, 2)) KB)" -ForegroundColor Cyan
}

if ($Tool -eq "gitingest" -or $Tool -eq "both") {
    Write-Host "[2/2] Generating Gitingest context..." -ForegroundColor Green
    $gitingestOutput = "$OutputDir\gitingest-context.txt"
    gitingest . --output $gitingestOutput 2>&1 | Out-Null
    $size = (Get-Item $gitingestOutput).Length / 1KB
    $results += "Gitingest: $([math]::Round($size, 2)) KB"
    Write-Host "  ✓ $gitingestOutput ($([math]::Round($size, 2)) KB)" -ForegroundColor Cyan
}

if ($CopyToClipboard -or $Tool -eq "clipboard") {
    Write-Host "`nCopying to clipboard..." -ForegroundColor Green
    $clipFile = if (Test-Path "$OutputDir\repomix-context.txt") { "$OutputDir\repomix-context.txt" } else { "$OutputDir\gitingest-context.txt" }
    Get-Content $clipFile | Set-Clipboard
    Write-Host "  ✓ Copied to clipboard" -ForegroundColor Cyan
}

Write-Host "`n=== Summary ===" -ForegroundColor Cyan
$results | ForEach-Object { Write-Host "  $_" -ForegroundColor White }
Write-Host "`nContext files: $OutputDir`n" -ForegroundColor Green
