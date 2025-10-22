param([string]$AgentName = 'Agent_Primary')

$brainPath = ".\$AgentName\brain"
$metaPrompt = Get-Content "$brainPath\meta-prompt.md" -Raw -ErrorAction SilentlyContinue
$learnedKnowledge = Get-Content "$brainPath\learned-knowledge.md" -Raw -ErrorAction SilentlyContinue

# Enhanced: Detect active projects with IN_PROGRESS milestones
$activeProjects = @()
if (Test-Path ".\Projects") {
    Get-ChildItem ".\Projects" -Directory | ForEach-Object {
        if (Test-Path "$($_.FullName)\progress.json") {
            $progress = Get-Content "$($_.FullName)\progress.json" | ConvertFrom-Json
            $inProgress = $progress.Milestones | Where-Object { $_.Status -eq "IN_PROGRESS" }
            if ($inProgress) {
                $activeProjects += @{
                    name = $_.Name
                    milestone = $inProgress.Name
                    path = $progress.ProjectPath
                    stack = "$($progress.TechStack.Framework), $($progress.TechStack.Runtime)"
                }
            }
        }
    }
}

# Build enhanced init prompt
$initPrompt = @"
ROLE pro software developer team with 70 years experience
TASK AgentSystem Resurrection in new Perplexity thread
CONTEXT D:\AgentSystem

# SYSTEM IDENTITY
You are $AgentName - persistent AI agent with memory across Perplexity threads.

# BRAIN SNAPSHOT
$metaPrompt

# CORE KNOWLEDGE
$($learnedKnowledge.Substring(0, [Math]::Min(3000, $learnedKnowledge.Length)))
... [Full brain: 50.8 KB - request via 'load full knowledge']

# ACTIVE WORK
$( if ($activeProjects.Count -gt 0) {
    $activeProjects | ForEach-Object {
        "## $($_.name)
Current Milestone: $($_.milestone)
Stack: $($_.stack)
Path: $($_.path)
Status: IN PROGRESS - Resume this work

"
    }
} else {
    "No active IN_PROGRESS projects. Ready for new tasks.
Use: .\project-resume.ps1 to see available projects"
})

# INTERACTION PROTOCOL
- Provide PowerShell batch commands
- User executes in PS D:\AgentSystem>
- User pastes output back
- Auto-learn and proceed

# MEMORY ACCESS
1. Full brain: .\memory-commands.ps1 -Command 1
2. Project context: .\project-resume.ps1 -ProjectName <name>
3. Supabase: GET https://fihvhtoqviivmasjaqxc.supabase.co/functions/v1/get-agent-memory

# SYSTEM STATUS ($(Get-Date -Format 'yyyy-MM-dd HH:mm'))
- WebSocket: Port 8080
- Supabase: fihvhtoqviivmasjaqxc
- Tools: project-resume.ps1, memory-commands.ps1, update-project.ps1

# READY
Awaiting instructions.
"@

$timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$initPrompt | Out-File ".\init_prompt_$timestamp.txt" -Encoding UTF8
$initPrompt | Set-Clipboard

Write-Output "Init prompt generated and copied to clipboard."
Write-Output "Enhanced features:"
Write-Output "  ✓ Auto-detects IN_PROGRESS projects"
Write-Output "  ✓ Includes project context in resurrection"
Write-Output "  ✓ Shows project-resume command"
