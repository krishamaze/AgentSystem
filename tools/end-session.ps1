# End session and capture outcome feedback
# Triggers optimization review if needed

param(
    [ValidateSet("SUCCESS", "PARTIAL_FAILURE", "FAILURE")]
    [string]$Outcome = "SUCCESS",
    [string]$UserFeedback = "",
    [ValidateRange(1,5)]
    [int]$Satisfaction = 5
)

if (-not $env:SESSION_ID) {
    Write-Output "⚠️  No active session found"
    $env:SESSION_ID = "manual_session_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    $env:SESSION_START = Get-Date
    $env:COMMAND_COUNT = 0
    $env:ERROR_COUNT = 0
    $env:CONTEXT_REQUEST_COUNT = 0
}

$duration = ((Get-Date) - [datetime]$env:SESSION_START).TotalSeconds

# Collect final session metrics
$sessionMetrics = @{
    session_id = $env:SESSION_ID
    timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    duration_seconds = [math]::Round($duration, 0)
    commands_executed = [int]$env:COMMAND_COUNT
    errors = [int]$env:ERROR_COUNT
    context_requests = [int]$env:CONTEXT_REQUEST_COUNT
    outcome = $Outcome
    satisfaction = $Satisfaction
    user_feedback = $UserFeedback
}

# Save to telemetry
Add-Content ".meta\telemetry.jsonl" -Value ($sessionMetrics | ConvertTo-Json -Compress)

Write-Output "=== SESSION ENDED ==="
Write-Output "  Session: $($env:SESSION_ID)"
Write-Output "  Duration: $([math]::Round($duration/60, 1)) minutes"
Write-Output "  Commands: $($env:COMMAND_COUNT)"
Write-Output "  Outcome: $Outcome"
Write-Output "  Satisfaction: $Satisfaction/5"
Write-Output "  Feedback: $UserFeedback"
Write-Output ""
Write-Output "✓ Session metrics saved to telemetry"

# Clear session variables
Remove-Item Env:\SESSION_ID -ErrorAction SilentlyContinue
Remove-Item Env:\SESSION_START -ErrorAction SilentlyContinue
Remove-Item Env:\COMMAND_COUNT -ErrorAction SilentlyContinue
Remove-Item Env:\ERROR_COUNT -ErrorAction SilentlyContinue
Remove-Item Env:\CONTEXT_REQUEST_COUNT -ErrorAction SilentlyContinue
Remove-Item Env:\TOOLS_USED -ErrorAction SilentlyContinue
