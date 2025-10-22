param([string]$ProjectName)

if (-not $ProjectName) {
    Write-Output "Usage: .\load-project.ps1 -ProjectName <name>"
    exit
}

$registry = Get-Content ".meta\tenant-registry.json" | ConvertFrom-Json
$project = $registry.project_tenants | Where-Object { $_.name -eq $ProjectName }

if (-not $project) {
    Write-Output "Project not found: $ProjectName"
    exit
}

Write-Output "=== LOADING PROJECT: $ProjectName ==="

# Load project context
$contextPath = ".\Projects\$ProjectName\context.md"
if (Test-Path $contextPath) {
    Write-Output "`n--- Context ---"
    Get-Content $contextPath
}

# Load progress
$progressPath = ".\Projects\$ProjectName\progress.json"
if (Test-Path $progressPath) {
    Write-Output "`n`n--- Progress ---"
    $progress = Get-Content $progressPath | ConvertFrom-Json
    Write-Output "Vision: $($progress.Vision)"
    Write-Output "Milestones: $($progress.CompletedMilestones)/$($progress.TotalMilestones)"
    Write-Output "`nCurrent Milestone:"
    $current = $progress.Milestones | Where-Object { $_.Id -eq $progress.CurrentMilestoneId }
    Write-Output "  ID: $($current.Id)"
    Write-Output "  Name: $($current.Name)"
    Write-Output "  Status: $($current.Status)"
}

# Show tenant info
Write-Output "`n`n--- Tenant Info ---"
Write-Output "Supabase: $($project.supabase_url)"
Write-Output "Namespace: $($project.namespace)"
Write-Output "Repo: $($project.repo_path)"

Write-Output "`n✓ Project loaded - work in context of $ProjectName"
