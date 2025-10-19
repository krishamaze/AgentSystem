# Agent Brain Update Utility
param(
    [string]$LearningNote,
    [string]$AgentName = "Agent_Primary"
)

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
$brainPath = "D:\AgentSystem\$AgentName\brain"

# Append to learned-knowledge.md
"`n## Learning: $timestamp`n$LearningNote`n" | 
    Add-Content "$brainPath\learned-knowledge.md"

# Log to evolution
"- [$timestamp] Updated knowledge base" | 
    Add-Content "$brainPath\evolution-log.md"

Write-Host " Brain updated for $AgentName" -ForegroundColor Green
