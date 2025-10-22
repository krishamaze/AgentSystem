# Apply LLM optimization decision to system
# Executes configuration changes based on LLM analysis

param(
    [Parameter(Mandatory=$true)]
    [string]$DecisionJson
)

Write-Output "=== APPLYING LLM OPTIMIZATION ==="

# Parse decision
try {
    $decision = $DecisionJson | ConvertFrom-Json
} catch {
    Write-Error "Invalid JSON format. Please provide valid decision JSON."
    return
}

# Validate required fields
if (-not $decision.action -or $decision.action -ne "SET_OPTIMIZATION") {
    Write-Error "Invalid action. Must be 'SET_OPTIMIZATION'"
    return
}

if (-not $decision.parameters) {
    Write-Error "Missing parameters in decision"
    return
}

# Load current config
$config = Get-Content ".meta\system-optimization.json" | ConvertFrom-Json
$previousConfig = $config.PSObject.Copy()

# Validate parameters
$params = $decision.parameters

if ($params.P0_bytes -and $params.P0_bytes -lt 300) {
    Write-Warning "⚠️  P0 allocation ($($params.P0_bytes) bytes) is very low. Minimum 300 bytes recommended."
}

if ($params.total_bytes -and $params.total_bytes -gt 5000) {
    Write-Warning "⚠️  Total bandwidth ($($params.total_bytes) bytes) is very high. May affect performance."
}

# Apply changes
Write-Output "`nApplying changes..."

if ($params.total_bytes) {
    $config.bandwidth.total_bytes = $params.total_bytes
    Write-Output "  Total bandwidth: $($previousConfig.bandwidth.total_bytes) → $($params.total_bytes) bytes"
}

if ($params.P0_bytes) {
    $config.bandwidth.P0_bytes = $params.P0_bytes
    Write-Output "  P0 allocation: $($previousConfig.bandwidth.P0_bytes) → $($params.P0_bytes) bytes"
}

if ($params.P1_strategy) {
    $config.bandwidth.P1_strategy = $params.P1_strategy
    Write-Output "  P1 strategy: $($previousConfig.bandwidth.P1_strategy) → $($params.P1_strategy)"
}

if ($params.P2_strategy) {
    $config.bandwidth.P2_strategy = $params.P2_strategy
    Write-Output "  P2 strategy: $($previousConfig.bandwidth.P2_strategy) → $($params.P2_strategy)"
}

if ($null -ne $params.adaptive) {
    $config.bandwidth.adaptive = $params.adaptive
    Write-Output "  Adaptive: $($previousConfig.bandwidth.adaptive) → $($params.adaptive)"
}

if ($params.learning_rate) {
    $config.learning.learning_rate = $params.learning_rate
    Write-Output "  Learning rate: $($params.learning_rate)"
}

# Update metadata
$config.last_updated = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$config.updated_by = "LLM_OPTIMIZER"

# Save updated config
$config | ConvertTo-Json -Depth 10 | Out-File ".meta\system-optimization.json" -Encoding UTF8

# Log decision
$logEntry = @{
    timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    decision = $decision.decision
    previous_config = @{
        total_bytes = $previousConfig.bandwidth.total_bytes
        P0_bytes = $previousConfig.bandwidth.P0_bytes
        P1_strategy = $previousConfig.bandwidth.P1_strategy
    }
    new_config = @{
        total_bytes = $config.bandwidth.total_bytes
        P0_bytes = $config.bandwidth.P0_bytes
        P1_strategy = $config.bandwidth.P1_strategy
    }
    reason = $decision.reason
    monitoring = $decision.monitoring
    review_after = $decision.review_after
} | ConvertTo-Json -Compress

Add-Content ".meta\optimization-log.jsonl" -Value $logEntry

Write-Output "`n✓ Optimization applied successfully"
Write-Output "`nReason: $($decision.reason)"
Write-Output "`nMonitoring: $($decision.monitoring -join ', ')"
Write-Output "Review after: $($decision.review_after) sessions"
Write-Output "`nConfiguration saved to .meta\system-optimization.json"
