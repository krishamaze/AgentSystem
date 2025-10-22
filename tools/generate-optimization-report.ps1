# Generate self-assessment report for LLM optimization
# Analyzes historical performance and provides recommendations

$config = Get-Content ".meta\system-optimization.json" | ConvertFrom-Json
$priorityScores = Get-Content ".meta\priority-scores.json" | ConvertFrom-Json

# Load recent telemetry
$allSessions = Get-Content ".meta\telemetry.jsonl" | 
    Where-Object { $_ } | 
    ConvertFrom-Json |
    Where-Object { $_.outcome }

$recentSessions = $allSessions | Select-Object -Last 20

# Calculate metrics by intent (if available)
$intentMetrics = @{}
foreach ($session in $recentSessions) {
    $intent = if ($session.intent) { $session.intent } else { "general" }
    
    if (-not $intentMetrics[$intent]) {
        $intentMetrics[$intent] = @{
            sessions = @()
            avg_time = 0
            success_rate = 0
            avg_context_requests = 0
            avg_commands = 0
        }
    }
    
    $intentMetrics[$intent].sessions += $session
}

# Generate report
$report = @"
# System Self-Assessment Report
Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Total Sessions Analyzed: $($recentSessions.Count)

---

## Historical Performance (Last 20 Sessions)

"@

foreach ($intent in $intentMetrics.Keys) {
    $sessions = $intentMetrics[$intent].sessions
    $successCount = ($sessions | Where-Object { $_.outcome -eq "SUCCESS" }).Count
    $successRate = if ($sessions.Count -gt 0) { $successCount / $sessions.Count } else { 0 }
    $avgTime = ($sessions | Measure-Object -Property duration_seconds -Average).Average
    $avgRequests = ($sessions | Measure-Object -Property context_requests -Average).Average
    $avgCommands = ($sessions | Measure-Object -Property commands_executed -Average).Average
    
    $report += @"

### Intent: $intent
- Sessions: $($sessions.Count)
- Success Rate: $([math]::Round($successRate * 100, 0))%
- Avg Duration: $([math]::Round($avgTime, 0))s
- Avg Context Requests: $([math]::Round($avgRequests, 1))
- Avg Commands: $([math]::Round($avgCommands, 1))

"@
}

# Current configuration
$report += @"

---

## Current System Configuration

**Bandwidth Allocation:**
- Total: $($config.bandwidth.total_bytes) bytes
- P0 (Critical): $($config.bandwidth.P0_bytes) bytes ($([math]::Round(($config.bandwidth.P0_bytes / $config.bandwidth.total_bytes) * 100, 0))%)
- P1 Strategy: $($config.bandwidth.P1_strategy)
- P2 Strategy: $($config.bandwidth.P2_strategy)
- Adaptive: $($config.bandwidth.adaptive)

**Intent Profiles:**
"@

foreach ($intent in $config.intent_profiles.PSObject.Properties.Name) {
    $profile = $config.intent_profiles.$intent
    $report += @"

- **$intent**: P1=$($profile.P1_allocation) bytes
  - Tools: $($profile.tools_priority -join ', ')
  - Memory: $($profile.memory_priority -join ', ')
"@
}

# Analysis and recommendations
$overallSuccess = ($recentSessions | Where-Object { $_.outcome -eq "SUCCESS" }).Count / $recentSessions.Count
$overallSatisfaction = ($recentSessions | Measure-Object -Property satisfaction -Average).Average
$avgContextRequests = ($recentSessions | Measure-Object -Property context_requests -Average).Average

$report += @"

---

## Performance Analysis

**Overall Metrics:**
- Success Rate: $([math]::Round($overallSuccess * 100, 0))%
- Avg Satisfaction: $([math]::Round($overallSatisfaction, 2))/5
- Avg Context Requests: $([math]::Round($avgContextRequests, 1))

**Thresholds:**
- Success Threshold: $([math]::Round($config.learning.optimization_threshold * 100, 0))%
- Satisfaction Threshold: $($config.learning.satisfaction_threshold)/5

**Status:** $(if ($overallSuccess -ge $config.learning.optimization_threshold -and $overallSatisfaction -ge $config.learning.satisfaction_threshold) { "✓ HEALTHY" } else { "⚠️ NEEDS OPTIMIZATION" })

---

## Detected Issues

"@

# Detect issues
$issues = @()

if ($overallSuccess -lt $config.learning.optimization_threshold) {
    $issues += "- Low success rate ($([math]::Round($overallSuccess * 100, 0))%) - below $([math]::Round($config.learning.optimization_threshold * 100, 0))% threshold"
}

if ($overallSatisfaction -lt $config.learning.satisfaction_threshold) {
    $issues += "- Low satisfaction ($([math]::Round($overallSatisfaction, 2))/5) - below $($config.learning.satisfaction_threshold)/5 threshold"
}

if ($avgContextRequests -gt 5) {
    $issues += "- High context requests ($([math]::Round($avgContextRequests, 1)) avg) - suggests insufficient initial context"
}

if ($issues.Count -eq 0) {
    $report += "No critical issues detected.`n"
} else {
    $report += ($issues -join "`n") + "`n"
}

# Optimization recommendations
$report += @"

---

## Optimization Recommendations

Based on the analysis, here are the optimization options:

**Option A: Increase P1 Allocation (Conservative)**
- Increase P1 allocation by 15% across all intents
- Rationale: High context requests suggest insufficient initial context
- Risk: Low (slight increase in init prompt size)

**Option B: Adjust Intent Profiles (Moderate)**
- Rebalance P0/P1/P2 based on actual usage patterns
- Increase allocation for high-usage intents
- Decrease allocation for low-usage intents
- Risk: Medium (requires careful tuning)

**Option C: Increase Total Bandwidth (Aggressive)**
- Increase total bandwidth from $($config.bandwidth.total_bytes) to $($config.bandwidth.total_bytes + 500) bytes
- Distribute additional space to P1 and P2
- Risk: Medium (larger init prompts may affect performance)

**Option D: Enable Dynamic Learning (Optimal)**
- Implement per-session bandwidth calculation
- Learn from each session's actual usage
- Adjust allocations automatically based on success patterns
- Risk: Low (adaptive and self-correcting)

---

## LLM Decision Required

Please analyze this report and provide your optimization decision in the following format:

\`\`\`json
{
  "action": "SET_OPTIMIZATION",
  "decision": "Option D",
  "parameters": {
    "total_bytes": 3500,
    "P0_bytes": 450,
    "P1_strategy": "dynamic-learning",
    "P2_strategy": "fill-remaining",
    "adaptive": true,
    "learning_rate": 0.1
  },
  "reason": "Your analysis and reasoning here",
  "monitoring": ["success_rate", "context_requests", "satisfaction"],
  "review_after": 10
}
\`\`\`

Once you provide this, run:
\`\`\`powershell
.\tools\apply-optimization.ps1 -DecisionJson '<your-json>'
\`\`\`

"@

# Save report
$reportPath = ".\optimization-report-$(Get-Date -Format 'yyyyMMdd_HHmmss').md"
$report | Out-File $reportPath -Encoding UTF8

Write-Output "✓ Optimization report generated: $reportPath"
Write-Output "`nReview the report and provide LLM decision to apply-optimization.ps1"

# Display report
Write-Output "`n$report"
