# Quick project resume - shows status and suggests next action
param([string]$ProjectName)

if (-not $ProjectName) {
    Write-Output "Available projects:"
    Get-ChildItem ".\Projects" -Directory | ForEach-Object {
        Write-Output "  - $($_.Name)"
    }
    Write-Output "`nUsage: .\project-resume.ps1 -ProjectName <name>"
    exit
}

$projectPath = ".\Projects\$ProjectName"
if (-not (Test-Path $projectPath)) {
    Write-Output "Project not found: $ProjectName"
    exit
}

Write-Output "=== $ProjectName ==="

# Load progress
$progress = Get-Content "$projectPath\progress.json" | ConvertFrom-Json

Write-Output "`nVision: $($progress.Vision)"
Write-Output "Progress: $($progress.CompletedMilestones)/$($progress.TotalMilestones) milestones"
Write-Output "Last updated: $($progress.LastUpdated)"

# Find current milestone
$currentMilestone = $progress.Milestones | Where-Object { $_.Id -eq $progress.CurrentMilestoneId }
Write-Output "`n🎯 Current Milestone: $($currentMilestone.Name)"
Write-Output "   Status: $($currentMilestone.Status)"

# Show next action
Write-Output "`n📋 Suggested Actions:"
Write-Output "1. View full context: Get-Content '$projectPath\context.md'"
Write-Output "2. Open in VS Code: code '$($progress.ProjectPath)'"
Write-Output "3. Update progress: .\update-project.ps1 -ProjectName $ProjectName"
Write-Output "4. Add to resurrection: (auto-included when you run generate-init-prompt.ps1)"

# Copy project summary to clipboard for easy pasting to agent
$summary = @"
Working on: $ProjectName
Current: $($currentMilestone.Name) ($($currentMilestone.Status))
Stack: $($progress.TechStack.Framework), $($progress.TechStack.Runtime)
Path: $($progress.ProjectPath)
"@

$summary | Set-Clipboard
Write-Output "`n✓ Project summary copied to clipboard (paste to agent in new thread)"
