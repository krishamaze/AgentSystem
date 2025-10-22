<#
.SYNOPSIS
    Intelligent Agent Resurrection System - Interactive UI
.DESCRIPTION
    Loads lib-parser.ps1 and calls Show-ResurrectionMenu for intelligent,
    context-aware agent resurrection with priority recommendations.
.EXAMPLE
    .\resurrect-me.ps1
    Displays interactive resurrection menu with brain analysis.
.EXAMPLE
    .\resurrect-me.ps1 -AgentName "Agent_CodeAssist"
    Resurrect a specific agent (default: Agent_Primary).
#>

param(
    [string]$AgentName = "Agent_Primary"
)

# Ensure we're in the AgentSystem directory
Set-Location D:\AgentSystem

# Import lib-parser.ps1 module (contains Show-ResurrectionMenu and all parsing functions)
if (Test-Path "D:\AgentSystem\lib-parser.ps1") {
    . "D:\AgentSystem\lib-parser.ps1"
    Write-Host "? Loaded lib-parser.ps1 module" -ForegroundColor Green
} else {
    Write-Host "? ERROR: lib-parser.ps1 not found" -ForegroundColor Red
    Write-Host "Cannot proceed without parser module." -ForegroundColor Red
    exit 1
}

# Call intelligent resurrection menu
try {
    Show-ResurrectionMenu -AgentName $AgentName
} catch {
    Write-Host "`n? ERROR during resurrection: $_" -ForegroundColor Red
    Write-Host "`nFalling back to basic brain dump..." -ForegroundColor Yellow
    
    # Fallback: basic dump if intelligent menu fails
    Write-Host "`n=== FALLBACK: BASIC BRAIN DUMP ===" -ForegroundColor Yellow
    $brainPath = "D:\AgentSystem\$AgentName\brain"
    
    if (Test-Path "$brainPath\meta-prompt.md") {
        Write-Host "`n=== META-PROMPT ===" -ForegroundColor Cyan
        Get-Content "$brainPath\meta-prompt.md"
    }
    
    if (Test-Path "$brainPath\learned-knowledge.md") {
        Write-Host "`n=== LEARNED KNOWLEDGE ===" -ForegroundColor Cyan
        Get-Content "$brainPath\learned-knowledge.md"
    }
    
    if (Test-Path "$brainPath\evolution-log.md") {
        Write-Host "`n=== EVOLUTION LOG ===" -ForegroundColor Cyan
        Get-Content "$brainPath\evolution-log.md"
    }
}
