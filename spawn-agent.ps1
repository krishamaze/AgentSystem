# Co-Agent Spawner
param(
    [Parameter(Mandatory=$true)]
    [string]$AgentName,
    
    [Parameter(Mandatory=$true)]
    [string]$Purpose
)

$agentPath = "D:\AgentSystem\Agent_$AgentName"

# Create structure
New-Item -ItemType Directory -Path "$agentPath\brain" -Force | Out-Null

# Initialize meta-prompt
$metaContent = @"
# Agent $AgentName - Meta Prompt

## Purpose
$Purpose

## Core Behavior
- Give 1 batch of commands at a time
- Wait for user execution output confirmation
- Auto-learn from every interaction
- Update brain: summarized, efficient, retrievable

## Specialization
[To be developed through learning]
"@

$metaContent | Out-File "$agentPath\brain\meta-prompt.md" -Encoding UTF8

"# $AgentName Knowledge Base`n" | Out-File "$agentPath\brain\learned-knowledge.md" -Encoding UTF8

$timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm'
"## $timestamp - Agent Spawned`n- Purpose: $Purpose`n" | Out-File "$agentPath\brain\evolution-log.md" -Encoding UTF8

Write-Host " Agent_$AgentName spawned with purpose: $Purpose" -ForegroundColor Cyan
