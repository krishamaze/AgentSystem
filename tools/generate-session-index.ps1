# Generate dynamic session context index
# This is the "brain" that builds Level 2 index

param([switch]$Verbose)

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# 1. Scan all projects
Write-Output "🔍 Scanning projects..."
$registry = Get-Content ".meta\tenant-registry.json" | ConvertFrom-Json
$projectsData = @()

foreach ($project in $registry.project_tenants) {
    $progressPath = ".\Projects\$($project.name)\progress.json"
    if (Test-Path $progressPath) {
        $progress = Get-Content $progressPath | ConvertFrom-Json
        $projectsData += @{
            name = $project.name
            status = $project.status
            milestone = "$($progress.CompletedMilestones)/$($progress.TotalMilestones)"
            percentage = [math]::Round(($progress.CompletedMilestones / $progress.TotalMilestones) * 100, 0)
            current_milestone_id = $progress.CurrentMilestoneId
            current_milestone_name = ($progress.Milestones | Where-Object { $_.Id -eq $progress.CurrentMilestoneId }).Name
            path = $project.path
            supabase = $project.supabase_url
        }
    }
}

# 2. Scan all tools with syntax
Write-Output "🔍 Scanning tools..."
$toolsData = @()
$toolFiles = Get-ChildItem ".\tools\" -Filter "*.ps1"

foreach ($tool in $toolFiles) {
    $content = Get-Content $tool.FullName -Raw
    
    # Extract parameters from param() block
    $params = "none"
    if ($content -match 'param\s*\(([\s\S]*?)\)') {
        $paramBlock = $matches[1]
        $params = $paramBlock -replace '\s+', ' ' -replace '\[.*?\]', '' -replace 'Mandatory.*?>', '' | 
                  Select-String -Pattern '\$\w+' -AllMatches | 
                  ForEach-Object { $_.Matches.Value } | 
                  Select-Object -Unique | 
                  ForEach-Object { "-$($_.Substring(1)) <value>" }
        $params = $params -join ' '
    }
    
    # Extract purpose from first comment
    $purpose = "Tool: $($tool.BaseName)"
    if ($content -match '^#\s*(.+)') {
        $purpose = $matches[1]
    }
    
    $toolsData += @{
        name = $tool.Name
        syntax = $params
        purpose = $purpose
    }
}

# 3. Scan ADRs
Write-Output "🔍 Scanning ADRs..."
$adrRegistry = Get-Content ".\decisions\adr-registry.json" | ConvertFrom-Json
$adrsData = @()

foreach ($projName in $adrRegistry.projects.PSObject.Properties.Name) {
    $proj = $adrRegistry.projects.$projName
    if ($proj.count -gt 0) {
        foreach ($adr in $proj.adrs) {
            $adrsData += @{
                project = $projName
                id = $adr.id
                title = $adr.title
                status = $adr.status
            }
        }
    }
}

# 4. Get system index info
$systemIndex = Get-Content ".meta\system-index.json" | ConvertFrom-Json
$activeProject = $systemIndex.active_context.current_project
$lastActive = $systemIndex.active_context.last_active

# 5. Get memory namespaces
$namespaces = @(
    "/system/core",
    "/system/decisions",
    "/system/feedback"
)
foreach ($project in $registry.project_tenants) {
    $namespaces += "/projects/$($project.name)"
}

# 6. Get active milestone details for active project
$activeProjectProgress = Get-Content ".\Projects\$activeProject\progress.json" | ConvertFrom-Json
$activeMilestone = $activeProjectProgress.Milestones | Where-Object { $_.Id -eq $activeProjectProgress.CurrentMilestoneId }

# 7. Get recent session (if exists)
$lastSession = "No previous session logged"
$sessionFiles = Get-ChildItem ".\sessions\" -Filter "*.md" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending
if ($sessionFiles) {
    $lastSession = "Last session: $($sessionFiles[0].BaseName)"
}

# 8. Build Level 2 index
$sessionContext = @{
    generated_at = $timestamp
    version = "2.0-dynamic"
    system_snapshot = @{
        timestamp = $timestamp
        active_project = $activeProject
        last_active = $lastActive
        projects_count = $projectsData.Count
        total_adrs = $adrsData.Count
        last_session = $lastSession
    }
    projects = $projectsData
    tools = $toolsData
    adrs = $adrsData
    memory_namespaces = $namespaces
    active_milestone = @{
        project = $activeProject
        id = $activeMilestone.Id
        name = $activeMilestone.Name
        status = $activeMilestone.Status
        description = $activeMilestone.Description
    }
    quick_stats = @{
        total_projects = $projectsData.Count
        active_projects = ($projectsData | Where-Object { $_.status -eq "active" }).Count
        total_milestones = ($projectsData | ForEach-Object { 
            [int]($_.milestone -split '/')[1] 
        } | Measure-Object -Sum).Sum
        completed_milestones = ($projectsData | ForEach-Object { 
            [int]($_.milestone -split '/')[0] 
        } | Measure-Object -Sum).Sum
        total_tools = $toolsData.Count
        total_adrs = $adrsData.Count
    }
}

# 9. Save to .meta/session-context.json
$outputPath = ".meta\session-context.json"
$sessionContext | ConvertTo-Json -Depth 10 | Out-File $outputPath -Encoding UTF8

Write-Output "✓ Session context generated: $outputPath"
Write-Output "  Projects: $($projectsData.Count)"
Write-Output "  Tools: $($toolsData.Count)"
Write-Output "  ADRs: $($adrsData.Count)"
Write-Output "  Active: $activeProject (Milestone $($activeMilestone.Id))"

if ($Verbose) {
    Write-Output "`nPreview:"
    Get-Content $outputPath | Select-Object -First 20
}
