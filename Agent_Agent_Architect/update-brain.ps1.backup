# Agent Brain Update Utility - Enhanced with Auto-Backup
param(
    [string]$LearningNote,
    [string]$AgentName = "Agent_Primary"
)

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
$brainPath = "D:\AgentSystem\$AgentName\brain"
$backupScript = "D:\AgentSystem\backup-brain.ps1"

# CRITICAL: Backup brain BEFORE any modifications
Write-Host "Creating pre-update backup..." -ForegroundColor Yellow

if (Test-Path $backupScript) {
    try {
        # Execute backup script and capture exit code
        & $backupScript -AgentName $AgentName
        
        if ($LASTEXITCODE -eq 1) {
            Write-Host "ERROR: Backup failed. Brain update aborted for safety." -ForegroundColor Red
            exit 1
        }
        
        # Log successful backup to evolution
        "- [$timestamp] Pre-update backup created successfully" | 
            Add-Content "$brainPath\evolution-log.md"
            
    } catch {
        Write-Host "ERROR: Backup system failure - $_" -ForegroundColor Red
        Write-Host "Brain update aborted to prevent data loss." -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "WARNING: backup-brain.ps1 not found. Proceeding without backup." -ForegroundColor Yellow
}

# Proceed with brain update only if backup succeeded
"`n## Learning: $timestamp`n$LearningNote`n" |
    Add-Content "$brainPath\learned-knowledge.md"

# Log update to evolution
"- [$timestamp] Updated knowledge base" |
    Add-Content "$brainPath\evolution-log.md"

Write-Host " Brain updated for $AgentName" -ForegroundColor Green
