<#
.SYNOPSIS
    Update project progress and milestone status
.DESCRIPTION
    Tracks milestone completion, updates progress.json, and logs changes to roadmap.md
.EXAMPLE
    .\update-project-progress.ps1 -ProjectName "my-app" -MilestoneId 1 -Status "IN_PROGRESS"
    .\update-project-progress.ps1 -ProjectName "my-app" -MilestoneId 2 -Status "COMPLETE"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectName,
    
    [Parameter(Mandatory=$false)]
    [int]$MilestoneId,
    
    [Parameter(Mandatory=$false)]
    [ValidateSet("PENDING", "IN_PROGRESS", "COMPLETE", "BLOCKED")]
    [string]$Status,
    
    [Parameter(Mandatory=$false)]
    [string]$Note = ""
)

function Update-ProjectProgress {
    param(
        [string]$Name,
        [int]$Milestone,
        [string]$NewStatus,
        [string]$UpdateNote
    )
    
    Write-Host "=== PROJECT PROGRESS UPDATE ===" -ForegroundColor Cyan
    
    $agentProjectDir = "D:\AgentSystem\Projects\$Name"
    $progressFile = "$agentProjectDir\progress.json"
    $roadmapFile = "$agentProjectDir\roadmap.md"
    
    if (-not (Test-Path $progressFile)) {
        Write-Host "? Project not initialized: $Name" -ForegroundColor Red
        Write-Host "Run: .\project-init.ps1 -ProjectName '$Name' -ProjectPath 'D:\$Name'" -ForegroundColor Yellow
        return
    }
    
    # Load progress data
    $progress = Get-Content $progressFile | ConvertFrom-Json
    
    # If no milestone specified, show current status
    if ($Milestone -eq 0) {
        Write-Host "`n[PROJECT STATUS: $Name]" -ForegroundColor Yellow
        Write-Host "Vision: $($progress.Vision)" -ForegroundColor White
        Write-Host "Progress: $($progress.CompletedMilestones)/$($progress.TotalMilestones) milestones complete" -ForegroundColor White
        Write-Host "`nMilestones:" -ForegroundColor Yellow
        
        foreach ($m in $progress.Milestones) {
            $color = switch ($m.Status) {
                "COMPLETE" { "Green" }
                "IN_PROGRESS" { "Cyan" }
                "BLOCKED" { "Red" }
                default { "Gray" }
            }
            Write-Host "  [$($m.Status)] Milestone $($m.Id): $($m.Name)" -ForegroundColor $color
        }
        
        Write-Host "`nCurrent Phase: Milestone $($progress.CurrentMilestoneId)" -ForegroundColor Cyan
        return
    }
    
    # Find milestone
    $milestoneObj = $progress.Milestones | Where-Object { $_.Id -eq $Milestone }
    
    if (-not $milestoneObj) {
        Write-Host "? Milestone $Milestone not found" -ForegroundColor Red
        return
    }
    
    $oldStatus = $milestoneObj.Status
    $milestoneObj.Status = $NewStatus
    
    # Update timestamps
    if ($NewStatus -eq "IN_PROGRESS" -and [string]::IsNullOrEmpty($milestoneObj.StartDate)) {
        $milestoneObj.StartDate = Get-Date -Format "yyyy-MM-dd"
    }
    
    if ($NewStatus -eq "COMPLETE") {
        $milestoneObj.CompletedDate = Get-Date -Format "yyyy-MM-dd"
        $progress.CompletedMilestones++
        
        # Auto-advance to next milestone
        if ($Milestone -eq $progress.CurrentMilestoneId -and $Milestone -lt $progress.TotalMilestones) {
            $progress.CurrentMilestoneId++
            Write-Host "? Auto-advanced to Milestone $($progress.CurrentMilestoneId)" -ForegroundColor Green
        }
    }
    
    $progress.LastUpdated = Get-Date -Format "yyyy-MM-dd HH:mm"
    
    # Save progress
    $progress | ConvertTo-Json -Depth 10 | Set-Content $progressFile
    Write-Host "? Progress updated: Milestone $Milestone ($oldStatus ? $NewStatus)" -ForegroundColor Green
    
    # Update roadmap.md
    if (Test-Path $roadmapFile) {
        $roadmapContent = Get-Content $roadmapFile -Raw
        
        # Update milestone status in roadmap
        $roadmapContent = $roadmapContent -replace "(\#\#\# Milestone $Milestone:.*?- \*\*Status:\*\*\s+)\w+", "`${1}$NewStatus"
        
        if ($NewStatus -eq "IN_PROGRESS") {
            $roadmapContent = $roadmapContent -replace "(\#\#\# Milestone $Milestone:.*?- \*\*Started:\*\*\s+)[^\r\n]*", "`${1}$($milestoneObj.StartDate)"
        }
        
        if ($NewStatus -eq "COMPLETE") {
            $roadmapContent = $roadmapContent -replace "(\#\#\# Milestone $Milestone:.*?- \*\*Completed:\*\*\s+)[^\r\n]*", "`${1}$($milestoneObj.CompletedDate)"
        }
        
        # Update progress section
        $roadmapContent = $roadmapContent -replace "(\*\*Progress:\*\*\s+)\d+/\d+", "`${1}$($progress.CompletedMilestones)/$($progress.TotalMilestones)"
        
        # Update last updated timestamp
        $roadmapContent = $roadmapContent -replace "(\*Last Updated:\*\*\s+)[^\*]*", "`${1}$(Get-Date -Format 'yyyy-MM-dd HH:mm')*"
        
        # Add progress log entry
        $logEntry = @"

### $(Get-Date -Format "yyyy-MM-dd HH:mm")
- Milestone $Milestone status: $oldStatus ? $NewStatus
$(if($UpdateNote){"- Note: $UpdateNote"})
- Progress: $($progress.CompletedMilestones)/$($progress.TotalMilestones) milestones complete

"@
        $roadmapContent = $roadmapContent -replace "(## Progress Log)", "`$1$logEntry"
        
        Set-Content $roadmapFile -Value $roadmapContent
        Write-Host "? Roadmap updated with progress log" -ForegroundColor Green
    }
    
    # Summary
    Write-Host "`n[UPDATE SUMMARY]" -ForegroundColor Cyan
    Write-Host "  Milestone: $Milestone - $($milestoneObj.Name)" -ForegroundColor White
    Write-Host "  Status: $oldStatus ? $NewStatus" -ForegroundColor White
    Write-Host "  Overall Progress: $($progress.CompletedMilestones)/$($progress.TotalMilestones) ($([math]::Round(($progress.CompletedMilestones/$progress.TotalMilestones)*100, 0))%)" -ForegroundColor White
    
    if ($NewStatus -eq "COMPLETE") {
        Write-Host "`n?? Milestone $Milestone COMPLETE!" -ForegroundColor Green
        
        if ($progress.CompletedMilestones -eq $progress.TotalMilestones) {
            Write-Host "?? PROJECT COMPLETE! All milestones achieved!" -ForegroundColor Green
        }
    }
}

Update-ProjectProgress -Name $ProjectName -Milestone $MilestoneId -NewStatus $Status -UpdateNote $Note
