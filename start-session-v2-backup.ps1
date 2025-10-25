# Start new AI agent session
# Generates fresh index and creates init prompt

param([string]$ProjectFocus = "")

Write-Output "=== STARTING NEW SESSION ==="

# 1. Generate fresh session index
Write-Output "`n1. Generating session context..."
& .\tools\generate-session-index.ps1

# 2. Load the generated context
$context = Get-Content ".meta\session-context.json" | ConvertFrom-Json
$users = Get-Content ".meta\users.json" | ConvertFrom-Json

# 3. Determine project focus
if (-not $ProjectFocus) {
    $ProjectFocus = $context.system_snapshot.active_project
}

$focusProject = $context.projects | Where-Object { $_.name -eq $ProjectFocus }

# 4. Build ultra-compact Level 1 init prompt with Level 2 reference
$initPrompt = @"
# Session Resurrection: AgentSystem v2.0

**Krishna, welcome back.** Your AI assistant with complete system context.

---

## System Snapshot (Live Data)

📍 **Location:** D:\AgentSystem
👤 **User:** Krishna (krishna_001) | Coimbatore, India
🕒 **Generated:** $($context.generated_at)

### Overall Progress
- **Projects:** $($context.quick_stats.total_projects) active
- **Milestones:** $($context.quick_stats.completed_milestones)/$($context.quick_stats.total_milestones) completed ($(([math]::Round(($context.quick_stats.completed_milestones / $context.quick_stats.total_milestones) * 100, 0)))%)
- **Tools:** $($context.quick_stats.total_tools) available
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

## Complete System Context Available

**I have access to the full system blueprint** via ``session-context.json``:

✅ All $($context.quick_stats.total_tools) tools with exact syntax
✅ All $($context.quick_stats.total_adrs) architectural decisions
✅ All $($context.projects.Count) project details and progress
✅ Memory namespaces: $($context.memory_namespaces.Count) available
✅ Recent session: $($context.system_snapshot.last_session)

**This means I can:**
- Give intelligent batch commands (all syntax known)
- No discovery phase needed
- Direct execution based on complete context

---

## Tools Quick Reference

$($context.tools | ForEach-Object {
    "**``$($_.name)``** $($_.syntax)`n  → $($_.purpose)"
} | Out-String)

---

## What Would You Like To Do?

**A) Continue $ProjectFocus Development**
   → Work on: $($focusProject.current_milestone_name)
   → I have full context, ready to proceed

**B) Switch Projects**
   → Choose: $($context.projects | Where-Object { $_.name -ne $ProjectFocus } | ForEach-Object { $_.name }) -join ', '

**C) System Overview**
   → Show complete project status across all work

**D) Something Specific**
   → Tell me what you want to accomplish

---

## Your Response

**Just tell me A, B, C, or D** (or describe what you want).

With complete system context loaded, I can:
- Give you ready-to-run command batches
- Skip discovery phase entirely
- Execute efficiently based on your goal

**What would you like to work on?**

---

## Session Context Reference
Full system index: ``.meta\session-context.json``
Generated: $($context.generated_at)
Version: $($context.version)
"@

# 5. Save init prompt
$timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$initPromptPath = ".\init_prompt_v2_$timestamp.txt"
$initPrompt | Out-File $initPromptPath -Encoding UTF8

# 6. Copy to clipboard
$initPrompt | Set-Clipboard

Write-Output "`n2. Init prompt generated:"
Write-Output "   File: $initPromptPath"
Write-Output "   Size: $([math]::Round((Get-Item $initPromptPath).Length / 1KB, 2)) KB"
Write-Output "`n3. ✓ Copied to clipboard"
Write-Output "`n=== SESSION READY ==="
Write-Output "`nNext steps:"
Write-Output "  1. Open NEW Perplexity thread"
Write-Output "  2. Paste clipboard content"
Write-Output "  3. Choose A/B/C/D based on what you want to do"
Write-Output "`nThe AI will have complete system context and can give intelligent batch commands!"
