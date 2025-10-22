param([string]$ProjectName)

if (-not $ProjectName) {
    Write-Output "Usage: .\switch-project.ps1 -ProjectName <name>"
    exit
}

# Update system index
$index = Get-Content ".meta\system-index.json" | ConvertFrom-Json
$index.active_context.current_project = $ProjectName
$index.active_context.last_active = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$index | ConvertTo-Json -Depth 5 | Out-File ".meta\system-index.json" -Encoding UTF8

Write-Output "✓ Switched to: $ProjectName"
Write-Output "`nLoad full context with: .\tools\load-project.ps1 -ProjectName $ProjectName"
