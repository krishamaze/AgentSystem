# Update project progress
param(
    [string]$ProjectName,
    [int]$MilestoneId,
    [string]$Status
)

if (-not $ProjectName) {
    Write-Output "Usage: .\update-project.ps1 -ProjectName <name> -MilestoneId <id> -Status <PENDING|IN_PROGRESS|COMPLETED>"
    exit
}

$progressFile = ".\Projects\$ProjectName\progress.json"
$progress = Get-Content $progressFile | ConvertFrom-Json

# Update milestone
$milestone = $progress.Milestones | Where-Object { $_.Id -eq $MilestoneId }
if ($milestone) {
    $milestone.Status = $Status
    if ($Status -eq "IN_PROGRESS" -and -not $milestone.StartDate) {
        $milestone.StartDate = Get-Date -Format "yyyy-MM-dd"
    }
    if ($Status -eq "COMPLETED") {
        $milestone.CompletedDate = Get-Date -Format "yyyy-MM-dd"
        $progress.CompletedMilestones++
    }
}

$progress.LastUpdated = Get-Date -Format "yyyy-MM-dd HH:mm"
$progress | ConvertTo-Json -Depth 5 | Out-File $progressFile -Encoding UTF8

Write-Output "✓ Updated $ProjectName milestone $MilestoneId to $Status"
