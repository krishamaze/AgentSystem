<#
.SYNOPSIS
    Intelligent Agent Resurrection System
.DESCRIPTION
    Analyzes agent brain state and provides context-aware recommendations for next actions.
    Replaces legacy raw brain dump with intelligent parsing and interactive menu.
.EXAMPLE
    .\resurrect-me.ps1
    Displays agent status, pending tasks, active projects, and recommendations.
#>

function Parse-BrainFiles {
    param([string]$AgentName = "Agent_Primary")
    
    $brainPath = "D:\AgentSystem\$AgentName\brain"
    $result = @{
        AgentName = $AgentName
        Learnings = 0
        Tasks = @()
        Projects = @()
        EvolutionEntries = @()
    }
    
    # Parse learned-knowledge.md
    if (Test-Path "$brainPath\learned-knowledge.md") {
        $content = Get-Content "$brainPath\learned-knowledge.md" -Raw
        $result.Learnings = ([regex]::Matches($content, '(?m)^## Learning:')).Count
    }
    
    # Parse evolution-log.md (last 5 entries)
    if (Test-Path "$brainPath\evolution-log.md") {
        $lines = Get-Content "$brainPath\evolution-log.md" | Where-Object { $_ -match '^\s*-\s*\[' }
        $result.EvolutionEntries = $lines | Select-Object -Last 5
    }
    
    # Extract pending tasks - read each file individually
    $allContent = ""
    Get-ChildItem "$brainPath\*.md" -ErrorAction SilentlyContinue | ForEach-Object {
        $allContent += Get-Content $_.FullName -Raw
    }
    
    $taskPatterns = 'TODO:|Pending:|Next:|CRITICAL:|Phase \d+:|Will be|Expected|Awaiting'
    $matches = [regex]::Matches($allContent, "(?m)^.*?($taskPatterns).*$")
    $result.Tasks = $matches | ForEach-Object { $_.Value.Trim() } | Select-Object -First 10
    
    # Scan Projects directory
    $projectsPath = "D:\AgentSystem\Projects"
    if (Test-Path $projectsPath) {
        $result.Projects = Get-ChildItem $projectsPath -Directory -ErrorAction SilentlyContinue | ForEach-Object {
            $daysSince = ((Get-Date) - $_.LastWriteTime).TotalDays
            @{
                Name = $_.Name
                Path = $_.FullName
                LastUpdate = $_.LastWriteTime
                DaysSinceUpdate = [math]::Round($daysSince, 0)
            }
        } | Sort-Object DaysSinceUpdate | Select-Object -First 5
    }
    
    return $result
}

function Show-ResurrectionMenu {
    Clear-Host
    
    $state = Parse-BrainFiles
    
    Write-Host "-------------------------------------------------------" -ForegroundColor Cyan
    Write-Host " ?? AGENT RESURRECTION: $($state.AgentName)" -ForegroundColor Yellow
    Write-Host "-------------------------------------------------------" -ForegroundColor Cyan
    
    Write-Host "`n?? BRAIN STATE SUMMARY" -ForegroundColor Green
    Write-Host "  Learnings: $($state.Learnings)" -ForegroundColor White
    Write-Host "  Pending Tasks: $($state.Tasks.Count)" -ForegroundColor White
    Write-Host "  Active Projects: $($state.Projects.Count)" -ForegroundColor White
    
    if ($state.Tasks.Count -gt 0) {
        Write-Host "`n?? TOP PENDING TASKS" -ForegroundColor Yellow
        $state.Tasks | Select-Object -First 5 | ForEach-Object { 
            $priority = if ($_ -match 'CRITICAL') { "Red" } elseif ($_ -match 'TODO|Pending') { "Yellow" } else { "Cyan" }
            Write-Host "  • $_" -ForegroundColor $priority
        }
    }
    
    if ($state.Projects.Count -gt 0) {
        Write-Host "`n?? ACTIVE PROJECTS" -ForegroundColor Yellow
        $state.Projects | ForEach-Object {
            $color = if ($_.DaysSinceUpdate -lt 7) { "Green" } elseif ($_.DaysSinceUpdate -lt 30) { "Yellow" } else { "Red" }
            Write-Host "  • $($_.Name) (Updated: $($_.DaysSinceUpdate)d ago)" -ForegroundColor $color
        }
    }
    
    Write-Host "`n?? LATEST EVOLUTION" -ForegroundColor Yellow
    $state.EvolutionEntries | Select-Object -Last 3 | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }
    
    Write-Host "`n-------------------------------------------------------" -ForegroundColor Cyan
    Write-Host "OPTIONS:" -ForegroundColor Green
    Write-Host "  [1] View all pending tasks" -ForegroundColor White
    Write-Host "  [2] View all projects" -ForegroundColor White
    Write-Host "  [3] Full brain dump (legacy)" -ForegroundColor White
    Write-Host "  [4] Exit" -ForegroundColor White
    Write-Host "-------------------------------------------------------" -ForegroundColor Cyan
    
    $choice = Read-Host "`nSelect option"
    
    switch ($choice) {
        "1" { 
            Write-Host "`n?? ALL PENDING TASKS:" -ForegroundColor Yellow
            $state.Tasks | ForEach-Object { Write-Host "  • $_" }
        }
        "2" { 
            Write-Host "`n?? ALL PROJECTS:" -ForegroundColor Yellow
            $state.Projects | ForEach-Object { 
                Write-Host "`n  $($_.Name)"
                Write-Host "    Path: $($_.Path)" -ForegroundColor Gray
                Write-Host "    Last Updated: $($_.LastUpdate)" -ForegroundColor Gray
            }
        }
        "3" { 
            Write-Host "`n=== FULL BRAIN DUMP ===" -ForegroundColor Cyan
            Get-ChildItem "D:\AgentSystem\$($state.AgentName)\brain\*.md" | ForEach-Object {
                Write-Host "`n=== $($_.Name) ===" -ForegroundColor Yellow
                Get-Content $_.FullName
            }
        }
        "4" { exit }
    }
}

# Execute
Show-ResurrectionMenu
