# Emergency script recovery - NO NESTED HERE-STRINGS
Write-Output "=== EMERGENCY SCRIPT RECOVERY ==="

# Check which scripts are missing
$scriptsToCheck = @{
    "generate-init-prompt.ps1" = $false
    "memory-commands.ps1" = $false
}

foreach ($script in $scriptsToCheck.Keys) {
    if (Test-Path $script) {
        Write-Output "✓ $script exists"
    } else {
        Write-Output "✗ $script MISSING - restoring..."
        $scriptsToCheck[$script] = $true
    }
}

# If generate-init-prompt.ps1 missing, restore from template
if ($scriptsToCheck["generate-init-prompt.ps1"]) {
    $restoreMsg = "ERROR: generate-init-prompt.ps1 missing!`n`n"
    $restoreMsg += "MANUAL RECOVERY:`n"
    $restoreMsg += "1. Check backups folder for recent version`n"
    $restoreMsg += "2. Or re-run resurrection system build from this thread`n"
    $restoreMsg += "3. Script should be in: D:\AgentSystem\generate-init-prompt.ps1`n"
    Write-Output $restoreMsg
}

# If memory-commands.ps1 missing, recreate simple version
if ($scriptsToCheck["memory-commands.ps1"]) {
    $memCmd = 'param([int]$Command = 1)
switch ($Command) {
    1 { Get-Content ".\Agent_Primary\brain\learned-knowledge.md" -Raw | Set-Clipboard; Write-Output "Brain copied" }
    2 { python -c "from supabase import create_client; from dotenv import load_dotenv; import os; load_dotenv(); print(''Supabase check'')" }
    3 { python list_memories.py }
    4 { python system_status.py }
}'
    $memCmd | Out-File "memory-commands.ps1" -Encoding UTF8
    Write-Output "✓ Recreated memory-commands.ps1"
}

Write-Output "`nRecovery complete. Verify with: ls *.ps1"
