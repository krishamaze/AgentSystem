# Daily maintenance - run this weekly
Write-Output "=== AGENTSYSTEM MAINTENANCE ==="

# 1. Backup .env
Write-Output "`n1. Backing up credentials..."
& .\backup-env.ps1

# 2. Check brain size
Write-Output "`n2. Checking brain size..."
& .\compress-brain.ps1

# 3. Sync to Supabase
Write-Output "`n3. Syncing to Supabase..."
python sync_all_learnings.py 2>&1 | Select-String -Pattern "Total synced"

# 4. Clean old temp files
Write-Output "`n4. Cleaning temp files..."
Get-ChildItem ".\init_prompt_*.txt" | 
    Sort-Object CreationTime -Descending | 
    Select-Object -Skip 5 | 
    Remove-Item
Write-Output "Cleaned old init prompts (kept 5 most recent)"

# 5. Verify critical scripts
Write-Output "`n5. Verifying critical scripts..."
$missing = @()
@("generate-init-prompt.ps1", "memory-commands.ps1", "system_status.py") | ForEach-Object {
    if (-not (Test-Path $_)) { $missing += $_ }
}
if ($missing.Count -gt 0) {
    Write-Output "⚠ Missing: $($missing -join ', ')"
    Write-Output "Run: .\EMERGENCY_RECOVERY.ps1"
} else {
    Write-Output "✓ All critical scripts present"
}

Write-Output "`n=== MAINTENANCE COMPLETE ==="
