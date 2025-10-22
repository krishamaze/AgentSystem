# Task Continuity Protocol

**Version:** 1.0
**Created:** 2025-10-22 21:04
**Purpose:** Prevent incomplete tasks from being forgotten during deviations
**Critical:** Addresses the "we deviated to protocol creation, forgot cleanup" problem

---

## The Problem

**Scenario:** 
1. Start Task A (cleanup system bloat)
2. Discover need for Task B (create protocol)
3. Work on Task B
4. **Forget to complete Task A**

**Result:** Incomplete work, forgotten context, system bloat continues

---

## The Solution: Active Task Stack

### Protocol Rule
**Before starting ANY new task, document the current incomplete task.**

### Implementation

#### Step 1: Task Stack File
Location: \.meta/active-task-stack.json\

Structure:
\\\json
{
  "stack": [
    {
      "task_id": "cleanup-001",
      "task_name": "System Bloat Cleanup",
      "started": "2025-10-22 20:15",
      "status": "IN_PROGRESS",
      "completed_steps": [
        "Moved test files to tests/",
        "Archived Agent_* directories"
      ],
      "remaining_steps": [
        "Consolidate knowledge files",
        "Commit cleanup changes",
        "Update system index"
      ],
      "blocked_by": null,
      "priority": "HIGH"
    }
  ],
  "last_updated": "2025-10-22 20:24"
}
\\\

#### Step 2: Before Deviation
**When starting new task while another is incomplete:**

\\\powershell
# Push current task to stack
.\tools\push-task.ps1 -TaskName "Current Task" -Status "PAUSED" -RemainingSteps @("step1", "step2")

# Start new task
.\tools\push-task.ps1 -TaskName "New Task" -Status "ACTIVE"
\\\

#### Step 3: After Completing Sub-task
**When sub-task completes, pop back to original:**

\\\powershell
# Complete current task
.\tools\pop-task.ps1 -Status "COMPLETE"

# Resume previous task (automatically shown)
\\\

---

## AI Enforcement

### Before Starting New Task
**AI must:**
1. Check if current task is incomplete
2. If yes, ask human: "Current task X is incomplete. Should I:"
   - Pause and stack it
   - Complete it first
   - Abandon it
3. Update task stack accordingly

### Session Start
**AI must:**
1. Read \.meta/active-task-stack.json\
2. Report any incomplete tasks
3. Ask: "Resume task X or start new?"

### Session End
**AI must:**
1. Review task stack
2. Warn about incomplete tasks
3. Update all task statuses

---

## Example: Today's Scenario

**What happened:**
\\\
[20:15] Task: Cleanup system bloat (STARTED)
  ├─ Step 1: Move test files ✓
  ├─ Step 2: Archive Agent_* ✓
  ├─ [DEVIATION] Need to create protocol
  │   └─ Task: Create universal protocol (STARTED)
  │       └─ Step 1: Create protocol.md ✓
  └─ User noticed: "We forgot to finish cleanup!"
\\\

**What should happen:**
\\\
[20:15] Task: Cleanup system bloat (STARTED)
  ├─ Step 1: Move test files ✓
  ├─ Step 2: Archive Agent_* ✓
  ├─ [AI DETECTS DEVIATION]
  │   AI: "Creating protocol is a new task. Should I:"
  │       "1. Pause cleanup (3 steps remaining)"
  │       "2. Complete cleanup first"
  │   User: "Pause cleanup, create protocol"
  │   └─ Task: Cleanup → PAUSED (pushed to stack)
  │   └─ Task: Create protocol (STARTED)
  │       └─ Step 1: Create protocol.md ✓
  │       └─ [POP BACK TO STACK]
  └─ Task: Cleanup (RESUMED)
      ├─ Step 3: Consolidate knowledge ✓
      ├─ Step 4: Commit changes (NEXT)
\\\

---

## Task Stack Commands

### Push Task (Pause Current)
\\\powershell
.\tools\push-task.ps1 \
  -TaskName "System Cleanup" \
  -Status "PAUSED" \
  -CompletedSteps @("test files", "archive legacy") \
  -RemainingSteps @("consolidate", "commit", "sync")
\\\

### Pop Task (Resume Previous)
\\\powershell
.\tools\pop-task.ps1 -Status "COMPLETE"
# Automatically shows previous task
\\\

### View Stack
\\\powershell
.\tools\view-task-stack.ps1
\\\

### Clear Completed
\\\powershell
.\tools\clear-completed-tasks.ps1
\\\

---

## Integration with Memory-First

### Combined Workflow
1. **Query memory** for existing solution
2. **Check task stack** for current work
3. If starting new task → Push current to stack
4. Execute new task
5. Pop back to previous task
6. **Sync to mem0** when complete

---

## Benefits

1. **No Lost Context:** Every task tracked
2. **Clear Priorities:** Stack shows what matters
3. **Accountability:** See incomplete work
4. **Efficiency:** Resume where you left off
5. **Memory Aid:** AI + Human both benefit

---

## Current Task Stack Status

**Active Tasks (as of 2025-10-22 21:04):**
- System Bloat Cleanup: IN_PROGRESS (3/7 steps complete)
  - Remaining: Commit, Update index, Sync to mem0

**Next Action:** Complete cleanup task, then commit everything

---

## Protocol Owner
Krishna (krishna_001)

## Changelog
- 2025-10-22: Created task continuity protocol
- Next: Implement tools (push-task.ps1, pop-task.ps1)

---

**This protocol prevents forgotten work and context loss during task deviations.**
