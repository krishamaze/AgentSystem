# TASK ASSIGNMENT: Intelligent Resurrection System Enhancement
**Assigned By:** Agent_Primary
**Priority:** HIGH
**Target:** D:\AgentSystem\resurrect-me.ps1

## Current State
- resurrect-me.ps1 only dumps brain file contents
- No analysis or context awareness
- No actionable recommendations
- User must manually parse output to determine next steps

## Enhancement Requirements

### 1. Brain State Analysis
**Parse and extract:**
- All learnings from learned-knowledge.md
- Most recent 5 evolution log entries
- Active tasks from current-task.md (if exists)
- Project context from Projects\*/context.md

### 2. Pending Task Detection
**Identify:**
- Incomplete tasks mentioned in brain files
- Phrases: "Next:", "TODO:", "Pending:", "Phase N:", "Will be"
- Extract task descriptions and priority indicators
- Count total pending items per agent

### 3. Active Project Listing
**Extract from Projects directory:**
- Project name and path
- Current branch (if Git context available)
- Last update timestamp
- Active work description
- Modified files count

### 4. Intelligent Recommendations
**Generate 3 context-aware suggestions:**
- Priority 1: Most urgent pending task
- Priority 2: Longest stalled project/task
- Priority 3: System maintenance (backups, health checks)

**Recommendation format:**
[Priority] Action: <description>
Reason: <why this matters>
Command: <optional PowerShell to execute>

### 5. Interactive Resurrection UI
**Present at script execution:**
- Agent name and brain health status
- Summary: X learnings, Y pending tasks, Z active projects
- Pending tasks list (numbered)
- Active projects list
- Top 3 recommendations
- Options menu:
  [1] Continue last task
  [2] Start new task
  [3] Check system health
  [4] View full brain dump
  [5] Exit

## Technical Design

### Script Structure
\\\
1. Load brain files into variables
2. Parse learned-knowledge.md (regex: ## Learning:)
3. Parse evolution-log.md (last 5 entries)
4. Scan for pending task patterns
5. Check Projects directory
6. Generate recommendations (ranking algorithm)
7. Display interactive menu
8. Wait for user selection
9. Execute selected action or dump brain
\\\

### Key Functions to Implement
- **Parse-BrainFiles**: Load all brain files into hashtable
- **Extract-PendingTasks**: Regex scan for task indicators
- **Get-ActiveProjects**: Enumerate Projects directory
- **Generate-Recommendations**: Priority ranking logic
- **Show-ResurrectionMenu**: Interactive display
- **Execute-Action**: Handle user selection

### Pattern Recognition
**Pending task indicators:**
- Regex: (Next|TODO|Pending|Phase \d+|Will be|Expected|Awaiting)
- Context window: 2 sentences around match
- Priority keywords: CRITICAL, urgent, blocked, failed

**Project activity:**
- context.md exists = active project
- Last Updated timestamp < 24h = hot project
- Branch name contains: feature|bug|fix = work in progress

## Implementation Phases

**Phase 1:** Parser functions (brain files ? structured data)
**Phase 2:** Analysis engine (detect tasks, projects, priorities)
**Phase 3:** Recommendation algorithm (rank by urgency/age)
**Phase 4:** Interactive UI (menu system with options)
**Phase 5:** Integration test (run on all 3 agents)

## Success Criteria
- Resurrection shows context summary in <3 seconds
- Correctly identifies 90%+ of pending tasks
- Lists all active projects with timestamps
- Recommendations are actionable and ranked
- User can select action without reading full brain dump
- Backward compatible: option to view raw brain dump

## Testing Plan
1. Test on Agent_Primary (most complex brain)
2. Test on Agent_Agent_Architect (has current-task.md)
3. Test on Agent_CodeAssist (minimal brain)
4. Test with missing files (graceful degradation)
5. Test recommendation ranking accuracy

## Deliverables
- Enhanced resurrect-me.ps1 with intelligence layer
- Documentation in resurrect-me-guide.md
- Test results from all agents
- Brain update logging implementation success
