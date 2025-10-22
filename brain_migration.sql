-- Brain Data Migration: Agent_Primary to Supabase

-- Generated: 2025-10-21 00:02:47



INSERT INTO learnings (user_id, category, title, content, tags, metadata)
VALUES (
    '00000000-0000-0000-0000-000000000000'::uuid,
    'error_fix',
    '2025-10-19 18:46 - Error Handling',
    '**PRIMARY RULE: Learn from errors**
**PowerShell Nested Here-String Error:**
- Problem: Backtick escaping ($) fails in nested here-strings @"..."@
- Solution: Use Set-Content with single-quoted here-string @''...''@
- Variables expand normally without escaping in single-quoted blocks
**Application:** Always prefer Set-Content + @''...''@ for multi-line script generation containing variables.',
    ARRAY['agent_primary', 'migrated']::TEXT[],
    '{"source": "local_brain", "migrated_at": "2025-10-21"}'::jsonb
);

INSERT INTO learnings (user_id, category, title, content, tags, metadata)
VALUES (
    '00000000-0000-0000-0000-000000000000'::uuid,
    'best_practice',
    '2025-10-19 18:53 - System Milestone',
    '**Multi-Agent System Operational**
- Spawner script: D:\AgentSystem\spawn-agent.ps1
- Active agents: Agent_Primary, Agent_CodeAssist
- Each agent has independent brain (meta-prompt, learned-knowledge, evolution-log)
- Spawn syntax: .\spawn-agent.ps1 -AgentName "Name" -Purpose "Description"',
    ARRAY['agent_primary', 'migrated']::TEXT[],
    '{"source": "local_brain", "migrated_at": "2025-10-21"}'::jsonb
);

INSERT INTO learnings (user_id, category, title, content, tags, metadata)
VALUES (
    '00000000-0000-0000-0000-000000000000'::uuid,
    'error_fix',
    '2025-10-19 19:08 - Project Context Management',
    '**Project-Specific Memory System**
- Location: D:\AgentSystem\Projects\{project-name}\
- context.md tracks: path, stack, branch, active work, last update
- Separates project knowledge from agent core brain
- First project registered: arin-bot-v2 (Supabase/Deno/TypeScript)
**Artifact Cleanup Learning:**
- PowerShell command errors can create files with names like ".Count; $i++) {"
- Always clean workspace before deep project work
- Corrupted files detected via unusual characters in filenames',
    ARRAY['agent_primary', 'migrated']::TEXT[],
    '{"source": "local_brain", "migrated_at": "2025-10-21"}'::jsonb
);

INSERT INTO learnings (user_id, category, title, content, tags, metadata)
VALUES (
    '00000000-0000-0000-0000-000000000000'::uuid,
    'best_practice',
    '2025-10-19 19:12 - Thread Continuity System',
    '**PRIMARY RULE: Advise thread transitions**
- Guide created: D:\AgentSystem\reinitialize-agent.md
- User must read brain files in new thread to restore context
- Copy-paste template provides seamless continuity
- All knowledge persists: meta-prompt + learned-knowledge + evolution-log + project context
**User Action Required:**
When thread becomes long or new session needed, user should:
1. Read D:\AgentSystem\reinitialize-agent.md
2. Copy the template message
3. Start new thread with that messag',
    ARRAY['agent_primary', 'migrated']::TEXT[],
    '{"source": "local_brain", "migrated_at": "2025-10-21"}'::jsonb
);

INSERT INTO learnings (user_id, category, title, content, tags, metadata)
VALUES (
    '00000000-0000-0000-0000-000000000000'::uuid,
    'error_fix',
    '2025-10-19 19:17 - Cross-Session Evolution',
    '**Self-Evaluation Protocol:**
- Each new session begins with brain file analysis
- Agent evaluates own previous decisions and learning quality
- Can refactor brain structure, improve summaries, fix inefficiencies
- Learns from past session mistakes and successes
- Continuous improvement loop: Session N learns from Session N-1
**Next Session Objectives:**
- Resume arin-bot-v2 project work (branch: feature/mlops-phase1-config-extraction)
- User will specify bug/feature to work on
- Self-evaluate: ',
    ARRAY['agent_primary', 'migrated']::TEXT[],
    '{"source": "local_brain", "migrated_at": "2025-10-21"}'::jsonb
);
