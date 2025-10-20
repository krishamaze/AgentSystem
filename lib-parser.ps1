# ============================================
# INTELLIGENT RESURRECTION SYSTEM - PHASE 1
# Parser Functions Module
# ============================================

function Parse-BrainFiles {
    param(
        [Parameter(Mandatory=$true)]
        [string]$AgentName
    )
    
    $brainPath = "D:\AgentSystem\$AgentName\brain"
    $result = @{
        AgentName = $AgentName
        BrainPath = $brainPath
        Learnings = @()
        EvolutionLog = @()
        MetaPrompt = ""
        CurrentTask = ""
        RawFiles = @{}
        ParseSuccess = $false
        Errors = @()
    }
    
    # Validate brain path exists
    if (-not (Test-Path $brainPath)) {
        $result.Errors += "Brain path not found: $brainPath"
        return $result
    }
    
    try {
        # === LOAD RAW FILES ===
        $files = @("meta-prompt.md", "learned-knowledge.md", "evolution-log.md", "current-task.md")
        
        foreach ($file in $files) {
            $filePath = Join-Path $brainPath $file
            if (Test-Path $filePath) {
                $result.RawFiles[$file] = Get-Content $filePath -Raw -ErrorAction SilentlyContinue
            }
        }
        
        # === EXTRACT LEARNINGS ===
        if ($result.RawFiles.ContainsKey("learned-knowledge.md")) {
            $knowledgeContent = $result.RawFiles["learned-knowledge.md"]
            
            # Regex: Match ## Learning: followed by timestamp and content until next ## or end
            $learningPattern = '(?s)## Learning:\s*([^\n]+)\n(.*?)(?=\n##|\z)'
            $matches = [regex]::Matches($knowledgeContent, $learningPattern)
            
            foreach ($match in $matches) {
                $result.Learnings += @{
                    Timestamp = $match.Groups[1].Value.Trim()
                    Content = $match.Groups[2].Value.Trim()
                }
            }
        }
        
        # === EXTRACT EVOLUTION LOG (Last 5 entries) ===
        if ($result.RawFiles.ContainsKey("evolution-log.md")) {
            $evolutionContent = $result.RawFiles["evolution-log.md"]
            
            # Extract entries that start with "- [" (timestamp format)
            $logPattern = '^- \[([^\]]+)\]\s*(.+)$'
            $logEntries = $evolutionContent -split "`n" | Where-Object { $_ -match $logPattern }
            
            # Take last 5 entries
            $result.EvolutionLog = $logEntries | Select-Object -Last 5 | ForEach-Object {
                if ($_ -match $logPattern) {
                    @{
                        Timestamp = $matches[1]
                        Entry = $matches[2]
                    }
                }
            }
        }
        
        # === EXTRACT META PROMPT ===
        if ($result.RawFiles.ContainsKey("meta-prompt.md")) {
            $result.MetaPrompt = $result.RawFiles["meta-prompt.md"]
        }
        
        # === EXTRACT CURRENT TASK ===
        if ($result.RawFiles.ContainsKey("current-task.md")) {
            $result.CurrentTask = $result.RawFiles["current-task.md"]
        }
        
        $result.ParseSuccess = $true
        
    } catch {
        $result.Errors += "Parse error: $_"
    }
    
    return $result
}

function Test-Parser {
    param([string]$AgentName)
    
    Write-Host "`n=== TESTING PARSER: $AgentName ===" -ForegroundColor Cyan
    
    $parsed = Parse-BrainFiles -AgentName $AgentName
    
    if ($parsed.ParseSuccess) {
        Write-Host "? Parse successful" -ForegroundColor Green
        Write-Host "  Learnings extracted: $($parsed.Learnings.Count)" -ForegroundColor White
        Write-Host "  Evolution entries: $($parsed.EvolutionLog.Count)" -ForegroundColor White
        Write-Host "  Meta prompt: $($parsed.MetaPrompt.Length) chars" -ForegroundColor White
        Write-Host "  Current task: $(if ($parsed.CurrentTask) { $parsed.CurrentTask.Length.ToString() + ' chars' } else { 'None' })" -ForegroundColor White
        
        if ($parsed.Learnings.Count -gt 0) {
            Write-Host "`n  Latest learning:" -ForegroundColor Yellow
            Write-Host "    Time: $($parsed.Learnings[-1].Timestamp)" -ForegroundColor White
            Write-Host "    Preview: $($parsed.Learnings[-1].Content.Substring(0, [Math]::Min(100, $parsed.Learnings[-1].Content.Length)))..." -ForegroundColor Gray
        }
    } else {
        Write-Host "? Parse failed" -ForegroundColor Red
        foreach ($error in $parsed.Errors) {
            Write-Host "  Error: $error" -ForegroundColor Red
        }
    }
    
    return $parsed
}

# Export functions
Export-ModuleMember -Function Parse-BrainFiles, Test-Parser


function Extract-PendingTasks {
    param(
        [Parameter(Mandatory=$true)]
        [hashtable]$ParsedBrain
    )
    
    $tasks = @()
    $taskId = 1
    
    # Task indicator patterns
    $taskPattern = '(Next|TODO|Pending|Phase\s+\d+|Will be|Expected|Awaiting|DELIVERABLE|Implementation|Required):\s*([^\n]+)'
    
    # Priority keywords (case-insensitive)
    $criticalKeywords = @('CRITICAL', 'URGENT', 'BLOCKED', 'FAILED', 'ERROR', 'BROKEN')
    $highKeywords = @('HIGH', 'IMPORTANT', 'PRIORITY', 'MUST', 'REQUIRED')
    $mediumKeywords = @('SHOULD', 'NEEDS', 'TODO', 'PENDING')
    
    # Scan current task file (highest priority source)
    if ($ParsedBrain.CurrentTask) {
        $matches = [regex]::Matches($ParsedBrain.CurrentTask, $taskPattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
        
        foreach ($match in $matches) {
            $indicator = $match.Groups[1].Value
            $description = $match.Groups[2].Value.Trim()
            
            # Extract 2-sentence context
            $startPos = [Math]::Max(0, $match.Index - 200)
            $endPos = [Math]::Min($ParsedBrain.CurrentTask.Length, $match.Index + 300)
            $context = $ParsedBrain.CurrentTask.Substring($startPos, $endPos - $startPos).Trim()
            
            # Calculate priority score
            $priority = Get-TaskPriority -Text "$indicator $description $context" `
                -CriticalKeywords $criticalKeywords `
                -HighKeywords $highKeywords `
                -MediumKeywords $mediumKeywords
            
            $tasks += @{
                Id = $taskId++
                Source = "current-task.md"
                Indicator = $indicator
                Description = $description
                Context = $context
                Priority = $priority.Level
                PriorityScore = $priority.Score
                Keywords = $priority.Keywords
            }
        }
    }
    
    # Scan learnings (recent learnings = higher base priority)
    $learningCount = $ParsedBrain.Learnings.Count
    for ($i = $learningCount - 1; $i -ge [Math]::Max(0, $learningCount - 10); $i--) {
        $learning = $ParsedBrain.Learnings[$i]
        $matches = [regex]::Matches($learning.Content, $taskPattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
        
        foreach ($match in $matches) {
            $indicator = $match.Groups[1].Value
            $description = $match.Groups[2].Value.Trim()
            
            # Extract context
            $startPos = [Math]::Max(0, $match.Index - 150)
            $endPos = [Math]::Min($learning.Content.Length, $match.Index + 200)
            $context = $learning.Content.Substring($startPos, $endPos - $startPos).Trim()
            
            $priority = Get-TaskPriority -Text "$indicator $description $context" `
                -CriticalKeywords $criticalKeywords `
                -HighKeywords $highKeywords `
                -MediumKeywords $mediumKeywords
            
            # Boost priority for recent learnings
            $recencyBoost = [Math]::Max(0, 10 - ($learningCount - $i - 1))
            
            $tasks += @{
                Id = $taskId++
                Source = "learned-knowledge.md ($($learning.Timestamp))"
                Indicator = $indicator
                Description = $description
                Context = $context
                Priority = $priority.Level
                PriorityScore = $priority.Score + $recencyBoost
                Keywords = $priority.Keywords
            }
        }
    }
    
    # Scan evolution log
    foreach ($entry in $ParsedBrain.EvolutionLog) {
        $matches = [regex]::Matches($entry.Entry, $taskPattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
        
        foreach ($match in $matches) {
            $indicator = $match.Groups[1].Value
            $description = $match.Groups[2].Value.Trim()
            
            $priority = Get-TaskPriority -Text "$indicator $description" `
                -CriticalKeywords $criticalKeywords `
                -HighKeywords $highKeywords `
                -MediumKeywords $mediumKeywords
            
            $tasks += @{
                Id = $taskId++
                Source = "evolution-log.md ($($entry.Timestamp))"
                Indicator = $indicator
                Description = $description
                Context = $entry.Entry
                Priority = $priority.Level
                PriorityScore = $priority.Score
                Keywords = $priority.Keywords
            }
        }
    }
    
    # Sort by priority score (descending)
    $sortedTasks = $tasks | Sort-Object -Property PriorityScore -Descending
    
    return $sortedTasks
}

function Get-TaskPriority {
    param(
        [string]$Text,
        [array]$CriticalKeywords,
        [array]$HighKeywords,
        [array]$MediumKeywords
    )
    
    $score = 0
    $level = "Low"
    $foundKeywords = @()
    
    # Check for critical keywords (score: 100+)
    foreach ($keyword in $CriticalKeywords) {
        if ($Text -match $keyword) {
            $score += 100
            $level = "CRITICAL"
            $foundKeywords += $keyword
        }
    }
    
    # Check for high priority keywords (score: 50+)
    foreach ($keyword in $HighKeywords) {
        if ($Text -match $keyword) {
            $score += 50
            if ($level -ne "CRITICAL") { $level = "High" }
            $foundKeywords += $keyword
        }
    }
    
    # Check for medium priority keywords (score: 25+)
    foreach ($keyword in $MediumKeywords) {
        if ($Text -match $keyword) {
            $score += 25
            if ($level -eq "Low") { $level = "Medium" }
            $foundKeywords += $keyword
        }
    }
    
    # Base score for any detected task
    if ($score -eq 0) {
        $score = 10
        $level = "Low"
    }
    
    return @{
        Score = $score
        Level = $level
        Keywords = $foundKeywords
    }
}

function Test-TaskExtraction {
    param([string]$AgentName)
    
    Write-Host "`n=== TESTING TASK EXTRACTION: $AgentName ===" -ForegroundColor Cyan
    
    $parsed = Parse-BrainFiles -AgentName $AgentName
    $tasks = Extract-PendingTasks -ParsedBrain $parsed
    
    Write-Host "? Tasks extracted: $($tasks.Count)" -ForegroundColor Green
    
    if ($tasks.Count -gt 0) {
        Write-Host "`nTop 5 Pending Tasks:" -ForegroundColor Yellow
        $top5 = $tasks | Select-Object -First 5
        
        foreach ($task in $top5) {
            $priorityColor = switch ($task.Priority) {
                "CRITICAL" { "Red" }
                "High" { "Yellow" }
                "Medium" { "Cyan" }
                default { "Gray" }
            }
            
            Write-Host "`n[$($task.Id)] [$($task.Priority)] $($task.Indicator): $($task.Description)" -ForegroundColor $priorityColor
            Write-Host "    Source: $($task.Source)" -ForegroundColor Gray
            Write-Host "    Score: $($task.PriorityScore)" -ForegroundColor Gray
            if ($task.Keywords.Count -gt 0) {
                Write-Host "    Keywords: $($task.Keywords -join ', ')" -ForegroundColor Gray
            }
        }
    } else {
        Write-Host "  No pending tasks detected" -ForegroundColor Gray
    }
    
    return $tasks
}


function Get-ActiveProjects {
    param(
        [string]$ProjectsPath = "D:\AgentSystem\Projects"
    )
    
    $projects = @()
    
    # Check if Projects directory exists
    if (-not (Test-Path $ProjectsPath)) {
        return $projects
    }
    
    # Scan for project directories
    $projectDirs = Get-ChildItem -Path $ProjectsPath -Directory -ErrorAction SilentlyContinue
    
    foreach ($dir in $projectDirs) {
        $project = @{
            Name = $dir.Name
            Path = $dir.FullName
            ContextFile = $null
            Description = ""
            Branch = "unknown"
            LastUpdate = $null
            DaysSinceUpdate = 0
            Status = "Unknown"
            ModifiedFiles = 0
            IsActive = $false
        }
        
        # Check for context.md
        $contextPath = Join-Path $dir.FullName "context.md"
        if (Test-Path $contextPath) {
            $project.ContextFile = $contextPath
            $project.IsActive = $true
            
            # Read context.md
            $contextContent = Get-Content $contextPath -Raw -ErrorAction SilentlyContinue
            
            # Extract description (first line after # heading)
            if ($contextContent -match '(?m)^#\s+(.+)$') {
                $project.Description = $matches[1].Trim()
            }
            
            # Extract branch info (look for branch, git, current patterns)
            if ($contextContent -match '(?i)branch:\s*([^\n]+)') {
                $project.Branch = $matches[1].Trim()
            } elseif ($contextContent -match '(?i)(?:feature|bugfix|fix)/([^\n\s]+)') {
                $project.Branch = $matches[0].Trim()
            }
            
            # Extract status
            if ($contextContent -match '(?i)status:\s*([^\n]+)') {
                $project.Status = $matches[1].Trim()
            }
            
            # Get last update from file modification time
            $contextFile = Get-Item $contextPath
            $project.LastUpdate = $contextFile.LastWriteTime
            
            # Calculate staleness
            $timeSpan = (Get-Date) - $project.LastUpdate
            $project.DaysSinceUpdate = [Math]::Round($timeSpan.TotalDays, 1)
        }
        
        # Check for Git repository
        $gitPath = Join-Path $dir.FullName ".git"
        if (Test-Path $gitPath) {
            try {
                # Try to get current branch from Git
                Push-Location $dir.FullName
                $gitBranch = git rev-parse --abbrev-ref HEAD 2>$null
                if ($gitBranch) {
                    $project.Branch = $gitBranch.Trim()
                }
                
                # Count modified/untracked files
                $gitStatus = git status --short 2>$null
                if ($gitStatus) {
                    $project.ModifiedFiles = ($gitStatus | Measure-Object).Count
                }
                
                Pop-Location
            } catch {
                Pop-Location
            }
        }
        
        # Determine if project is "hot" (worked on recently)
        if ($project.DaysSinceUpdate -lt 1) {
            $project.Status = "Active (today)"
        } elseif ($project.DaysSinceUpdate -lt 7) {
            $project.Status = "Recent (this week)"
        } elseif ($project.DaysSinceUpdate -lt 30) {
            $project.Status = "Stale (this month)"
        } else {
            $project.Status = "Inactive (30+ days)"
        }
        
        $projects += $project
    }
    
    # Sort by recency (least stale first)
    $sortedProjects = $projects | Sort-Object -Property DaysSinceUpdate
    
    return $sortedProjects
}

function Test-ProjectScanning {
    Write-Host "`n=== TESTING PROJECT SCANNING ===" -ForegroundColor Cyan
    
    $projects = Get-ActiveProjects
    
    Write-Host "? Projects found: $($projects.Count)" -ForegroundColor Green
    
    if ($projects.Count -gt 0) {
        Write-Host "`nActive Projects:" -ForegroundColor Yellow
        
        foreach ($project in $projects) {
            $statusColor = switch -Regex ($project.Status) {
                "Active" { "Green" }
                "Recent" { "Cyan" }
                "Stale" { "Yellow" }
                default { "Gray" }
            }
            
            Write-Host "`n[$($project.Name)]" -ForegroundColor White
            Write-Host "  Path: $($project.Path)" -ForegroundColor Gray
            Write-Host "  Description: $($project.Description)" -ForegroundColor Gray
            Write-Host "  Branch: $($project.Branch)" -ForegroundColor Gray
            Write-Host "  Status: $($project.Status)" -ForegroundColor $statusColor
            Write-Host "  Last Update: $($project.LastUpdate)" -ForegroundColor Gray
            Write-Host "  Staleness: $($project.DaysSinceUpdate) days" -ForegroundColor Gray
            if ($project.ModifiedFiles -gt 0) {
                Write-Host "  Modified Files: $($project.ModifiedFiles)" -ForegroundColor Yellow
            }
        }
    } else {
        Write-Host "  No projects found in D:\AgentSystem\Projects\" -ForegroundColor Gray
    }
    
    return $projects
}


function Generate-Recommendations {
    param(
        [Parameter(Mandatory=$true)]
        [hashtable]$ParsedBrain,
        [Parameter(Mandatory=$true)]
        [array]$Tasks,
        [Parameter(Mandatory=$true)]
        [array]$Projects
    )
    
    $recommendations = @()
    $recId = 1
    
    # === RECOMMENDATION 1: Top Priority Task ===
    if ($Tasks.Count -gt 0) {
        $topTask = $Tasks[0]
        
        $action = "Continue: $($topTask.Description)"
        $reason = "Highest priority task ($($topTask.Priority) priority, score: $($topTask.PriorityScore))"
        if ($topTask.Keywords.Count -gt 0) {

    # NULL SAFETY FIX
    if ($Tasks -eq $null) { $Tasks = @() }
    if ($Projects -eq $null) { $Projects = @() }
            $reason += " - Keywords: $($topTask.Keywords -join ', ')"
        }
        
        # Generate command based on source
        $command = if ($topTask.Source -like "current-task.md*") {
            "# Review current task specification`nGet-Content `"$($ParsedBrain.BrainPath)\current-task.md`""
        } else {
            "# Continue work on: $($topTask.Description)`n# Check brain context for details"
        }
        
        $recommendations += @{
            Id = $recId++
            Priority = 1
            Action = $action
            Reason = $reason
            Command = $command
            Score = $topTask.PriorityScore + 50  # Boost for being top task
            Type = "Task"
        }
    }
    
    # === RECOMMENDATION 2: Stale Project (if exists) ===
    $staleProjects = $Projects | Where-Object { $_.DaysSinceUpdate -ge 7 -and $_.DaysSinceUpdate -lt 90 }
    if ($staleProjects.Count -gt 0) {
        $mostStale = $staleProjects | Sort-Object -Property DaysSinceUpdate -Descending | Select-Object -First 1
        
        $action = "Resume stale project: $($mostStale.Name)"
        $reason = "Project inactive for $($mostStale.DaysSinceUpdate) days"
        if ($mostStale.Description) {
            $reason += " - $($mostStale.Description)"
        }
        
        $command = "# Navigate to stale project`ncd `"$($mostStale.Path)`"`n# Review project context`nGet-Content context.md"
        
        $recommendations += @{
            Id = $recId++
            Priority = 2
            Action = $action
            Reason = $reason
            Command = $command
            Score = [Math]::Min(100, $mostStale.DaysSinceUpdate * 3)  # 3 points per day stale
            Type = "Project"
        }
    }
    
    # === RECOMMENDATION 3: Second Priority Task (if exists) ===
    if ($Tasks.Count -gt 1) {
        $secondTask = $Tasks[1]
        
        $action = "Address: $($secondTask.Description)"
        $reason = "Second highest priority ($($secondTask.Priority) priority, score: $($secondTask.PriorityScore))"
        
        $command = "# Work on task: $($secondTask.Description)`n# Source: $($secondTask.Source)"
        
        $recommendations += @{
            Id = $recId++
            Priority = 3
            Action = $action
            Reason = $reason
            Command = $command
            Score = $secondTask.PriorityScore + 25  # Smaller boost
            Type = "Task"
        }
    }
    
    # === RECOMMENDATION 4: System Health Check ===
    # Count backups for agent
    $agentName = $ParsedBrain.AgentName
    $backupPath = "D:\AgentSystem\Backups\$agentName"
    $backupCount = 0
    if (Test-Path $backupPath) {
        $backupCount = (Get-ChildItem $backupPath -Filter "brain-backup-*.zip" -ErrorAction SilentlyContinue).Count
    }
    
    if ($backupCount -lt 5) {
        $action = "System Health: Verify backup system"
        $reason = "Only $backupCount backup(s) found (expected: 5). Run manual backup to test rotation."
        $command = "# Test backup system`n.\backup-brain.ps1 -AgentName `"$agentName`"`n# Verify rotation`nGet-ChildItem `"$backupPath`""
        
        $recommendations += @{
            Id = $recId++
            Priority = 4
            Action = $action
            Reason = $reason
            Command = $command
            Score = 30
            Type = "System"
        }
    } else {
        $action = "System Health: All systems operational"
        $reason = "Backup system healthy ($backupCount backups maintained). No critical issues detected."
        $command = "# View backup status`nGet-ChildItem `"$backupPath`" | Select-Object Name, Length, CreationTime"
        
        $recommendations += @{
            Id = $recId++
            Priority = 4
            Action = $action
            Reason = $reason
            Command = $command
            Score = 20
            Type = "System"
        }
    }
    
    # === RECOMMENDATION 5: Third Priority Task (if exists and no stale projects) ===
    if ($Tasks.Count -gt 2 -and $staleProjects.Count -eq 0) {
        $thirdTask = $Tasks[2]
        
        $action = "Next: $($thirdTask.Description)"
        $reason = "Third priority task ($($thirdTask.Priority) priority)"
        $command = "# Work on: $($thirdTask.Description)"
        
        $recommendations += @{
            Id = $recId++
            Priority = 5
            Action = $action
            Reason = $reason
            Command = $command
            Score = $thirdTask.PriorityScore + 10
            Type = "Task"
        }
    }
    
    # Sort by score and return top 3
    $topRecommendations = $recommendations | Sort-Object -Property Score -Descending | Select-Object -First 3
    
    # Re-assign priority 1, 2, 3 to top 3
    $finalPriority = 1
    foreach ($rec in $topRecommendations) {
        $rec.Priority = $finalPriority++
    }
    
    return $topRecommendations
}

function Test-Recommendations {
    param([string]$AgentName)
    
    Write-Host "`n=== TESTING RECOMMENDATIONS: $AgentName ===" -ForegroundColor Cyan
    
    # Parse brain
    $parsed = Parse-BrainFiles -AgentName $AgentName
    
    # Extract tasks
    $tasks = Extract-PendingTasks -ParsedBrain $parsed
    
    # Get projects
    $projects = Get-ActiveProjects
    
    # Generate recommendations
    $recommendations = Generate-Recommendations -ParsedBrain $parsed -Tasks $tasks -Projects $projects
    
    Write-Host "? Recommendations generated: $($recommendations.Count)" -ForegroundColor Green
    
    Write-Host "`n+----------------------------------------------------------------+" -ForegroundColor Yellow
    Write-Host "¦           INTELLIGENT RECOMMENDATIONS FOR $AgentName" -ForegroundColor Yellow
    Write-Host "+----------------------------------------------------------------+" -ForegroundColor Yellow
    
    foreach ($rec in $recommendations) {
        $typeColor = switch ($rec.Type) {
            "Task" { "Cyan" }
            "Project" { "Magenta" }
            "System" { "Green" }
            default { "White" }
        }
        
        Write-Host "`n[$($rec.Priority)] [$($rec.Type)] " -NoNewline -ForegroundColor $typeColor
        Write-Host "$($rec.Action)" -ForegroundColor White
        Write-Host "    Reason: $($rec.Reason)" -ForegroundColor Gray
        Write-Host "    Score: $($rec.Score)" -ForegroundColor DarkGray
        Write-Host "    Command:" -ForegroundColor Yellow
        Write-Host "    $($rec.Command)" -ForegroundColor DarkYellow
    }
    
    return $recommendations
}


function Show-ResurrectionMenu {
    param(
        [Parameter(Mandatory=$true)]
        [string]$AgentName
    )
    
    # Parse all data
    Write-Host "`nLoading $AgentName brain state..." -ForegroundColor Yellow
    $parsed = Parse-BrainFiles -AgentName $AgentName
    $tasks = Extract-PendingTasks -ParsedBrain $parsed
    $projects = Get-ActiveProjects
    $recommendations = Generate-Recommendations -ParsedBrain $parsed -Tasks $tasks -Projects $projects
    
    # Clear screen for clean display
    Clear-Host
    
    # === HEADER ===
    Write-Host "`n+----------------------------------------------------------------+" -ForegroundColor Cyan
    Write-Host "¦          AGENT RESURRECTION: $AgentName" -ForegroundColor Cyan
    Write-Host "+----------------------------------------------------------------+" -ForegroundColor Cyan
    
    # === BRAIN SUMMARY ===
    Write-Host "`n?? BRAIN STATE SUMMARY" -ForegroundColor Yellow
    Write-Host "   Learnings: $($parsed.Learnings.Count)" -ForegroundColor White
    Write-Host "   Pending Tasks: $($tasks.Count)" -ForegroundColor White
    Write-Host "   Active Projects: $($projects.Count)" -ForegroundColor White
    Write-Host "   Brain Health: $(if ($parsed.ParseSuccess) {'? Healthy'} else {'? Issues detected'})" -ForegroundColor $(if ($parsed.ParseSuccess) {'Green'} else {'Red'})
    
    # === LATEST LEARNING ===
    if ($parsed.Learnings.Count -gt 0) {
        $latest = $parsed.Learnings[-1]
        Write-Host "`n?? LATEST LEARNING ($($latest.Timestamp))" -ForegroundColor Yellow
        $preview = $latest.Content.Substring(0, [Math]::Min(150, $latest.Content.Length))
        Write-Host "   $preview..." -ForegroundColor Gray
    }
    
    # === TOP RECOMMENDATIONS ===
    Write-Host "`n?? INTELLIGENT RECOMMENDATIONS" -ForegroundColor Yellow
    if ($recommendations.Count -gt 0) {
        foreach ($rec in $recommendations) {
            $typeColor = switch ($rec.Type) {
                "Task" { "Cyan" }
                "Project" { "Magenta" }
                "System" { "Green" }
                default { "White" }
            }
            
            Write-Host "`n   [$($rec.Priority)] [$($rec.Type)]" -NoNewline -ForegroundColor $typeColor
            Write-Host " $($rec.Action)" -ForegroundColor White
            Write-Host "       ? $($rec.Reason)" -ForegroundColor Gray
        }
    } else {
        Write-Host "   No specific recommendations. All systems nominal." -ForegroundColor Gray
    }
    
    # === PENDING TASKS (Top 5) ===
    if ($tasks.Count -gt 0) {
        Write-Host "`n?? TOP PENDING TASKS" -ForegroundColor Yellow
        $topTasks = $tasks | Select-Object -First 5
        foreach ($task in $topTasks) {
            $priorityColor = switch ($task.Priority) {
                "CRITICAL" { "Red" }
                "High" { "Yellow" }
                "Medium" { "Cyan" }
                default { "Gray" }
            }
            Write-Host "   • [$($task.Priority)]" -NoNewline -ForegroundColor $priorityColor
            Write-Host " $($task.Description)" -ForegroundColor White
        }
    }
    
    # === ACTIVE PROJECTS (Top 3) ===
    if ($projects.Count -gt 0) {
        Write-Host "`n?? ACTIVE PROJECTS" -ForegroundColor Yellow
        $topProjects = $projects | Select-Object -First 3
        foreach ($proj in $topProjects) {
            $statusColor = switch -Regex ($proj.Status) {
                "Active" { "Green" }
                "Recent" { "Cyan" }
                "Stale" { "Yellow" }
                default { "Gray" }
            }
            Write-Host "   • $($proj.Name)" -NoNewline -ForegroundColor White
            Write-Host " [$($proj.Status)]" -ForegroundColor $statusColor
        }
    }
    
    # === INTERACTIVE MENU ===
    Write-Host "`n+----------------------------------------------------------------+" -ForegroundColor Green
    Write-Host "¦                    RESURRECTION OPTIONS                        ¦" -ForegroundColor Green
    Write-Host "+----------------------------------------------------------------+" -ForegroundColor Green
    
    Write-Host "`n[1] Execute Top Recommendation" -ForegroundColor Cyan
    Write-Host "[2] View All Pending Tasks" -ForegroundColor Cyan
    Write-Host "[3] View All Projects" -ForegroundColor Cyan
    Write-Host "[4] View Full Brain Dump (legacy)" -ForegroundColor Cyan
    Write-Host "[5] Exit" -ForegroundColor Cyan
    
    Write-Host "`nSelect option (1-5): " -NoNewline -ForegroundColor Yellow
    $choice = Read-Host
    
    # === EXECUTE CHOICE ===
    switch ($choice) {
        "1" {
            if ($recommendations.Count -gt 0) {
                $topRec = $recommendations[0]
                Write-Host "`n? Executing: $($topRec.Action)" -ForegroundColor Green
                Write-Host "`nCommand to run:" -ForegroundColor Yellow
                Write-Host $topRec.Command -ForegroundColor White
                Write-Host "`nCopy and execute the command above." -ForegroundColor Cyan
            } else {
                Write-Host "`nNo recommendations available." -ForegroundColor Gray
            }
        }
        "2" {
            Write-Host "`n?? ALL PENDING TASKS ($($tasks.Count) total)" -ForegroundColor Yellow
            foreach ($task in $tasks) {
                Write-Host "`n[$($task.Id)] [$($task.Priority)] $($task.Indicator): $($task.Description)" -ForegroundColor White
                Write-Host "    Source: $($task.Source)" -ForegroundColor Gray
            }
        }
        "3" {
            Write-Host "`n?? ALL PROJECTS ($($projects.Count) total)" -ForegroundColor Yellow
            foreach ($proj in $projects) {
                Write-Host "`n• $($proj.Name) [$($proj.Status)]" -ForegroundColor White
                Write-Host "  Path: $($proj.Path)" -ForegroundColor Gray
                Write-Host "  Branch: $($proj.Branch)" -ForegroundColor Gray
                Write-Host "  Last Updated: $($proj.LastUpdate)" -ForegroundColor Gray
            }
        }
        "4" {
            Write-Host "`n=== FULL BRAIN DUMP ===" -ForegroundColor Yellow
            Write-Host "`nMETA PROMPT:" -ForegroundColor Cyan
            Write-Host $parsed.MetaPrompt
            Write-Host "`nLEARNED KNOWLEDGE:" -ForegroundColor Cyan
            Write-Host $parsed.RawFiles["learned-knowledge.md"]
            Write-Host "`nEVOLUTION LOG:" -ForegroundColor Cyan
            Write-Host $parsed.RawFiles["evolution-log.md"]
            if ($parsed.CurrentTask) {
                Write-Host "`nCURRENT TASK:" -ForegroundColor Cyan
                Write-Host $parsed.CurrentTask
            }
        }
        "5" {
            Write-Host "`nGoodbye. Agent $AgentName entering hibernation." -ForegroundColor Gray
            return
        }
        default {
            Write-Host "`nInvalid choice. Exiting." -ForegroundColor Red
        }
    }
    
    Write-Host "`n--- End of Resurrection ---" -ForegroundColor Gray
}
