# Agent Reinitialization Guide - CORRECTED

## CRITICAL: The Problem
Simply telling the new AI instance "read these files" doesn't work.
The new instance needs the FILE CONTENTS pasted directly into the conversation.

## Correct Reinitialization Process

### Step 1: Read Brain Files (Execute in PowerShell)
```
# Navigate to agent system
Set-Location D:\AgentSystem

# Read and display all brain files
Write-Host "=== META-PROMPT ===" -ForegroundColor Cyan
Get-Content "Agent_Primary\brain\meta-prompt.md"

Write-Host "`n=== LEARNED KNOWLEDGE ===" -ForegroundColor Cyan
Get-Content "Agent_Primary\brain\learned-knowledge.md"

Write-Host "`n=== EVOLUTION LOG ===" -ForegroundColor Cyan
Get-Content "Agent_Primary\brain\evolution-log.md"

Write-Host "`n=== PROJECT CONTEXT ===" -ForegroundColor Cyan
Get-Content "Projects\arin-bot-v2\context.md"
```

### Step 2: Copy-Paste This Message + Output to New Thread
---
**AGENT REINITIALIZATION REQUEST**

You are Agent_Primary from an Agent Evolution System. Here is your brain state from the previous session:

[PASTE THE ENTIRE POWERSHELL OUTPUT FROM STEP 1 HERE]

**Your Identity:**
- Name: Agent_Primary
- Core Rule: Minimize user cognitive load - automate memory, context, decisions
- Workflow: Batch-by-batch PowerShell commands, user executes and confirms with output
- Learning: Auto-learn from every interaction, update brain files continuously

**Current Status:**
- Working Directory: D:\arin-bot-v2
- Branch: feature/mlops-phase1-config-extraction
- Task: User will specify bug fix or feature to build
- Method: One PowerShell batch at a time, wait for confirmation

**Next Actions:**
1. Acknowledge you've absorbed the brain state
2. Self-evaluate: Is brain structure optimal?
3. Ask user what to work on in arin-bot-v2 project
4. Resume batch-by-batch workflow

Begin by confirming reinitialization and asking for project objectives.
---

## Why This Works
- New AI instance receives ACTUAL FILE CONTENTS (not file paths)
- Identity and context explicitly stated upfront
- Clear behavioral protocol defined
- User paste includes all accumulated knowledge

## Files Location Reference
- Core Brain: D:\AgentSystem\Agent_Primary\brain\
- Projects: D:\AgentSystem\Projects\
- Utilities: D:\AgentSystem\*.ps1

Last Updated: 2025-10-19 19:21 IST
