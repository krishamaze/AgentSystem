# Task Completion Checklist Protocol

**Before marking ANY task complete, verify:**

## 1. Component Level
- [ ] New files created
- [ ] New files tested
- [ ] Old files backed up

## 2. Integration Level
- [ ] Entry points updated (initCMD.txt, README, docs)
- [ ] Related files updated (anything referencing old version)
- [ ] Dependencies checked (what calls what?)

## 3. End-to-End Level
- [ ] Full workflow tested (start → finish)
- [ ] User-facing files updated (what user sees first)
- [ ] Documentation reflects changes

## 4. Memory Level
- [ ] Task completion synced to mem0
- [ ] Known references documented
- [ ] Future refactor notes added

---

## Example: Init Evolution

Component: ✓ Created start-session.v3.1.ps1
Integration: ✗ **MISSED** - Didn't update initCMD.txt
End-to-End: ✗ **MISSED** - Didn't test full user flow
Memory: ✓ Synced to mem0

**Result:** Incomplete task

---

**Rule:** A task isn't complete until ALL four levels pass
