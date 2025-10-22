# ADR-003: Three-Tier Memory Structure

**Date:** 2025-10-22  
**Status:** Accepted  
**Deciders:** Krishna  
**Owner:** krishna_001

## Context

All learnings stored in single Agent_Primary/brain/learned-knowledge.md (63KB, 55 entries). No categorization, hard to query specific types of knowledge. Research shows AI agents need distinct memory layers for optimal performance.

## Decision

Migrate to three-tier structured memory:
- memory/system/core/knowledge.md - General knowledge (7 entries)
- memory/system/decisions/architectural.md - Design decisions (39 entries)
- memory/system/feedback/improvements.md - Mistakes & patterns (55 entries)

Original brain preserved as backup.

## Consequences

### Positive
- Clear separation of knowledge types
- Easier to query specific categories
- Follows AI agent best practices
- Supports feedback loop learning
- Better organization for growth

### Negative
- Migration complexity
- Tools must know about new structure
- More files to maintain

### Neutral
- Changes from monolithic to structured approach

## Alternatives Considered

### Option 1: Keep monolithic brain
- **Pros:** No migration needed
- **Cons:** Gets harder to manage as it grows
- **Why rejected:** Doesn't scale

### Option 2: Database storage
- **Pros:** Queryable, scalable
- **Cons:** Complex, requires DB, slower for resurrection
- **Why rejected:** Over-engineered

## Related Decisions
- ADR-001: Index-based architecture
- ADR-004: ADR system (this decision documented there)

## Notes
Migration completed with full backup. Total 55 learnings distributed across 3 categories.
