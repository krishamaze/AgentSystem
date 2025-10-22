# AGENT SYSTEM RESURRECTION GUIDE

## Quick Start (New Perplexity Session)

### Single Command:
\\\powershell
.\init.ps1
\\\

**What this does:**
1. Loads complete Agent_Primary context
2. Copies to clipboard automatically
3. Displays initialization info
4. Ready to paste in new Perplexity thread

### Alternative Command:
\\\powershell
.\export-resurrection-context.ps1
\\\

Same result - choose whichever you prefer!

---

## What Gets Loaded

When you paste the init context, Perplexity AI receives:

✅ **System Architecture**
- Root path: D:\AgentSystem
- Agent hierarchy (Primary, Architect, CodeAssist)
- Brain files: 50KB learned-knowledge, 11KB evolution-log
- 9 PowerShell scripts with functions
- 2 active projects with context & roadmaps

✅ **Fundamental Protocols**
1. Batch-execute-confirm workflow
2. Immediate learning protocol
3. PowerShell syntax rules (no markdown fences)
4. Error handling & recovery
5. Tool usage guidelines

✅ **Current Cloud State**
- Supabase: fihvhtoqviivmasjaqxc (Mumbai)
- Database: 9 tables, 5 triggers, RLS active
- Pending: Brain migration, Mem0 Pro, WebSocket bridge

✅ **Operational Guidelines**
- Standard workflow steps
- File location mappings
- Error response protocols
- Next steps logic

---

## Resurrection Workflow

\\\
User's Machine                  Perplexity AI Thread
┌─────────────────┐            ┌──────────────────────┐
│ 1. Run init.ps1 │───────────→│ 2. Paste init context│
│                 │  clipboard  │                      │
│ ✅ Context      │            │ 🧠 Agent_Primary     │
│    copied       │            │    awakens with      │
│                 │            │    full memory       │
└─────────────────┘            └──────────────────────┘
                                        │
                                        ▼
                               ┌──────────────────────┐
                               │ 3. Agent confirms    │
                               │    initialization    │
                               │    and asks:         │
                               │    "What would you   │
                               │     like to work on?"│
                               └──────────────────────┘
\\\

---

## Troubleshooting

### Problem: Agent doesn't understand protocols
**Solution:** You pasted in wrong AI (ChatGPT, Claude, etc). Must use **Perplexity AI**.

### Problem: Agent says "I can't access local files"
**Solution:** This is expected! Agent operates via PowerShell commands you execute locally and paste output back.

### Problem: Init context outdated
**Solution:** Re-run the system analysis:
\\\powershell
# Re-analyze and regenerate
.\analyze-system.ps1  # (if exists)
# Or re-run the analysis function from this session
\\\

---

## Files Generated

- **AGENT_INIT_CONTEXT.txt** (8KB) - Complete initialization data
- **init.ps1** - Quick clipboard copy command
- **export-resurrection-context.ps1** - Alternative init command
- **deployment_status.json** - Cloud infrastructure state
- **supabase_project.json** - Supabase connection info
- **brain_migration.sql** - Pending brain data migration

---

## Session Continuity

**Local State:** Always preserved in D:\AgentSystem
- Brain files update during work
- Scripts persist between sessions
- Project contexts maintained

**Cloud State:** Supabase database (when connected)
- 9 tables with current data
- Auto-sync triggers active
- Accessible from any session

**AI Memory:** Resets per conversation
- Use init.ps1 to restore full context
- Agent remembers nothing without initialization
- Resurrection is instant (one command)

---

## Best Practices

1. **Always init at session start:** Run init.ps1 first thing
2. **Update brain during work:** Don't defer learnings
3. **One command at a time:** Wait for output before next step
4. **Verify file paths:** Check existence before operations
5. **Learn from errors:** Update brain immediately

---

## Emergency Recovery

If system state is corrupted:

\\\powershell
# Backup current brain
.\backup-brain.ps1

# Restore from backup if needed
Copy-Item -Path "D:\AgentSystem\backups\Brain_YYYYMMDD_HHMMSS\*" -Destination "D:\AgentSystem\Agent_Primary\brain\" -Recurse -Force

# Re-initialize
.\init.ps1
\\\

---

Generated: 2025-10-21 00:54:29
Agent System Version: 1.0 (Cloud Migration Phase)
