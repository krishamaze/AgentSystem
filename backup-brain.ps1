# Brain Backup Utility - Agent System
# Purpose: Create timestamped backups with 5-version rotation
param(
    [Parameter(Mandatory=$true)]
    [string]$AgentName
)

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$agentPath = "D:\AgentSystem\$AgentName"
$backupDir = "D:\AgentSystem\Backups\$AgentName"
$backupFile = "$backupDir\brain-backup-$timestamp.zip"
$brainPath = "$agentPath\brain"

# Validate agent exists
if (-not (Test-Path $brainPath)) {
    Write-Host "ERROR: Agent brain not found at $brainPath" -ForegroundColor Red
    exit 1
}

# Create backup directory if not exists
if (-not (Test-Path $backupDir)) {
    New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
    Write-Host "Created backup directory: $backupDir" -ForegroundColor Yellow
}

try {
    # Create compressed backup
    Write-Host "Backing up $AgentName brain..." -ForegroundColor Cyan
    Compress-Archive -Path "$brainPath\*" -DestinationPath $backupFile -Force
    
    # Validate backup was created
    if (Test-Path $backupFile) {
        $backupSize = (Get-Item $backupFile).Length
        Write-Host "? Backup created: $backupFile ($backupSize bytes)" -ForegroundColor Green
    } else {
        throw "Backup file was not created"
    }
    
    # Implement 5-version rotation
    $backups = Get-ChildItem -Path $backupDir -Filter "brain-backup-*.zip" | 
               Sort-Object CreationTime -Descending
    
    if ($backups.Count -gt 5) {
        $toDelete = $backups | Select-Object -Skip 5
        foreach ($old in $toDelete) {
            Remove-Item $old.FullName -Force
            Write-Host "? Deleted old backup: $($old.Name)" -ForegroundColor Yellow
        }
    }
    
    # Log to agent's evolution log
    $logEntry = "- [$(Get-Date -Format 'yyyy-MM-dd HH:mm')] Brain backup created: $timestamp"
    Add-Content -Path "$brainPath\evolution-log.md" -Value $logEntry
    
    Write-Host "? Backup complete. Total versions: $($backups.Count)" -ForegroundColor Green
    
} catch {
    Write-Host "ERROR: Backup failed - $_" -ForegroundColor Red
    exit 1
}
