param([string]$Namespace)

if (-not $Namespace) {
    Write-Output "Usage: .\load-memory.ps1 -Namespace <path>"
    Write-Output "Available namespaces:"
    $index = Get-Content ".meta\system-index.json" | ConvertFrom-Json
    $index.namespaces | ForEach-Object { Write-Output "  $_" }
    exit
}

# Route to correct memory location
$memoryPath = ".\memory\" + ($Namespace -replace "^/", "" -replace "/", "\")

# New structured memory paths
if ($Namespace -eq "/system") {
    Write-Output "=== SYSTEM MEMORY (STRUCTURED) ==="
    Write-Output "`nCore Knowledge:"
    Get-Content ".\memory\system\core\knowledge.md" -ErrorAction SilentlyContinue | Select-Object -First 30
    Write-Output "`n... (use -Namespace /system/core for full)"
    Write-Output "`nDecisions: memory/system/decisions/architectural.md"
    Write-Output "Feedback: memory/system/feedback/improvements.md"
    return
}

if (Test-Path $memoryPath) {
    Write-Output "=== MEMORY: $Namespace ==="
    Get-ChildItem $memoryPath -Recurse -File | ForEach-Object {
        Write-Output "`n--- $($_.Name) ---"
        Get-Content $_.FullName
    }
} else {
    Write-Output "Memory namespace not found: $Namespace"
    Write-Output "Create it with: New-Item -ItemType Directory -Path '$memoryPath' -Force"
}

