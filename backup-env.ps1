# Backup .env to encrypted location
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$envContent = Get-Content ".env" -Raw

# Create backups folder
New-Item -ItemType Directory -Path ".\backups" -Force | Out-Null

# Save encrypted backup
$envContent | ConvertTo-SecureString -AsPlainText -Force | 
    ConvertFrom-SecureString | 
    Out-File ".\backups\.env_backup_$timestamp.txt"

# Save plain backup (in gitignored location)
Copy-Item ".env" ".\backups\.env_latest" -Force

# Keep only last 5 backups
Get-ChildItem ".\backups\.env_backup_*.txt" | 
    Sort-Object CreationTime -Descending | 
    Select-Object -Skip 5 | 
    Remove-Item

Write-Output ".env backed up to backups/.env_latest"
