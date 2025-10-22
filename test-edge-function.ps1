Write-Output "=== TESTING EDGE FUNCTION WITH AUTH ==="

# Load environment
$envContent = Get-Content ".\.env" -Raw
$anonKey = ($envContent | Select-String "SUPABASE_ANON_KEY=(.+)" -AllMatches).Matches.Groups[1].Value

$url = "https://fihvhtoqviivmasjaqxc.supabase.co/functions/v1/get-agent-memory"
$headers = @{
    "Authorization" = "Bearer $anonKey"
    "Content-Type" = "application/json"
}
$body = @{ agent = "Agent_Primary" } | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri $url -Method POST -Headers $headers -Body $body
    Write-Output "✓ Edge function working!"
    Write-Output "  Memories found: $($response.count)"
    Write-Output "  Timestamp: $($response.timestamp)"
} catch {
    Write-Output "✗ Error: $($_.Exception.Message)"
    Write-Output "  Status: $($_.Exception.Response.StatusCode.value__)"
}
