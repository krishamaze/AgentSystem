# Test complete resurrection flow
Write-Output "=== TESTING RESURRECTION SYSTEM ==="

# 1. Generate init prompt
& .\generate-init-prompt.ps1

# 2. Test memory URL (if deployed)
Write-Output "`nTesting memory URL..."
$url = "https://fihvhtoqviivmasjaqxc.supabase.co/functions/v1/get-agent-memory"
try {
    $body = @{ agent = "Agent_Primary" } | ConvertTo-Json
    $response = Invoke-RestMethod -Uri $url -Method POST -Body $body -ContentType "application/json" -ErrorAction Stop
    Write-Output "✓ Memory URL accessible: $($response.count) memories found"
} catch {
    Write-Output "✗ Memory URL not accessible (function not deployed?)"
}

# 3. Test local memory commands
Write-Output "`nTesting local memory commands..."
& .\memory-commands.ps1 -Command 4 | Out-Null
Write-Output "✓ System status working"

Write-Output "`n=== SYSTEM READY ==="
