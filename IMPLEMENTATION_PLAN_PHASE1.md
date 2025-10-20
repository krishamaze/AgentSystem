# AgentSystem Implementation Plan - Phase 1: Vector Embeddings
**Status:** RECOMMENDED FOR IMPLEMENTATION  
**Technology:** Supabase Vector (pgvector)  
**Estimated Duration:** 2-3 days  
**Complexity:** Medium

---

## PHASE 1 OVERVIEW

Implement semantic search and intelligent context retrieval using Supabase Vector (pgvector) to transform knowledge retrieval from keyword-based to semantic-based.

---

## ARCHITECTURE CHANGES REQUIRED

### 1. Database Schema Changes

**New Supabase Table: `agent_learnings_embeddings`**

```sql
CREATE TABLE agent_learnings_embeddings (
  id BIGSERIAL PRIMARY KEY,
  agent_name TEXT NOT NULL,
  learning_id TEXT NOT NULL,  -- Unique identifier from learned-knowledge.md
  timestamp TIMESTAMP NOT NULL,
  content TEXT NOT NULL,
  embedding vector(1536),  -- OpenAI embedding dimension
  metadata JSONB,  -- {source: "learned-knowledge.md", priority: "High", keywords: [...]}
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(agent_name, learning_id)
);

CREATE INDEX ON agent_learnings_embeddings USING ivfflat (embedding vector_cosine_ops);
```

**New Supabase Table: `agent_context_cache`**

```sql
CREATE TABLE agent_context_cache (
  id BIGSERIAL PRIMARY KEY,
  agent_name TEXT NOT NULL,
  context_type TEXT NOT NULL,  -- "task", "project", "learning"
  context_id TEXT NOT NULL,
  embedding vector(1536),
  metadata JSONB,
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(agent_name, context_type, context_id)
);
```

### 2. New PowerShell Modules

**File: `embedding-service.ps1`**
- Function: `Get-Embedding` - Call OpenAI API to generate embeddings
- Function: `Store-LearningEmbedding` - Save embedding to Supabase
- Function: `Search-SemanticLearnings` - Query similar learnings
- Function: `Sync-BrainToVectors` - Batch sync all learnings to database

**File: `semantic-retrieval.ps1`**
- Function: `Get-RelevantContext` - Retrieve semantically similar learnings
- Function: `Rank-BySemanticRelevance` - Score learnings by similarity
- Function: `Generate-ContextSummary` - Summarize relevant learnings

### 3. Modified Files

**lib-parser.ps1**
- Add: `Export-LearningsForEmbedding` function
- Modify: `Parse-BrainFiles` to include embedding metadata
- Add: Batch export capability for initial sync

**lib-parser.ps1 (new functions)**
```powershell
function Export-LearningsForEmbedding {
  # Extract learnings in format suitable for embedding
  # Output: Array of objects with {id, timestamp, content, metadata}
}

function Sync-AllAgentLearnings {
  # Iterate all agents, export learnings, generate embeddings, store in Supabase
}
```

---

## STEP-BY-STEP IMPLEMENTATION TASKS

### TASK 1: Supabase Setup (Day 1, 1-2 hours)

**1.1 Enable pgvector Extension**
- [ ] Log into Supabase project (opaxtxfxropmjrrqlewh)
- [ ] Navigate to SQL Editor
- [ ] Execute: `CREATE EXTENSION IF NOT EXISTS vector;`
- [ ] Verify extension installed

**1.2 Create Database Tables**
- [ ] Execute schema creation SQL (see Architecture section)
- [ ] Create indexes for vector similarity search
- [ ] Test table creation with sample insert

**1.3 Set Up API Keys**
- [ ] Verify OpenAI API key available (for embeddings)
- [ ] Store in environment: `$env:OPENAI_API_KEY`
- [ ] Test OpenAI API connectivity

### TASK 2: Embedding Service Implementation (Day 1-2, 4-6 hours)

**2.1 Create embedding-service.ps1**
- [ ] Implement `Get-Embedding` function
  - Input: Text string
  - Call: OpenAI Embeddings API (text-embedding-3-small model)
  - Output: 1536-dimensional vector
  - Error handling: Retry logic, rate limiting

**2.2 Implement Supabase Storage Functions**
- [ ] `Store-LearningEmbedding` function
  - Input: agent_name, learning_id, content, metadata
  - Generate embedding via `Get-Embedding`
  - Insert/upsert into `agent_learnings_embeddings` table
  - Handle duplicates gracefully

**2.3 Implement Semantic Search**
- [ ] `Search-SemanticLearnings` function
  - Input: query_text, agent_name, limit (default 5)
  - Generate embedding for query
  - Execute cosine similarity search in Supabase
  - Return top N results with similarity scores

### TASK 3: Brain Sync Implementation (Day 2, 3-4 hours)

**3.1 Create Batch Export Function**
- [ ] `Export-LearningsForEmbedding` in lib-parser.ps1
  - Parse all learnings from brain files
  - Extract: id, timestamp, content, keywords, priority
  - Output: JSON array suitable for batch processing

**3.2 Implement Initial Sync**
- [ ] `Sync-AllAgentLearnings` function
  - Iterate: Agent_Primary, Agent_CodeAssist, Agent_Agent_Architect
  - For each agent: export learnings, generate embeddings, store
  - Progress tracking and error reporting
  - Idempotent (safe to run multiple times)

**3.3 Create Incremental Sync**
- [ ] `Sync-NewLearnings` function
  - Detect new learnings since last sync
  - Generate embeddings only for new entries
  - Update `updated_at` timestamp

### TASK 4: Semantic Retrieval Integration (Day 2-3, 4-5 hours)

**4.1 Create semantic-retrieval.ps1**
- [ ] `Get-RelevantContext` function
  - Input: query, agent_name, context_type (optional)
  - Search semantically similar learnings
  - Return: ranked list with similarity scores

**4.2 Modify lib-parser.ps1**
- [ ] Update `Generate-Recommendations` function
  - Add semantic relevance scoring
  - Combine keyword-based + semantic scores
  - Improve task ranking with semantic context

**4.3 Enhance resurrect-me.ps1**
- [ ] Add semantic context retrieval
  - When resurrecting agent, retrieve semantically relevant learnings
  - Filter by project context if available
  - Reduce noise in brain dump

### TASK 5: Testing & Validation (Day 3, 3-4 hours)

**5.1 Unit Tests**
- [ ] Test `Get-Embedding` with sample texts
- [ ] Test `Store-LearningEmbedding` with test data
- [ ] Test `Search-SemanticLearnings` with known queries
- [ ] Verify vector dimensions and similarity scores

**5.2 Integration Tests**
- [ ] Test full sync pipeline: Parse → Embed → Store
- [ ] Test with Agent_Primary learnings (400+ entries)
- [ ] Verify all learnings successfully embedded
- [ ] Test incremental sync with new learning

**5.3 Functional Tests**
- [ ] Query: "database connection" → retrieve SQL/connection learnings
- [ ] Query: "authentication" → retrieve JWT/OAuth learnings
- [ ] Query: "Supabase" → retrieve project-specific learnings
- [ ] Verify ranking quality and relevance

**5.4 Performance Tests**
- [ ] Measure embedding generation time (should be <1s per learning)
- [ ] Measure search query time (should be <500ms)
- [ ] Test with 1000+ embeddings
- [ ] Verify index performance

### TASK 6: Documentation & Deployment (Day 3, 2-3 hours)

**6.1 Create User Documentation**
- [ ] Document new functions in lib-parser.ps1
- [ ] Create usage examples for semantic search
- [ ] Document configuration (API keys, Supabase connection)

**6.2 Update Brain Files**
- [ ] Add learning entries to Agent_Primary brain
- [ ] Document vector embedding system in learned-knowledge.md
- [ ] Update meta-prompt with new capabilities

**6.3 Deployment Checklist**
- [ ] All tests passing
- [ ] Documentation complete
- [ ] Backup existing brain files
- [ ] Run initial sync on all agents
- [ ] Verify system stability

---

## DATABASE SCHEMA & DATA MODEL

### agent_learnings_embeddings Table

| Column | Type | Purpose |
|--------|------|---------|
| id | BIGSERIAL | Primary key |
| agent_name | TEXT | Which agent owns this learning |
| learning_id | TEXT | Unique ID from markdown (timestamp-based) |
| timestamp | TIMESTAMP | When learning was recorded |
| content | TEXT | Full learning text |
| embedding | vector(1536) | OpenAI embedding vector |
| metadata | JSONB | {source, priority, keywords, tags} |
| created_at | TIMESTAMP | Record creation time |
| updated_at | TIMESTAMP | Last update time |

### Metadata Structure

```json
{
  "source": "learned-knowledge.md",
  "priority": "High",
  "keywords": ["database", "constraint", "error"],
  "tags": ["bug-fix", "supabase", "typescript"],
  "project": "arin-bot-v2",
  "related_learnings": ["learning-id-1", "learning-id-2"]
}
```

---

## CODE MODIFICATIONS NEEDED

### Files to Create
1. `embedding-service.ps1` (new)
2. `semantic-retrieval.ps1` (new)

### Files to Modify
1. `lib-parser.ps1` - Add export and sync functions
2. `resurrect-me.ps1` - Add semantic context retrieval
3. `Agent_Primary/update-brain.ps1` - Add embedding sync on brain update

### Files to Update (Documentation)
1. `Agent_Primary/brain/learned-knowledge.md` - Document new system
2. `Agent_Agent_Architect/brain/current-task.md` - Update with Phase 1 tasks

---

## INTEGRATION POINTS WITH EXISTING SYSTEM

### 1. Brain Update Pipeline
```
update-brain.ps1 (existing)
  ↓
  [New] Sync-NewLearnings
  ↓
  Generate embeddings
  ↓
  Store in Supabase
```

### 2. Task Recommendation Pipeline
```
Generate-Recommendations (existing)
  ↓
  [Enhanced] Rank-BySemanticRelevance
  ↓
  Combine keyword + semantic scores
  ↓
  Return ranked recommendations
```

### 3. Agent Resurrection Pipeline
```
resurrect-me.ps1 (existing)
  ↓
  [New] Get-RelevantContext
  ↓
  Retrieve semantically similar learnings
  ↓
  Filter by project context
  ↓
  Display focused brain state
```

---

## MIGRATION STRATEGY

### Phase 1a: Parallel Operation (Days 1-2)
- Implement new embedding system
- Run alongside existing keyword-based system
- No changes to existing functionality
- Gradual data population

### Phase 1b: Gradual Adoption (Day 2-3)
- Enable semantic search in recommendations
- Monitor quality and performance
- Gather feedback
- Adjust similarity thresholds

### Phase 1c: Full Integration (Day 3)
- Make semantic search primary
- Keep keyword-based as fallback
- Update documentation
- Archive old system

---

## TESTING APPROACH

### Unit Tests
- Test each function independently
- Mock Supabase responses
- Verify embedding generation
- Test error handling

### Integration Tests
- Test full pipeline end-to-end
- Use real Supabase connection
- Verify data consistency
- Test with actual brain files

### Performance Tests
- Measure latency for embedding generation
- Measure search query performance
- Test with 1000+ embeddings
- Verify index effectiveness

### Functional Tests
- Semantic search quality
- Ranking accuracy
- Context relevance
- Cross-agent knowledge retrieval

---

## RISKS & MITIGATION

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|-----------|
| OpenAI API rate limiting | Medium | Medium | Implement backoff, batch requests |
| Embedding quality issues | Low | Medium | Test with diverse queries, adjust model |
| Supabase connection failures | Low | High | Implement retry logic, fallback to keyword search |
| Performance degradation | Low | Medium | Monitor query times, optimize indexes |
| Data consistency issues | Low | High | Implement validation, checksums |

---

## SUCCESS CRITERIA

- ✅ All 400+ learnings from Agent_Primary successfully embedded
- ✅ Semantic search returns relevant results (>80% relevance)
- ✅ Search queries complete in <500ms
- ✅ Embedding generation costs <$1/month
- ✅ System remains stable with no data loss
- ✅ Documentation complete and tested
- ✅ All tests passing

---

## ESTIMATED EFFORT & TIMELINE

| Task | Duration | Days |
|------|----------|------|
| Supabase Setup | 1-2 hours | 1 |
| Embedding Service | 4-6 hours | 1-2 |
| Brain Sync | 3-4 hours | 2 |
| Semantic Retrieval | 4-5 hours | 2-3 |
| Testing & Validation | 3-4 hours | 3 |
| Documentation | 2-3 hours | 3 |
| **TOTAL** | **17-24 hours** | **2-3 days** |

---

## NEXT PHASE: GRAPH MEMORY (Neo4j)

After Phase 1 stabilizes, Phase 2 will add:
- Relationship tracking between learnings
- Knowledge graph for projects
- Task dependency management
- Root cause analysis capabilities

---

*Implementation Plan Generated: 2025-10-20*

