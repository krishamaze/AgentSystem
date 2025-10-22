# Request additional context mid-session
# Thread can request specific data not in initial prompt

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("tools", "adrs", "memory", "learnings", "projects")]
    [string]$Category,
    
    [Parameter(Mandatory=$true)]
    [string]$Query,
    
    [ValidateSet("high", "medium", "low")]
    [string]$Priority = "medium"
)

Write-Output "=== CONTEXT REQUEST ==="
Write-Output "  Category: $Category"
Write-Output "  Query: $Query"
Write-Output "  Priority: $Priority"

# Track this request
& .\tools\track-metrics.ps1 -Event "CONTEXT_REQUESTED" -Data @{
    category = $Category
    query = $Query
    priority = $Priority
}

# Fetch requested context
$result = $null

switch ($Category) {
    "tools" {
        $allTools = Get-ChildItem ".\tools\" -Filter "*.ps1"
        $result = $allTools | Where-Object { $_.Name -like "*$Query*" } | ForEach-Object {
            $content = Get-Content $_.FullName -Raw
            @{
                name = $_.Name
                path = $_.FullName
                size = $_.Length
                purpose = if ($content -match '^#\s*(.+)') { $matches[1] } else { "N/A" }
            }
        }
    }
    
    "adrs" {
        $registry = Get-Content ".\decisions\adr-registry.json" | ConvertFrom-Json
        $result = @()
        foreach ($projName in $registry.projects.PSObject.Properties.Name) {
            $proj = $registry.projects.$projName
            if ($proj.count -gt 0) {
                foreach ($adr in $proj.adrs) {
                    if ($adr.title -like "*$Query*" -or $adr.id -like "*$Query*") {
                        $result += @{
                            project = $projName
                            id = $adr.id
                            title = $adr.title
                            status = $adr.status
                            file = $adr.file
                        }
                    }
                }
            }
        }
    }
    
    "memory" {
        # Search memory files
        $memoryFiles = Get-ChildItem ".\memory\" -Recurse -Filter "*.md"
        $result = $memoryFiles | Where-Object {
            (Get-Content $_.FullName -Raw) -like "*$Query*"
        } | Select-Object -First 5 | ForEach-Object {
            @{
                file = $_.Name
                path = $_.FullName
                preview = (Get-Content $_.FullName | Select-Object -First 3) -join " "
            }
        }
    }
    
    "learnings" {
        # Search learnings
        $learningFiles = Get-ChildItem ".\memory\tenants\AgentSystem\learnings\" -Filter "*.md" -ErrorAction SilentlyContinue
        $result = $learningFiles | Where-Object {
            (Get-Content $_.FullName -Raw) -like "*$Query*"
        } | Select-Object -First 5 | ForEach-Object {
            @{
                file = $_.Name
                content = Get-Content $_.FullName -Raw
            }
        }
    }
    
    "projects" {
        $registry = Get-Content ".meta\tenant-registry.json" | ConvertFrom-Json
        $result = $registry.project_tenants | Where-Object {
            $_.name -like "*$Query*"
        } | ForEach-Object {
            $progressPath = ".\Projects\$($_.name)\progress.json"
            $progress = if (Test-Path $progressPath) {
                Get-Content $progressPath | ConvertFrom-Json
            } else { $null }
            
            @{
                name = $_.name
                status = $_.status
                path = $_.path
                supabase = $_.supabase_url
                milestone = if ($progress) { "$($progress.CompletedMilestones)/$($progress.TotalMilestones)" } else { "N/A" }
            }
        }
    }
}

# Update priority scores (learning)
$priorityScores = Get-Content ".meta\priority-scores.json" | ConvertFrom-Json

$categoryKey = "$Category-$Query"
if (-not $priorityScores.$categoryKey) {
    $priorityScores | Add-Member -MemberType NoteProperty -Name $categoryKey -Value 0.5
}

# Increase priority based on request
$priorityScores.$categoryKey = [math]::Min($priorityScores.$categoryKey + 0.1, 1.0)

$priorityScores | ConvertTo-Json -Depth 10 | Out-File ".meta\priority-scores.json" -Encoding UTF8

# Output results
Write-Output "`n=== RESULTS ==="
if ($result) {
    $result | ConvertTo-Json -Depth 5
    Write-Output "`n✓ Found $($result.Count) results"
    Write-Output "✓ Priority score updated: $categoryKey = $($priorityScores.$categoryKey)"
} else {
    Write-Output "⚠️  No results found for query: $Query"
}
