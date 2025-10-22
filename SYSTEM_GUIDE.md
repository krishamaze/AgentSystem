# AGENT SYSTEM - OPERATIONAL GUIDE

## System Overview
Multi-agent architecture with persistent memory and WebSocket communication.

## Architecture Components

### 1. Agent Brains (Knowledge Base)
- Agent_Primary: 50.8 KB - Main operational agent
- Agent_Agent_Architect: 11.5 KB - System architecture specialist
- Agent_CodeAssist: Minimal - Code assistance agent

### 2. Memory Systems
- **Supabase**: PostgreSQL database for structured data
  - Project: fihvhtoqviivmasjaqxc
  - Tables: learnings, agents, projects
  
- **Mem0**: AI-powered memory service
  - User: agent_primary
  - API: v2 (requires filters for queries)

### 3. Communication Layer
- **WebSocket Bridge**: Port 8080
  - Server: Node.js (server.js)
  - Handles real-time agent communication

## Quick Start Commands

### System Startup
```
.\start-system.ps1
```

### System Health Check
```
python system_status.py
```

### Memory Operations
```
python add_memory.py           # Add new memory
python list_memories.py        # View all memories
python sync_all_learnings.py   # Sync to Supabase
```

### WebSocket Testing
```
python test_websocket.py
```

## File Locations

### Configuration
- `.env` - Environment variables (API keys, URLs)
- `package.json` - Node.js dependencies
- `supabase_project.json` - Supabase project info

### Scripts
- `system_status.py` - System diagnostics
- `add_memory.py` - Add memories to mem0
- `list_memories.py` - List all memories
- `sync_all_learnings.py` - Sync brain to Supabase
- `test_websocket.py` - Test WebSocket bridge
- `server.js` - WebSocket server

### Brain Data
- `Agent_Primary/brain/learned-knowledge.md`
- `Agent_Primary/brain/evolution-log.md`
- `Agent_Agent_Architect/brain/`

### Backups
- `Backups/Agent_Primary/` - Timestamped brain backups
- `Backups/Agent_Agent_Architect/` - Architecture agent backups

## Troubleshooting

### WebSocket Server Not Running
```
node server.js
```

### Python Script Errors
- Check .env file exists and has all keys
- Verify packages: `pip list | findstr "supabase mem0 dotenv"`

### Memory Sync Issues
- Run `python system_status.py` to verify connections
- Check Supabase dashboard for table structure

## Next Steps / Recommendations

1. **Automate Backups**: Schedule regular brain backups
2. **Add Memory Triggers**: Auto-sync learnings to mem0 after significant events
3. **WebSocket Message Handlers**: Define action types in server.js
4. **Monitoring**: Set up health check endpoints
5. **Agent Communication**: Implement inter-agent messaging protocols

## Support Files Created
- `start-system.ps1` - Master startup script
- `add_memory.py` - Memory creation utility
- `list_memories.py` - Memory viewer
- `SYSTEM_GUIDE.md` - This file
