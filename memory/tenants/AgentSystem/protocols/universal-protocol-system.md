# AI-Powered Universal Protocol System

**Version:** 1.0
**Created:** 2025-10-22 20:24
**Purpose:** Comprehensive protocols for all system operations
**Enforcement:** AI must follow these before any action

---

## Core Principle

**EVERY action must follow this sequence:**
1. Query mem0 for existing solutions
2. Analyze confidence (90%/50%/0%)
3. Check specific files mentioned
4. Decide: Update/Create/Skip
5. Execute with explanation
6. Sync learning to mem0

---

## Protocol 1: File Creation (Anti-Duplication)

### Before Creating ANY File:

**Step 1: Memory Check**
\\\python
result = client.search(
    f"file {filename} purpose location",
    filters={"AND": [{"user_id": "AgentSystem"}]}
)
\\\

**Step 2: Filesystem Check**
\\\powershell
Get-ChildItem -Recurse -Filter "{filename}" | Select FullName
\\\

**Step 3: Decision Matrix**
- File exists + same purpose → SKIP or UPDATE
- File exists + different purpose → RENAME new file
- File missing → CREATE
- Multiple copies found → CONSOLIDATE first

**NEVER create without checking both memory and filesystem**

---

## Protocol 2: Code Management (Anti-Bloat)

### Test Files
**Location:** All test files MUST be in \	ests/\ directory
**Naming:** \	est_{feature}_{number}.py\
**Cleanup:** Delete after success or consolidate into suite

### Legacy Code
**Detection:** Files in \Agent_*\ directories are legacy
**Action:** Move to \rchive/v2-agents/\ before v4.0
**Never use:** Only reference for migration

### Root Directory
**Allowed:** Core scripts only (sync, init, setup)
**Not allowed:** Test files, temporary scripts, experiments
**Rule:** If >20 .py files in root, audit required

---

## Protocol 3: Git Workflow (No Manual Backups)

### Backup Strategy
**Primary:** Git commits (every meaningful change)
**Secondary:** Git tags (milestones)
**Prohibited:** Manual \Backups/\ folders

### Commit Frequency
- After completing protocol steps
- Before major changes
- End of session

### What NOT to Commit
- \	est_*.py\ files (unless part of test suite)
- Temporary \.py\ scripts
- \Backups/\ folder

---

## Protocol 4: Directory Structure

### Canonical Locations
\\\
AgentSystem/
├── .meta/                     # System metadata only
├── memory/tenants/AgentSystem/
│   ├── protocols/            # This file and others
│   ├── knowledge/            # Consolidated learnings
│   ├── decisions/            # ADRs
│   └── research/             # Investigations
├── tools/                    # PowerShell automation
├── tests/                    # All test files
├── archive/                  # Deprecated code
└── [Core scripts only]       # Root level
\\\

### Deprecation Process
1. Mark as deprecated in memory
2. Move to \rchive/{reason}/\
3. Update all references
4. Commit with clear message

---

## Protocol 5: Test File Management

### Rules
1. All tests in \	ests/\ directory
2. Delete after verification unless part of suite
3. Name clearly: \	est_feature_scenario.py\
4. Maximum 5 test files at once

### Current Violation
**Found:** 14 test files in root
**Required Action:** Move to tests/ or delete

---

## Protocol 6: Deduplication (Weekly Audit)

### Automated Check
\\\powershell
.\tools\audit-duplicates.ps1 -AutoFix \False
\\\

### Manual Review
- Check duplicate filenames
- Compare content hashes
- Decide: merge, delete, or keep
- Update memory with canonical location

### Triggers for Immediate Audit
- >10 files with same name
- Directory >500 files
- Git repo >100MB

---

## Protocol 7: Memory-First Enforcement

### AI Must Follow
**Before ANY action:**
1. Search memory: \client.search(action_description)\
2. Report findings in thread
3. Get human confirmation if 50-90% match
4. Proceed only after analysis

### Violations
If AI skips memory check:
1. Human stops action
2. Document violation
3. Restart with proper protocol

---

## Protocol 8: Session Cleanup

### End of Every Session
1. Move test files to tests/ or delete
2. Commit meaningful changes
3. Update system-index.json
4. Sync session learnings to mem0

### Weekly
1. Run deduplication audit
2. Review archive/ contents
3. Clean up >30 day old test files

---

## Protocol 9: AI Self-Monitoring

### AI Must Track
- Memory queries skipped
- Files created without checking
- Duplicate files detected
- Protocol violations

### Report Format
\\\
Session: 10/22/2025 20:24:41
Memory checks: X/Y actions
Duplicates prevented: X
Protocol violations: X
\\\

---

## Protocol 10: Error Prevention

### Known Patterns
1. Directory before file (create dir first)
2. Quote escaping (use Out-File, not python -c)
3. NoneType iteration (check isinstance)
4. Set slicing (convert to list)

### Before Execution
- Check for known error patterns
- Validate file paths exist
- Verify data types

---

## Enforcement Mechanism

### AI Checklist (Before ANY action)
- [ ] Queried memory for existing solution
- [ ] Analyzed confidence level
- [ ] Checked filesystem if needed
- [ ] Decided: Update vs Create
- [ ] Explained reasoning in thread
- [ ] Will sync learning after

### Human Verification Points
- Protocol violations
- 50-90% confidence matches
- Major structural changes
- Deletions

---

## Success Metrics

### Weekly Report
- Files prevented from duplication: {count}
- Test files cleaned: {count}
- Memory queries performed: {count}
- Protocol adherence: {percentage}

### Targets
- Duplication prevention: 95%+
- Protocol adherence: 100%
- Test file cleanup: Weekly
- Memory-first: Every action

---

## Protocol Owner
Krishna (krishna_001)

## Changelog
- 2025-10-22: Created universal protocol system
- Next: Track metrics and iterate

---

**This protocol system is MANDATORY for all system operations.**
**AI must follow these protocols before, during, and after every action.**
