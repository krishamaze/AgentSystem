# Quick Reinitialization Script
# Run this in PowerShell, copy ALL output, paste into new thread with reinitialization message

Set-Location D:\AgentSystem

Write-Host "=== AGENT_PRIMARY BRAIN STATE ===" -ForegroundColor Magenta
Write-Host "`n=== META-PROMPT ===" -ForegroundColor Cyan
Get-Content "Agent_Primary\brain\meta-prompt.md"

Write-Host "`n=== LEARNED KNOWLEDGE ===" -ForegroundColor Cyan
Get-Content "Agent_Primary\brain\learned-knowledge.md"

Write-Host "`n=== EVOLUTION LOG ===" -ForegroundColor Cyan
Get-Content "Agent_Primary\brain\evolution-log.md"

Write-Host "`n=== PROJECT CONTEXT: arin-bot-v2 ===" -ForegroundColor Cyan
Get-Content "Projects\arin-bot-v2\context.md"

Write-Host "`n=== END BRAIN STATE ===" -ForegroundColor Magenta
Write-Host "`nCopy ALL output above and paste with reinitialization template from:" -ForegroundColor Yellow
Write-Host "D:\AgentSystem\reinitialize-agent.md" -ForegroundColor Yellow
