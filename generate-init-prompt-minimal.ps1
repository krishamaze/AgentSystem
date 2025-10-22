# Minimal Init Prompt Generator - Index-Based
param([string]$AgentName = 'Agent_Primary')

# Load system index
$index = Get-Content ".meta\system-index.json" | ConvertFrom-Json
$registry = Get-Content ".meta\tenant-registry.json" | ConvertFrom-Json

# Find active project
$activeProject = $registry.project_tenants | Where-Object { $_.name -eq $index.active_context.current_project }

# Build minimal init prompt (target: ~500 bytes)
$initPrompt = @"
ROLE: Persistent AI Agent with Multi-Tenant Memory
SESSION: $(Get-Date -Format 'yyyy-MM-dd-HHmm')
CONTEXT: D:\AgentSystem

# AGENT IDENTITY
$AgentName v$($index.version) - Index-based lazy loading

# SYSTEM CAPABILITIES
- Memory Tiers: $($index.capabilities.memory_tiers) (local/supabase/mem0)
- Tracked Projects: $($index.capabilities.total_projects)
- Namespaces: $($index.namespaces.Count) isolated
- Commands: $($index.commands.Keys.Count) available

# ACTIVE CONTEXT
Project: $($index.active_context.current_project)
Last Active: $($index.active_context.last_active)
Tenant: $($activeProject.id)

# INTERACTION PROTOCOL
1. User provides PowerShell commands
2. Execute in PS D:\AgentSystem>
3. Paste output back
4. Agent learns and proceeds

# AVAILABLE COMMANDS (Lazy Loading)
.\tools\list-projects.ps1                    - List all projects
.\tools\load-project.ps1 -ProjectName <name> - Load project context
.\tools\switch-project.ps1 -ProjectName <name> - Switch active project
.\tools\load-memory.ps1 -Namespace <path>    - Load memory namespace

# PROJECT INDEX
$($registry.project_tenants | ForEach-Object { "- $($_.name): $($_.status) (milestone $($_.current_milestone))" } | Out-String)

# MEMORY NAMESPACES
$($index.namespaces | ForEach-Object { "- $_" } | Out-String)

# READY
To continue work: .\tools\load-project.ps1 -ProjectName $($index.active_context.current_project)
"@

# Save and copy to clipboard
$timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$initPrompt | Out-File ".\init_prompt_minimal_$timestamp.txt" -Encoding UTF8
$initPrompt | Set-Clipboard

Write-Output "✓ Minimal init prompt generated ($($initPrompt.Length) bytes)"
Write-Output "✓ Copied to clipboard"
Write-Output "`nPrompt size: $([math]::Round($initPrompt.Length/1KB, 2))KB (vs old: ~5KB)"
Write-Output "`nPaste in new Perplexity thread to resurrect with index-based loading"
