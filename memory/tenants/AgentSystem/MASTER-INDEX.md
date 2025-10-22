# AgentSystem Master Index

**Generated:** 2025-10-22 19:39:12
**Purpose:** Complete map of everything in the system
**Update:** Regenerate this file after major changes

---

## 1. System Statistics

### Memory (Mem0 Platform)
- Total Memories: 148
- Categories: 6
  - Technology: 106
  - Professional: 19
  - Misc: 14
  - Personal: 11
  - Milestones: 10
  - User Preferences: 4

### Files
- Total Files: 246
- Python Scripts: 27
- PowerShell Tools: 17
- Markdown Docs: 54

---

## 2. Directory Structure

\\\
AgentSystem/
├── .meta/                    # System metadata, indexes, configs
├── memory/
│   └── tenants/
│       └── AgentSystem/
│           ├── decisions/    # ADRs (Architecture Decision Records)
│           ├── tasks/        # Task tracking documents
│           ├── research/     # Investigation findings
│           └── planning/     # Future ideas, roadmaps
├── tools/                    # PowerShell automation scripts
├── Projects/                 # Multi-tenant project data
└── [root files]             # Sync scripts, configs
\\\

---

## 3. Core Tools

### PowerShell Tools (tools/)
- \generate-context.ps1\ - Generate Repomix/Gitingest context
- \complete-milestone.ps1\ - Mark milestones complete
- \create-adr.ps1\ - Create architecture decisions
- \check-memory.ps1\ - Query project memory
- \pply-optimization.ps1\ - Apply LLM suggestions
- \context-request.ps1\ - Request mid-session context
- [+11 more tools]

### Python Scripts (root)
- \sync_agentsystem_to_mem0.py\ - Sync to Mem0 Platform
- \erify_sync.py\ - Verify memory sync
- \ix_json_bom.py\ - Remove UTF-8 BOM from JSON

---

## 4. Documentation

### Architecture Decisions (.meta/ or memory/decisions/)
- ADR-001: [Topic]
- ADR-002: [Topic]
- ADR-003: [Topic]
- ADR-004: v3.1 Autonomous Architecture

### Research Documents (memory/research/)
- \graphmem-investigation.md\ - Future graph memory research

### Task Tracking (memory/tasks/)
- \ix-bom-context-tools.md\ - COMPLETE (2025-10-22)
- \mem0-investigation.md\ - SUCCESS (2025-10-22)

---

## 5. Configuration Files

- \.env\ - Environment variables (MEM0_API_KEY)
- \epomix.config.json\ - Context generation config
- \.meta/tenant-registry.json\ - Project registry
- \.meta/system-index.json\ - System metadata

---

## 6. Future Ideas

### Priority 1: Auto-Sync Preferences
**Status:** NOT_STARTED
**Effort:** 2-3 hours
Automatically detect "I prefer..." statements and sync to mem0

### Priority 2: Master Index Auto-Generation
**Status:** IN_PROGRESS (This file!)
**Effort:** 1 hour
Script to regenerate this index automatically

---

## 7. Common Workflows

### Start Session
\\\powershell
.\start-session.ps1 -Intent "development"
\\\

### Generate Context for LLM
\\\powershell
.\tools\generate-context.ps1 -Tool both -CopyToClipboard
\\\

### Sync to Mem0
\\\powershell
python sync_agentsystem_to_mem0.py
\\\

### Complete Task/Milestone
\\\powershell
.\tools\complete-milestone.ps1 -ProjectName AgentSystem -MilestoneId 3
\\\

---

## 8. Error Learnings

### 2025-10-22: PowerShell Here-String Quote Escaping
**Error:** \NameError: name 'results' is not defined\
**Cause:** PowerShell here-strings escape quotes incorrectly in python -c
**Fix:** Use Out-File to create .py script instead

### 2025-10-22: NoneType Iteration
**Error:** \TypeError: 'NoneType' object is not iterable\
**Cause:** mem.get("categories", []) can return None
**Fix:** Add isinstance check before iteration

---

## 9. User Preferences (Krishna)

- Prefer explanations in chat thread, not just PowerShell
- Work one step/test/action at a time
- Sequential, batch-execute-verify workflow
- Document learnings from errors

---

## 10. Quick Reference

### Search Memories
\\\python
client.search("query", filters={"AND": [{"user_id": "AgentSystem"}]})
\\\

### Get All Memories
\\\python
client.get_all(filters={"AND": [{"user_id": "AgentSystem"}]}, page_size=150)
\\\

### Add Memory
\\\python
messages = [
    {"role": "user", "content": "fact"},
    {"role": "assistant", "content": "acknowledgment"}
]
client.add(messages, user_id="AgentSystem")
\\\

---

**Last Updated:** 2025-10-22 19:39
**Next Update:** After significant system changes
