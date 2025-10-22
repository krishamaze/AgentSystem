<#
.SYNOPSIS
    Export Agent_Primary context for new sessions
.DESCRIPTION
    Generates init context and copies to clipboard automatically.
    Use this to resurrect agent in fresh Perplexity threads.
.EXAMPLE
    .\export-resurrection-context.ps1
    Context copied to clipboard, paste in new thread
#>

param(
    [string]$AgentName = "Agent_Primary"
)

# Simply copy the pre-generated init context
$initPath = "D:\AgentSystem\AGENT_INIT_CONTEXT.txt"

if (Test-Path $initPath) {
    $context = Get-Content $initPath -Raw
    $context | Set-Clipboard
    Write-Output $context
    Write-Host "`n════════════════════════════════════════" -ForegroundColor Green
    Write-Host "✅ AGENT INIT CONTEXT COPIED TO CLIPBOARD" -ForegroundColor Green
    Write-Host "════════════════════════════════════════" -ForegroundColor Green
    Write-Host "`nPaste in new Perplexity thread to resurrect Agent_Primary" -ForegroundColor Yellow
    Write-Host "Context includes:" -ForegroundColor Cyan
    Write-Host "  • System architecture & file paths" -ForegroundColor White
    Write-Host "  • All fundamental protocols" -ForegroundColor White
    Write-Host "  • Current state & pending work" -ForegroundColor White
    Write-Host "  • 47 learnings from knowledge base" -ForegroundColor White
} else {
    Write-Host "ERROR: AGENT_INIT_CONTEXT.txt not found" -ForegroundColor Red
    Write-Host "Run the system analysis script first to generate it" -ForegroundColor Yellow
}
