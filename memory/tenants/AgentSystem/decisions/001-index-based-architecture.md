# ADR-001: Index-Based Multi-Tenant Architecture

**Date:** 2025-10-22  
**Status:** Accepted  
**Deciders:** Krishna  
**Owner:** krishna_001

## Context

Original init prompt was 5KB and growing. With multiple projects, it would scale linearly (10 projects = 50KB), eventually hitting token limits. System needed to handle unlimited projects without prompt bloat. Each project uses separate Supabase accounts and repos (pure tenant isolation).

## Decision

Implement index-based lazy loading with hierarchical memory structure:
- Root index in .meta/system-index.json (~500 bytes)
- Tenant registry in .meta/tenant-registry.json
- Project contexts loaded on-demand via tools/load-project.ps1
- Memory namespaced per project (no cross-referencing)

## Consequences

### Positive
- Init prompt reduced to 1.13KB (77% reduction)
- Scales to unlimited projects
- Pure tenant isolation maintained
- Faster resurrection (less context loading)
- Clear separation of concerns

### Negative
- Requires explicit project loading (not automatic)
- New thread must run commands to load full context
- Adds complexity to resurrection flow

### Neutral
- Changes workflow from "dump everything" to "load on demand"
- Agent must actively request context via tools

## Alternatives Considered

### Option 1: Compressed init dump
- **Pros:** Simple, no workflow change
- **Cons:** Still scales linearly, temporary solution
- **Why rejected:** Doesn't solve scaling problem

### Option 2: Vector similarity search
- **Pros:** Smart context retrieval
- **Cons:** Requires embeddings infrastructure, slower, less deterministic
- **Why rejected:** Over-engineered for current needs

## Related Decisions
- ADR-002: User management system
- ADR-003: Memory structure migration

## Notes
Implementation completed in session 2025-10-22. Tested with 3 projects (AgentSystem, product-label-bot, arin-bot-v2).
