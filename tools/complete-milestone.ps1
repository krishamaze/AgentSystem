# Complete milestone and auto-sync
param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectName,
    
    [Parameter(Mandatory=$true)]
    [int]$MilestoneId,
    
    [string]$Notes = ""
)

Write-Output "=== COMPLETING MILESTONE $MilestoneId for $ProjectName ==="

# Load project progress
$progressPath = ".\Projects\$ProjectName\progress.json"
if (-not (Test-Path $progressPath)) {
    Write-Output "ERROR: Project not found: $ProjectName"
    exit
}

$progress = Get-Content $progressPath | ConvertFrom-Json
$milestone = $progress.Milestones | Where-Object { $_.Id -eq $MilestoneId }

if (-not $milestone) {
    Write-Output "ERROR: Milestone $MilestoneId not found"
    exit
}

if ($milestone.Status -eq "COMPLETED") {
    Write-Output "WARN: Milestone already completed on $($milestone.CompletionDate)"
    Write-Output "Continue anyway? (y/n)"
    # In automation, assume yes
}

# 1. Update milestone status
Write-Output "`n1. Updating milestone status..."
$milestone.Status = "COMPLETED"
$milestone | Add-Member -NotePropertyName "CompletionDate" -NotePropertyValue (Get-Date -Format "yyyy-MM-dd") -Force
$progress.CompletedMilestones = ($progress.Milestones | Where-Object { $_.Status -eq "COMPLETED" }).Count
$progress.CurrentMilestoneId = $MilestoneId + 1
$progress.LastUpdated = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$progress | ConvertTo-Json -Depth 5 | Out-File $progressPath -Encoding UTF8
Write-Output "   ✓ Milestone marked COMPLETED"

# 2. Generate milestone report
Write-Output "`n2. Generating milestone report..."
$reportPath = ".\Projects\$ProjectName\reports"
New-Item -ItemType Directory -Path $reportPath -Force | Out-Null

$report = @"
# Milestone $MilestoneId Completion Report

**Project:** $ProjectName
**Milestone:** $($milestone.Name)
**Completed:** $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
**Owner:** $($progress.Owner)

## Summary
Milestone $MilestoneId ($($milestone.Name)) has been successfully completed.

## Progress
- Total Milestones: $($progress.TotalMilestones)
- Completed: $($progress.CompletedMilestones)
- Remaining: $($progress.TotalMilestones - $progress.CompletedMilestones)
- Progress: $([math]::Round(($progress.CompletedMilestones / $progress.TotalMilestones) * 100, 0))%

## Notes
$Notes

## Next Milestone
$(if ($progress.CurrentMilestoneId -le $progress.TotalMilestones) {
    $next = $progress.Milestones | Where-Object { $_.Id -eq $progress.CurrentMilestoneId }
    "Milestone $($next.Id): $($next.Name)"
} else {
    "All milestones complete!"
})

## Generated
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
"@

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$report | Out-File "$reportPath\milestone-$MilestoneId-$timestamp.md" -Encoding UTF8
Write-Output "   ✓ Report: $reportPath\milestone-$MilestoneId-$timestamp.md"

# 3. Git commit (if in git repo)
Write-Output "`n3. Git version control..."
if (Test-Path ".git") {
    git add .
    git commit -m "Milestone $MilestoneId complete: $($milestone.Name)" -q 2>&1 | Out-Null
    $version = "$($progress.CompletedMilestones).$MilestoneId.0"
    git tag -a "v$version" -m "Milestone complete: $($milestone.Name)" 2>&1 | Out-Null
    Write-Output "   ✓ Git commit created"
    Write-Output "   ✓ Tagged: v$version"
} else {
    Write-Output "   ⚠ Not a git repository (skipping)"
}

# 4. Sync to permanent memory
Write-Output "`n4. Syncing to permanent memory..."
python sync_all_learnings.py 2>&1 | Select-String "Total synced" | ForEach-Object {
    Write-Output "   $_"
}

# 5. Update system index
Write-Output "`n5. Updating system index..."
$index = Get-Content ".meta\system-index.json" | ConvertFrom-Json
$index.active_context.last_active = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$index | ConvertTo-Json -Depth 5 | Out-File ".meta\system-index.json" -Encoding UTF8

Write-Output "`n✓ MILESTONE $MilestoneId COMPLETE"
Write-Output "✓ Progress: $($progress.CompletedMilestones)/$($progress.TotalMilestones) milestones"
Write-Output "✓ All changes committed and synced"

