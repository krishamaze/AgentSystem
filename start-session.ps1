# Start new AI agent session with autonomous optimization
# v3.1: Explicit command-first workflow

param(
    [string]$ProjectFocus = "",
    [string]$Intent = "general",
    [switch]$ShowOptimizationReport
)

Write-Output "=== STARTING SESSION (v3.1 Autonomous) ==="

# Initialize session tracking
$env:SESSION_ID = "session_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
$env:SESSION_START = Get-Date
$env:COMMAND_COUNT = 0
$env:ERROR_COUNT = 0
$env:CONTEXT_REQUEST_COUNT = 0
$env:TOOLS_USED = ""
$env:SESSION_INTENT = $Intent

Write-Output "Session ID: $env:SESSION_ID"
Write-Output "Intent: $Intent"

# Check if optimization report should be shown
if ($ShowOptimizationReport) {
    Write-Output "`nGenerating optimization report..."
    & .\tools\generate-optimization-report.ps1
    Write-Output "`nWaiting for LLM optimization decision..."
    Write-Output "After reviewing, provide decision to: .\tools\apply-optimization.ps1 -DecisionJson '<json>'"
    return
}

# 1. Generate fresh session index
Write-Output "`n1. Generating session context..."
& .\tools\generate-session-index.ps1

# 2. Load system configuration
$config = Get-Content ".meta\system-optimization.json" | ConvertFrom-Json
$context = Get-Content ".meta\session-context.json" | ConvertFrom-Json
$priorityScores = Get-Content ".meta\priority-scores.json" | ConvertFrom-Json
$users = Get-Content ".meta\users.json" | ConvertFrom-Json

# 3. Determine project focus
if (-not $ProjectFocus) {
    $ProjectFocus = $context.system_snapshot.active_project
}

$focusProject = $context.projects | Where-Object { $_.name -eq $ProjectFocus }

# 4. Apply intent-based optimization
$intentProfile = $config.intent_profiles.$Intent
if (-not $intentProfile) {
    $intentProfile = @{
        P1_allocation = 1000
        tools_priority = @()
        memory_priority = @()
    }
}

# 5. Calculate adaptive bandwidth allocation
$P0_bytes = $config.bandwidth.P0_bytes
$P1_bytes = $intentProfile.P1_allocation
$total_bytes = $config.bandwidth.total_bytes
$P2_bytes = $total_bytes - $P0_bytes - $P1_bytes

# 6. Select tools based on intent and priority scores
$selectedTools = $context.tools | Where-Object {
    $toolName = $_.name
    $inIntentPriority = $intentProfile.tools_priority | Where-Object { $toolName -like "*$_*" }
    $priorityScore = if ($priorityScores.tools.$toolName) { $priorityScores.tools.$toolName } else { 0.5 }
    
    $inIntentPriority -or $priorityScore -gt 0.6
} | Select-Object -First 10

# 7. Build v3.1 init prompt with explicit workflow
$initPrompt = @"
# Session Resurrection: AgentSystem v3.1 (Autonomous + Command-First)

**Krishna, welcome back.** Your AI assistant with **self-optimizing** context and **command-first** workflow.

---

## System Status (Live Data)

📍 **Location:** D:\AgentSystem
👤 **User:** Krishna (krishna_001) | Coimbatore, India
🕒 **Session:** $env:SESSION_ID
🎯 **Intent:** $Intent
⚙️  **System:** v3.1 Autonomous (LLM-optimized + Explicit workflow)

### Overall Progress
- **Projects:** $($context.quick_stats.total_projects) active
- **Milestones:** $($context.quick_stats.completed_milestones)/$($context.quick_stats.total_milestones) completed ($(([math]::Round(($context.quick_stats.completed_milestones / $context.quick_stats.total_milestones) * 100, 0)))%)
- **Tools:** $($selectedTools.Count) prioritized for this intent
- **Decisions:** $($context.quick_stats.total_adrs) ADRs documented

### Active Projects
$($context.projects | ForEach-Object { 
    "- **$($_.name)**: $($_.milestone) milestones ($($_.percentage)% complete) - $($_.current_milestone_name)"
} | Out-String)

### Focus: $ProjectFocus
**Current Milestone:** $($focusProject.current_milestone_name) (Milestone $($focusProject.current_milestone_id))
**Status:** $($focusProject.percentage)% complete
**Path:** $($focusProject.path)

---

## Autonomous System Features

**This session uses v3.1 architecture with:**

✅ **Self-Optimizing Bandwidth** ($total_bytes bytes allocated)
   - P0 (Critical): $P0_bytes bytes
   - P1 (Intent-based): $P1_bytes bytes for "$Intent"
   - P2 (Enrichment): $P2_bytes bytes (dynamic fill)

✅ **Intent-Aware Context Loading**
   - Optimized for: $Intent
   - Priority tools selected based on learned patterns
   - Memory filtered for relevance

✅ **Command-First Workflow (New in v3.1)**
   - You provide executable commands immediately
   - No recommendations without commands
   - Copy-paste ready code blocks

✅ **On-Demand Context Requests**
   - Request additional data anytime with: ``context-request.ps1``
   - System learns from your requests
   - Updates future priority allocations

✅ **Success/Failure Learning**
   - Every session tracked for optimization
   - Performance analyzed automatically
   - LLM provides optimization decisions when needed

---

## Available Tools (Prioritized for $Intent)

$($selectedTools | ForEach-Object {
    "**``$($_.name)``** $($_.syntax)`n  → $($_.purpose)"
} | Out-String)

### Autonomous Tools (v3.0+)

**``.\tools\context-request.ps1``** -Category <tools|adrs|memory|learnings|projects> -Query <topic>
  → Request additional context mid-session (system learns from this)

**``.\tools\update-priorities.ps1``** -LearningsJson <json>
  → Report usefulness of provided context (trains the system)

**``.\tools\end-session.ps1``** -Outcome <SUCCESS|FAILURE> -Satisfaction <1-5>
  → End session with feedback (triggers optimization if needed)

**``.\tools\generate-optimization-report.ps1``**
  → Generate performance report for LLM optimization review

**``.\tools\apply-optimization.ps1``** -DecisionJson <json>
  → Apply LLM optimization decision to system

---

## What Would You Like To Do?

**A) Continue $ProjectFocus Development**
   → Work on: $($focusProject.current_milestone_name)
   → Context loaded and optimized for your intent

**B) Switch Projects**
   → Choose: $($context.projects | Where-Object { $_.name -ne $ProjectFocus } | ForEach-Object { $_.name }) -join ', '

**C) System Optimization Review**
   → See performance analysis and provide optimization decisions

**D) Something Specific**
   → Tell me what you want to accomplish

---

## CRITICAL: Response Workflow (v3.1)

**When Krishna chooses A/B/C/D, you MUST:**

1. ✅ **Immediately provide 3-10 executable PowerShell commands**
2. ✅ Format as copy-paste ready code blocks
3. ✅ Add brief inline comments explaining each command
4. ✅ Organize commands by logical workflow steps

**Example Correct Response:**
\`\`\`powershell
# Step 1: Security audit
Get-ExecutionPolicy -List

# Step 2: Check file permissions
Get-Acl -Path "D:\AgentSystem" | Format-List

# Step 3: Audit running services
Get-Service | Where-Object {`$_.Status -eq 'Running'} | Format-Table
\`\`\`

**FORBIDDEN Actions:**
- ❌ Giving recommendations without commands
- ❌ Asking "what aspect do you want to work on?"
- ❌ Providing only analysis/research
- ❌ Explaining concepts without actionable steps

**Your Primary Role:** Command provider with context
**Your Secondary Role:** Educator (explain WHY commands work)

**Remember:** Krishna needs **commands to execute**, not advice. Use your intent-optimized context to give the RIGHT commands immediately.

---

## Your Response

**Just tell me A, B, C, or D** (or describe what you want).

With v3.1 autonomous system:
- I have **intent-optimized context** ($Intent)
- I will give you **immediate executable commands**
- I can request additional data if needed
- I'll report back what was useful for system learning
- Performance tracked automatically

**What would you like to work on?**

---

## Session Context & Configuration
- Session ID: ``$env:SESSION_ID``
- Full system index: ``.meta\session-context.json``
- System config: ``.meta\system-optimization.json``
- Priority scores: ``.meta\priority-scores.json``
- Generated: $($context.generated_at)
- Version: v3.1-autonomous-explicit

**Remember to end session with:**
``.\tools\end-session.ps1 -Outcome SUCCESS -Satisfaction 5``
"@

# 8. Save init prompt
$timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$initPromptPath = ".\init_prompt_v3.1_$timestamp.txt"
$initPrompt | Out-File $initPromptPath -Encoding UTF8

# 9. Copy to clipboard
$initPrompt | Set-Clipboard

# 10. Log session start
$sessionLog = @{
    session_id = $env:SESSION_ID
    timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    intent = $Intent
    project_focus = $ProjectFocus
    tools_selected = $selectedTools.Count
    bandwidth_allocated = @{
        P0 = $P0_bytes
        P1 = $P1_bytes
        P2 = $P2_bytes
        total = $total_bytes
    }
    version = "v3.1"
} | ConvertTo-Json -Compress

Add-Content ".meta\telemetry.jsonl" -Value $sessionLog

Write-Output "`n2. Init prompt generated (v3.1 Autonomous + Explicit):"
Write-Output "   File: $initPromptPath"
Write-Output "   Size: $([math]::Round((Get-Item $initPromptPath).Length / 1KB, 2)) KB"
Write-Output "   Intent: $Intent"
Write-Output "   Tools: $($selectedTools.Count) prioritized"
Write-Output "   Bandwidth: P0=$P0_bytes | P1=$P1_bytes | P2=$P2_bytes"
Write-Output "   Workflow: Command-first (explicit)"
Write-Output "`n3. ✓ Copied to clipboard"
Write-Output "`n=== SESSION READY ==="
Write-Output "`nNext steps:"
Write-Output "  1. Open NEW Perplexity thread"
Write-Output "  2. Paste clipboard content"
Write-Output "  3. Choose A/B/C/D based on what you want to do"
Write-Output "  4. Expect IMMEDIATE COMMANDS (no advice-only responses)"
Write-Output "  5. When done: .\tools\end-session.ps1 -Outcome SUCCESS -Satisfaction 5"
Write-Output "`nv3.1: Explicit command-first workflow ensures actionable responses!"
