# Mem0 Isolation Architecture - AgentSystem
**Created:** 2025-10-25 20:07:17 IST
**Version:** 1.0
**Status:** Design Complete

## Executive Summary
Three-tier isolation architecture using mem0 v1.0.0 native features:
- **Tier 1:** Namespace isolation via user_id/agent_id
- **Tier 2:** Metadata tagging for fine-grained filtering
- **Tier 3:** GraphMem for contextual relationships

## Architecture Overview

### Tier 1: Namespace Isolation
**Strategy:** Use distinct user_id for each project

| Project | user_id | Purpose |
|---------|---------|---------|
| AgentSystem | 'AgentSystem' | Meta-system coordination, protocols, learnings |
| product-label-bot | 'product-label-bot' | Barcode workflow, product catalog memories |
| arin-bot-v2 | 'arin-bot-v2' | Chat API, milestone tracking, Gemini integration |

**Benefits:**
- Hard isolation at API level
- Zero cross-contamination risk
- Native mem0 filtering support
- Simple query patterns

**Implementation:**
\\\python
# AgentSystem queries
client.search(query="...", filters={"user_id": "AgentSystem"})

# product-label-bot queries
client.search(query="...", filters={"user_id": "product-label-bot"})

# arin-bot-v2 queries
client.search(query="...", filters={"user_id": "arin-bot-v2"})
\\\

### Tier 2: Metadata Tagging
**Strategy:** Rich metadata for context and filtering

**Standard Metadata Schema:**
\\\python
metadata = {
    "project": "AgentSystem",           # Project name
    "milestone": "3",                   # Current milestone
    "session_id": "2025_10_25_2003",   # Session identifier
    "task_type": "research",            # task/decision/learning/error
    "importance": "high",               # low/medium/high/critical
    "tags": ["memory", "isolation"],    # Searchable tags
    "created_by": "claude",             # Agent identifier
    "parent_id": "mem_123"              # For hierarchical memories
}
\\\

**Categories (Custom Categories Enabled):**
- project
- milestone
- session
- task
- decision
- learning
- error

**Benefits:**
- Fine-grained filtering within project namespace
- Temporal queries (by session/milestone)
- Type-based retrieval (decisions vs learnings)
- Importance prioritization

**Implementation:**
\\\python
# Add memory with metadata
client.add(
    messages=[{"role": "user", "content": "..."}],
    user_id="AgentSystem",
    metadata={
        "project": "AgentSystem",
        "milestone": "3",
        "task_type": "decision",
        "importance": "high"
    }
)

# Search with metadata filters
client.search(
    query="isolation architecture",
    filters={
        "user_id": "AgentSystem",
        "metadata": {"task_type": "decision", "importance": "high"}
    }
)
\\\

### Tier 3: GraphMem Integration
**Strategy:** Enable graph relationships for context preservation

**Graph Capabilities:**
- Automatic entity extraction and linking
- Relationship discovery between memories
- Context-aware retrieval
- Cross-reference tracking

**Enabled via:**
\\\python
client.update_project(enable_graph=True)
\\\

**Use Cases:**
1. **Decision Lineage:** Track how decisions evolve across sessions
2. **Dependency Mapping:** Link related tasks/milestones
3. **Learning Chains:** Connect errors → fixes → learnings
4. **Cross-Project References:** Shared patterns (with explicit linking)

## Migration Plan

### Phase 1: Preparation (Current Session)
- [x] Research mem0 capabilities
- [x] Design 3-tier architecture
- [x] Enable GraphMem
- [ ] Create migration scripts
- [ ] Test isolation in sandbox

### Phase 2: Namespace Migration
- [ ] Create backup of current memories
- [ ] Migrate product-label-bot memories to new user_id
- [ ] Migrate arin-bot-v2 memories to new user_id
- [ ] Keep AgentSystem memories as-is (already using correct user_id)
- [ ] Validate no memory loss

### Phase 3: Metadata Enhancement
- [ ] Retroactively add metadata to existing memories
- [ ] Standardize metadata schema across all new additions
- [ ] Update all AgentSystem scripts to include metadata
- [ ] Document metadata conventions

### Phase 4: Validation & Rollout
- [ ] Test queries in all three namespaces
- [ ] Verify zero cross-contamination
- [ ] Update session protocols
- [ ] Train system on new patterns

## Implementation Scripts

### Script 1: Memory Migration Tool
Location: \D:\AgentSystem\migrate_memory_namespaces.py\
Purpose: Move memories to correct user_id namespaces

### Script 2: Metadata Enhancement Tool
Location: \D:\AgentSystem\enhance_metadata.py\
Purpose: Add metadata to existing memories

### Script 3: Isolation Test Suite
Location: \D:\AgentSystem\test_memory_isolation.py\
Purpose: Validate namespace separation

## Query Patterns Reference

### AgentSystem Queries
\\\python
# General system knowledge
client.search("protocol", filters={"user_id": "AgentSystem"})

# Recent decisions
client.search("decision", filters={
    "user_id": "AgentSystem",
    "metadata": {"task_type": "decision"}
})

# Current session context
client.search("context", filters={
    "user_id": "AgentSystem",
    "metadata": {"session_id": "2025_10_25_2003"}
})
\\\

### product-label-bot Queries
\\\python
# Barcode implementation details
client.search("barcode", filters={"user_id": "product-label-bot"})

# Milestone 2 context
client.search("milestone", filters={
    "user_id": "product-label-bot",
    "metadata": {"milestone": "2"}
})
\\\

### arin-bot-v2 Queries
\\\python
# Gemini integration context
client.search("gemini", filters={"user_id": "arin-bot-v2"})

# Milestone 3 tasks
client.search("tasks", filters={
    "user_id": "arin-bot-v2",
    "metadata": {"milestone": "3"}
})
\\\

## Rollback Plan

If issues arise:
1. Restore backup memories
2. Revert to single user_id='AgentSystem'
3. Document failure reasons
4. Redesign with learnings

**Backup Location:** \D:\AgentSystem\.meta\memory_backups\

## Success Metrics

- [ ] Zero cross-project memory leakage
- [ ] <200ms query latency with filters
- [ ] 100% memory migration success rate
- [ ] GraphMem entity extraction functional
- [ ] All three projects operationally isolated

**Status:** Ready for Phase 1 implementation
**Next Action:** Create migration scripts
**Last Updated:** 2025-10-25 20:07:17 IST


## Scripts Created (2025-10-25 20:07 IST)

### 1. backup_memories.py ✅
- Location: D:\AgentSystem\backup_memories.py
- Purpose: Create JSON backup of all AgentSystem memories
- Output: .meta/memory_backups/backup_TIMESTAMP.json
- Status: Ready to run

### 2. analyze_migration.py ✅
- Location: D:\AgentSystem\analyze_migration.py
- Purpose: Analyze current memory distribution by project
- Output: Console report with migration recommendations
- Status: Ready to run

### 3. test_isolation.py ✅
- Location: D:\AgentSystem\test_isolation.py
- Purpose: Validate namespace isolation and metadata filtering
- Output: Test results for 3 namespaces
- Status: Ready to run

## Execution Sequence

**Phase 1: Safety First**
1. Run backup_memories.py
2. Verify backup file created
3. Review backup summary

**Phase 2: Analysis**
1. Run analyze_migration.py
2. Review project distribution
3. Identify unclear memories for manual review

**Phase 3: Testing**
1. Run test_isolation.py
2. Verify zero cross-contamination
3. Confirm metadata filtering works

**Phase 4: Migration (Manual - not automated yet)**
- Review unclear memories
- Create migration script for actual data transfer
- Execute migration with validation
- Verify success metrics

**Status:** Scripts ready for execution
**Next Action:** Run backup_memories.py
