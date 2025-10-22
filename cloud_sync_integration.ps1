# Add this function to spawn-agent.ps1 to enable cloud sync

function Send-LearningToCloud {
    param(
        [string]$Title,
        [string]$Content,
        [string]$Category = "agent_learning",
        [string[]]$Tags = @()
    )
    
    $envPath = Join-Path $PWD ".env"
    $env:MEM0_API_KEY = (Get-Content $envPath | Where-Object {$_ -match "^MEM0_API_KEY="}).Split("=")[1]
    $env:SUPABASE_ANON_KEY = (Get-Content $envPath | Where-Object {$_ -match "^SUPABASE_ANON_KEY="}).Split("=")[1]
    
    $endpoint = "https://fihvhtoqviivmasjaqxc.supabase.co/functions/v1/websocket-bridge"
    $headers = @{
        "Authorization" = "Bearer $env:SUPABASE_ANON_KEY"
        "Content-Type" = "application/json"
    }
    
    $body = @{
        event = "new_learning"
        data = @{
            user_id = "00000000-0000-0000-0000-000000000000"
            title = $Title
            content = $Content
            category = $Category
            tags = $Tags
        }
    } | ConvertTo-Json -Depth 5
    
    try {
        $response = Invoke-RestMethod -Uri $endpoint -Method Post -Headers $headers -Body $body
        Write-Host "✅ Learning synced to cloud: $Title" -ForegroundColor Green
    } catch {
        Write-Host "⚠️ Cloud sync failed: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

# Usage example:
# Send-LearningToCloud -Title "New Error Pattern" -Content "Agent discovered XYZ pattern" -Tags @("error_handling", "patterns")
