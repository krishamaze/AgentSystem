<#
.SYNOPSIS
    Initialize a new project with vision, roadmap, and milestone tracking
.DESCRIPTION
    Captures project vision, generates roadmap with milestones, and sets up
    automated progress tracking for the agent system.
.EXAMPLE
    .\project-init.ps1 -ProjectName "my-app" -ProjectPath "D:\my-app"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectName,
    
    [Parameter(Mandatory=$true)]
    [string]$ProjectPath,
    
    [Parameter(Mandatory=$false)]
    [string]$Vision = ""
)

function Initialize-ProjectWithPlanning {
    param(
        [string]$Name,
        [string]$Path,
        [string]$UserVision
    )
    
    Write-Host "=== PROJECT PLANNING INITIALIZATION ===" -ForegroundColor Cyan
    
    # Validate project exists
    if (-not (Test-Path $Path)) {
        Write-Host "? Project directory does not exist: $Path" -ForegroundColor Red
        return
    }
    
    $agentProjectDir = "D:\AgentSystem\Projects\$Name"
    
    # Create project directory if needed
    if (-not (Test-Path $agentProjectDir)) {
        New-Item -Path $agentProjectDir -ItemType Directory -Force | Out-Null
        Write-Host "? Created project tracking directory" -ForegroundColor Green
    }
    
    # Capture Vision (interactive if not provided)
    if ([string]::IsNullOrWhiteSpace($UserVision)) {
        Write-Host "`n[VISION CAPTURE]" -ForegroundColor Yellow
        Write-Host "What are you building? (Purpose, goals, target users)" -ForegroundColor White
        $UserVision = Read-Host "Vision"
    }
    
    # Capture Tech Stack
    Write-Host "`n[TECH STACK]" -ForegroundColor Yellow
    $runtime = Read-Host "Runtime (e.g., Node.js, Python, Deno)"
    $framework = Read-Host "Framework (e.g., React, FastAPI, Express)"
    $database = Read-Host "Database (e.g., PostgreSQL, MongoDB, SQLite)"
    
    # Capture Milestones
    Write-Host "`n[MILESTONE PLANNING]" -ForegroundColor Yellow
    Write-Host "Define project milestones (type 'done' when finished):" -ForegroundColor White
    $milestones = @()
    $index = 1
    
    while ($true) {
        $milestone = Read-Host "Milestone $index"
        if ($milestone -eq "done" -or [string]::IsNullOrWhiteSpace($milestone)) { break }
        $milestones += @{
            Id = $index
            Name = $milestone
            Status = "PENDING"
            StartDate = $null
            CompletedDate = $null
            Dependencies = @()
        }
        $index++
    }
    
    # Generate Roadmap
    $roadmapContent = @"
# Project Roadmap: $Name

## Vision
$UserVision

## Tech Stack
- **Runtime:** $runtime
- **Framework:** $framework
- **Database:** $database

## Milestones

"@
    
    foreach ($m in $milestones) {
        $roadmapContent += @"

### Milestone $($m.Id): $($m.Name)
- **Status:** $($m.Status)
- **Started:** $($m.StartDate)
- **Completed:** $($m.CompletedDate)
- **Dependencies:** $(if($m.Dependencies.Count -gt 0){$m.Dependencies -join ', '}else{'None'})
- **Tasks:**
  - [ ] [Add tasks here]

"@
    }
    
    $roadmapContent += @"

## Current Phase
**Active Milestone:** Milestone 1 (if any)
**Progress:** 0/$($milestones.Count) milestones complete

## Next Steps
1. [Agent will auto-populate based on active milestone]
2. [Review and update as work progresses]

## Progress Log
### $(Get-Date -Format "yyyy-MM-dd")
- Project initialized with $($milestones.Count) milestones
- Vision captured and documented
- Roadmap created

---
*Auto-tracked by Agent System*
*Last Updated: $(Get-Date -Format "yyyy-MM-dd HH:mm")*
"@
    
    Set-Content -Path "$agentProjectDir\roadmap.md" -Value $roadmapContent
    Write-Host "? Roadmap created: roadmap.md" -ForegroundColor Green
    
    # Create progress tracker JSON
    $progressData = @{
        ProjectName = $Name
        ProjectPath = $Path
        Vision = $UserVision
        InitializedDate = Get-Date -Format "yyyy-MM-dd"
        TechStack = @{
            Runtime = $runtime
            Framework = $framework
            Database = $database
        }
        Milestones = $milestones
        CurrentMilestoneId = if($milestones.Count -gt 0){1}else{$null}
        CompletedMilestones = 0
        TotalMilestones = $milestones.Count
        LastUpdated = Get-Date -Format "yyyy-MM-dd HH:mm"
    } | ConvertTo-Json -Depth 10
    
    Set-Content -Path "$agentProjectDir\progress.json" -Value $progressData
    Write-Host "? Progress tracker created: progress.json" -ForegroundColor Green
    
    # Update context.md with planning info
    $contextUpdate = @"

## Project Planning
- **Vision:** $UserVision
- **Milestones:** $($milestones.Count) defined
- **Current Phase:** Milestone 1 ($(if($milestones.Count -gt 0){$milestones[0].Name}else{'Not defined'}))
- **Progress:** 0% complete
- **Roadmap:** See roadmap.md for full plan

"@
    
    if (Test-Path "$agentProjectDir\context.md") {
        Add-Content -Path "$agentProjectDir\context.md" -Value $contextUpdate
        Write-Host "? Context updated with planning information" -ForegroundColor Green
    }
    
    # Summary
    Write-Host "`n[PLANNING SUMMARY]" -ForegroundColor Cyan
    Write-Host "  Project: $Name" -ForegroundColor White
    Write-Host "  Vision: $UserVision" -ForegroundColor White
    Write-Host "  Milestones: $($milestones.Count)" -ForegroundColor White
    Write-Host "  Tech Stack: $runtime + $framework + $database" -ForegroundColor White
    Write-Host "  Files Created:" -ForegroundColor White
    Write-Host "    - roadmap.md (human-readable plan)" -ForegroundColor Gray
    Write-Host "    - progress.json (machine-readable tracker)" -ForegroundColor Gray
    Write-Host "    - context.md (updated)" -ForegroundColor Gray
    
    Write-Host "`n? Project planning complete! Agents now understand your vision." -ForegroundColor Green
}

Initialize-ProjectWithPlanning -Name $ProjectName -Path $ProjectPath -UserVision $Vision
