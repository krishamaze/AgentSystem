-- ================================================
-- AGENT SYSTEM CLOUD ARCHITECTURE - PHASE 1
-- Supabase PostgreSQL Database Schema
-- Generated: October 20, 2025
-- ================================================

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "vector";

-- ================================================
-- TABLE 1: users
-- ================================================
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email TEXT UNIQUE,
    username TEXT,
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE users ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own data" ON users
    FOR SELECT USING (id = auth.uid() OR id = '00000000-0000-0000-0000-000000000000'::uuid);

-- ================================================
-- TABLE 2: agents
-- ================================================
CREATE TABLE IF NOT EXISTS agents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
    agent_type TEXT NOT NULL,
    agent_name TEXT NOT NULL,
    parent_agent_id UUID REFERENCES agents(id) ON DELETE SET NULL,
    capabilities JSONB DEFAULT '[]'::jsonb,
    status TEXT DEFAULT 'active',
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_agents_user_id ON agents(user_id);
CREATE INDEX idx_agents_parent ON agents(parent_agent_id);
CREATE INDEX idx_agents_type ON agents(agent_type);

ALTER TABLE agents ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own agents" ON agents
    FOR SELECT USING (user_id = auth.uid() OR user_id = '00000000-0000-0000-0000-000000000000'::uuid);

-- ================================================
-- TABLE 3: projects
-- ================================================
CREATE TABLE IF NOT EXISTS projects (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
    name TEXT NOT NULL,
    path TEXT,
    type TEXT,
    stack JSONB DEFAULT '{}'::jsonb,
    status TEXT DEFAULT 'active',
    git_info JSONB DEFAULT '{}'::jsonb,
    description TEXT,
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    last_activity TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_projects_user_id ON projects(user_id);
CREATE INDEX idx_projects_status ON projects(status);
CREATE INDEX idx_projects_last_activity ON projects(last_activity DESC);

ALTER TABLE projects ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own projects" ON projects
    FOR SELECT USING (user_id = auth.uid() OR user_id = '00000000-0000-0000-0000-000000000000'::uuid);

-- ================================================
-- TABLE 4: milestones
-- ================================================
CREATE TABLE IF NOT EXISTS milestones (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID REFERENCES projects(id) ON DELETE CASCADE NOT NULL,
    milestone_order INTEGER NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    status TEXT DEFAULT 'pending',
    depends_on UUID[],
    started_at TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE,
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_milestones_project ON milestones(project_id);
CREATE INDEX idx_milestones_status ON milestones(status);
CREATE INDEX idx_milestones_order ON milestones(project_id, milestone_order);

ALTER TABLE milestones ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view milestones through projects" ON milestones
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM projects 
            WHERE projects.id = milestones.project_id 
            AND (projects.user_id = auth.uid() OR projects.user_id = '00000000-0000-0000-0000-000000000000'::uuid)
        )
    );

-- ================================================
-- TABLE 5: tasks
-- ================================================
CREATE TABLE IF NOT EXISTS tasks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    milestone_id UUID REFERENCES milestones(id) ON DELETE CASCADE,
    project_id UUID REFERENCES projects(id) ON DELETE CASCADE NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    status TEXT DEFAULT 'todo',
    priority TEXT DEFAULT 'medium',
    assigned_agent_id UUID REFERENCES agents(id) ON DELETE SET NULL,
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_tasks_milestone ON tasks(milestone_id);
CREATE INDEX idx_tasks_project ON tasks(project_id);
CREATE INDEX idx_tasks_status ON tasks(status);
CREATE INDEX idx_tasks_priority ON tasks(priority);

ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view tasks through projects" ON tasks
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM projects 
            WHERE projects.id = tasks.project_id 
            AND (projects.user_id = auth.uid() OR projects.user_id = '00000000-0000-0000-0000-000000000000'::uuid)
        )
    );

-- ================================================
-- TABLE 6: learnings
-- ================================================
CREATE TABLE IF NOT EXISTS learnings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
    category TEXT NOT NULL,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    related_project_id UUID REFERENCES projects(id) ON DELETE SET NULL,
    related_agent_id UUID REFERENCES agents(id) ON DELETE SET NULL,
    tags TEXT[] DEFAULT ARRAY[]::TEXT[],
    embedding VECTOR(1536),
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_learnings_user ON learnings(user_id);
CREATE INDEX idx_learnings_category ON learnings(category);
CREATE INDEX idx_learnings_created ON learnings(created_at DESC);
CREATE INDEX idx_learnings_project ON learnings(related_project_id);
CREATE INDEX idx_learnings_tags ON learnings USING GIN(tags);

ALTER TABLE learnings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own learnings" ON learnings
    FOR SELECT USING (user_id = auth.uid() OR user_id = '00000000-0000-0000-0000-000000000000'::uuid);

-- ================================================
-- TABLE 7: evolution_log
-- ================================================
CREATE TABLE IF NOT EXISTS evolution_log (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    event_type TEXT NOT NULL,
    description TEXT NOT NULL,
    related_entities JSONB DEFAULT '{}'::jsonb,
    metadata JSONB DEFAULT '{}'::jsonb
);

CREATE INDEX idx_evolution_user ON evolution_log(user_id);
CREATE INDEX idx_evolution_timestamp ON evolution_log(timestamp DESC);
CREATE INDEX idx_evolution_type ON evolution_log(event_type);

ALTER TABLE evolution_log ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own evolution log" ON evolution_log
    FOR SELECT USING (user_id = auth.uid() OR user_id = '00000000-0000-0000-0000-000000000000'::uuid);

-- ================================================
-- TABLE 8: sessions
-- ================================================
CREATE TABLE IF NOT EXISTS sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
    agent_id UUID REFERENCES agents(id) ON DELETE SET NULL,
    started_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    ended_at TIMESTAMP WITH TIME ZONE,
    summary TEXT,
    context_snapshot JSONB DEFAULT '{}'::jsonb,
    metadata JSONB DEFAULT '{}'::jsonb
);

CREATE INDEX idx_sessions_user ON sessions(user_id);
CREATE INDEX idx_sessions_started ON sessions(started_at DESC);

ALTER TABLE sessions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own sessions" ON sessions
    FOR SELECT USING (user_id = auth.uid() OR user_id = '00000000-0000-0000-0000-000000000000'::uuid);

-- ================================================
-- TABLE 9: memory_sync_queue
-- ================================================
CREATE TABLE IF NOT EXISTS memory_sync_queue (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
    entity_type TEXT NOT NULL,
    entity_id UUID NOT NULL,
    operation TEXT NOT NULL,
    payload JSONB NOT NULL,
    mem0_synced BOOLEAN DEFAULT FALSE,
    retry_count INTEGER DEFAULT 0,
    error_message TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    synced_at TIMESTAMP WITH TIME ZONE
);

CREATE INDEX idx_sync_queue_user ON memory_sync_queue(user_id);
CREATE INDEX idx_sync_queue_synced ON memory_sync_queue(mem0_synced, created_at);
CREATE INDEX idx_sync_queue_entity ON memory_sync_queue(entity_type, entity_id);

ALTER TABLE memory_sync_queue ENABLE ROW LEVEL SECURITY;

CREATE POLICY "System can manage sync queue" ON memory_sync_queue
    FOR ALL USING (true);

-- ================================================
-- TRIGGERS FOR AUTO-SYNC
-- ================================================
CREATE OR REPLACE FUNCTION queue_mem0_sync()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO memory_sync_queue (user_id, entity_type, entity_id, operation, payload)
    VALUES (
        COALESCE(NEW.user_id, OLD.user_id),
        TG_ARGV[0],
        COALESCE(NEW.id, OLD.id),
        TG_OP,
        CASE 
            WHEN TG_OP = 'DELETE' THEN to_jsonb(OLD)
            ELSE to_jsonb(NEW)
        END
    );
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER sync_learnings_to_mem0
    AFTER INSERT OR UPDATE OR DELETE ON learnings
    FOR EACH ROW EXECUTE FUNCTION queue_mem0_sync('learning');

CREATE TRIGGER sync_projects_to_mem0
    AFTER INSERT OR UPDATE OR DELETE ON projects
    FOR EACH ROW EXECUTE FUNCTION queue_mem0_sync('project');

CREATE TRIGGER sync_milestones_to_mem0
    AFTER INSERT OR UPDATE OR DELETE ON milestones
    FOR EACH ROW EXECUTE FUNCTION queue_mem0_sync('milestone');

CREATE TRIGGER sync_tasks_to_mem0
    AFTER INSERT OR UPDATE OR DELETE ON tasks
    FOR EACH ROW EXECUTE FUNCTION queue_mem0_sync('task');

CREATE TRIGGER sync_agents_to_mem0
    AFTER INSERT OR UPDATE OR DELETE ON agents
    FOR EACH ROW EXECUTE FUNCTION queue_mem0_sync('agent');

-- ================================================
-- INITIAL DATA
-- ================================================
INSERT INTO users (id, email, username, metadata)
VALUES (
    '00000000-0000-0000-0000-000000000000'::uuid,
    'agent@local',
    'AgentSystemUser',
    '{"initial_setup": true}'::jsonb
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO agents (user_id, agent_type, agent_name, capabilities, status)
VALUES (
    '00000000-0000-0000-0000-000000000000'::uuid,
    'primary',
    'AgentPrimary',
    '["orchestration", "session_resurrection", "project_tracking", "protocol_enforcement"]'::jsonb,
    'active'
)
ON CONFLICT DO NOTHING;

