# ADR-002: User Management and Project Ownership

**Date:** 2025-10-22  
**Status:** Accepted  
**Deciders:** Krishna  
**Owner:** krishna_001

## Context

System tracks multiple projects but had no concept of users or ownership. Needed to future-proof for multi-user scenarios while supporting current single-user case. User preferences (timezone, interaction style) were scattered.

## Decision

Implement centralized user registry in .meta/users.json:
- Primary user (krishna_001) registered
- User preferences consolidated
- Project ownership tracked
- Designed for easy expansion to multi-user

## Consequences

### Positive
- Single source of truth for user data
- Easy to add collaborators later
- Preferences accessible system-wide
- Clear project ownership

### Negative
- Adds overhead for single-user case
- Another file to maintain

### Neutral
- Changes from implicit "only Krishna" to explicit user registry

## Alternatives Considered

### Option 1: Per-project user config
- **Pros:** Simpler for single user
- **Cons:** Duplicate preferences, hard to add collaborators
- **Why rejected:** Not future-proof

### Option 2: No user management
- **Pros:** Simplest
- **Cons:** Can't scale to teams, no preference tracking
- **Why rejected:** Short-sighted

## Related Decisions
- ADR-001: Index-based architecture
- ADR-003: Memory structure migration

## Notes
Krishna (krishna_001) owns all 3 current projects: AgentSystem, product-label-bot, arin-bot-v2.
