# Quick Start - One command to see everything
Write-Output "=== AGENTSYSTEM QUICK START ===`n"

Write-Output "System Health:"
python system_status.py 2>&1 | Select-Object -First 5

Write-Output "`nActive Projects:"
Get-ChildItem ".\Projects" -Directory | ForEach-Object {
    $name = $_.Name
    if (Test-Path "$($_.FullName)\progress.json") {
        $progress = Get-Content "$($_.FullName)\progress.json" | ConvertFrom-Json
        $inProgress = $progress.Milestones | Where-Object { $_.Status -eq "IN_PROGRESS" }
        if ($inProgress) {
            Write-Output "  🚀 $name - $($inProgress.Name)"
        }
    }
}

Write-Output "`nQuick Commands:"
Write-Output "  .\generate-init-prompt.ps1       - Start new thread"
Write-Output "  .\project-resume.ps1 -ProjectName <name> - Load project"
Write-Output "  .\maintenance.ps1                - Health check"

Write-Output "`n✨ Ready to work!"
