# GraphMem Deep Dive - Mem0 Graph Memory Research
**Created:** 2025-10-25 20:11:08 IST
**Status:** Research in progress

## What is GraphMem?

GraphMem is mem0's graph-based memory enhancement that:
- Automatically extracts entities from memory content
- Creates relationships between related memories
- Enables context-aware retrieval
- Preserves semantic connections across sessions

**Current Status:** Enabled for AgentSystem project (confirmed via get_project())

---

## Research Questions

### Q1: How does entity extraction work?
**Status:** Researching

**Hypothesis:**
- NLP/LLM-based entity recognition
- Automatic extraction of key concepts, names, dates
- Possible entity types: Person, Project, Technology, Concept, Action

**Testing Plan:**
1. Add memory with clear entities (e.g., "product-label-bot uses Deno and Supabase")
2. Query for related memories
3. Analyze if relationships are created
4. Document entity types discovered

**Notes:**
*To be populated after testing*

---

### Q2: When are relationships created?
**Status:** Researching

**Possible Triggers:**
- Shared entities between memories
- Temporal proximity (same session)
- Semantic similarity
- Explicit references (e.g., "related to X")

**Testing Plan:**
1. Create memories with shared entities
2. Create memories without shared entities
3. Compare relationship formation
4. Document trigger conditions

**Notes:**
*To be populated after testing*

---

### Q3: How are relationships queried?
**Status:** Researching

**API Methods to Explore:**
- Does \search()\ use graph automatically?
- Is there a separate graph query method?
- How to traverse relationships?
- Can we query by relationship type?

**Testing Plan:**
1. Review API docs for graph methods
2. Test search with related entities
3. Compare results with/without GraphMem
4. Document query patterns

**Notes:**
*To be populated after research*

---

### Q4: Performance implications?
**Status:** Researching

**Metrics to measure:**
- Query latency with GraphMem on/off
- Storage overhead per memory
- Relationship computation time
- Retrieval accuracy improvement

**Testing Plan:**
1. Benchmark queries (100 memories)
2. Compare with GraphMem disabled
3. Measure latency distributions
4. Document performance characteristics

**Notes:**
*To be populated after benchmarking*

---

### Q5: Best practices for graph-optimized content?
**Status:** Researching

**Content Patterns to Test:**
- Explicit entity naming (e.g., "Project: X, Task: Y")
- Relationship indicators (e.g., "related to", "depends on")
- Temporal markers (e.g., "after milestone 2")
- Category tags (e.g., "#decision", "#learning")

**Testing Plan:**
1. Create memories with different patterns
2. Observe relationship formation
3. Test retrieval quality
4. Document effective patterns

**Notes:**
*To be populated after experimentation*

---

## Experimental Plan

### Experiment 1: Entity Extraction Test
**Objective:** Understand what entities GraphMem extracts

**Procedure:**
\\\python
# Add memory with clear entities
client.add(
    messages=[{
        "role": "user",
        "content": "product-label-bot is a Telegram bot built with Deno, deployed on Supabase, using @undecaf/zbar-wasm for barcode detection. Milestone 2 implemented barcode-first workflow."
    }],
    user_id="AgentSystem",
    metadata={"experiment": "entity_extraction", "test_id": "exp1"}
)

# Wait for processing (if async)
# Query related memories
results = client.search("barcode", filters={"user_id": "AgentSystem"})

# Analyze if relationships formed
\\\

**Expected Outcomes:**
- Entities: product-label-bot, Telegram, Deno, Supabase, zbar-wasm, barcode, Milestone 2
- Potential relationships: product-label-bot → Deno, product-label-bot → barcode detection

**Actual Results:**
*To be documented after running experiment*

---

### Experiment 2: Relationship Formation Test
**Objective:** Test when relationships are created

**Procedure:**
\\\python
# Add related memories
client.add(
    messages=[{"role": "user", "content": "product-label-bot Milestone 1 completed on 2025-10-19"}],
    user_id="AgentSystem",
    metadata={"experiment": "relationships", "test_id": "exp2a"}
)

client.add(
    messages=[{"role": "user", "content": "product-label-bot Milestone 2 started after Milestone 1"}],
    user_id="AgentSystem",
    metadata={"experiment": "relationships", "test_id": "exp2b"}
)

# Query for Milestone 1
results = client.search("Milestone 1", filters={"user_id": "AgentSystem"})

# Check if Milestone 2 memory appears as related
\\\

**Expected Outcomes:**
- Relationship: Milestone 1 → Milestone 2 (temporal/sequential)
- Graph connection: product-label-bot → milestones

**Actual Results:**
*To be documented after running experiment*

---

## Web Research Checklist

- [ ] Search mem0 documentation for GraphMem API
- [ ] Find GraphMem usage examples
- [ ] Research graph database patterns (Neo4j, etc.)
- [ ] Study knowledge graph best practices
- [ ] Find performance benchmarks
- [ ] Look for community examples

---

## Findings Summary
*To be populated as research progresses*

---

## Recommendations
*To be created after research complete*

**Last Updated:** 2025-10-25 20:11:08 IST

## Experiment Results Snapshot - 2025-10-25 20:19:55 IST
- See GRAPHMEM_EXPERIMENTS.json for latest outputs.

