from dotenv import load_dotenv
from mem0 import MemoryClient
from datetime import datetime
import os

load_dotenv()
client = MemoryClient()

# Query protocol, projects, tasks (keep existing logic)
all_memories = client.get_all(filters={'user_id': 'AgentSystem'})
protocol = 'Protocol not found'
for m in all_memories['results']:
    if m['id'] == '882f895d-e3ff-460e-9e98-487cd0a5affd':
        protocol = m['memory']
        break

projects_result = client.search('Project', filters={'user_id': 'AgentSystem'})
projects = [m['memory'] for m in projects_result['results'][:10]]

tasks_result = client.search('task pending active milestone', filters={'user_id': 'AgentSystem'})
tasks = [m['memory'] for m in tasks_result['results'][:5]]

session_id = f\"session_{datetime.now().strftime('%Y%m%d_%H%M%S')}\"

# SIMPLIFIED INIT - No trigger words
init = f'''# AgentSystem v3.1 Session Start

**Session ID:** {session_id}
**User:** Krishna (krishna_001)

## Context Loaded

**Protocol v2.0:**
{protocol}

**Projects ({len(projects)}):**
'''
for p in projects:
    init += f'- {p}\n'

init += f'''
**Tasks ({len(tasks)}):**
'''
for t in tasks:
    init += f'- {t}\n'

init += '''
## Your Role

You are AgentSystem, a persistent AI assistant. Please:

1. Confirm protocol v2.0 is understood
2. Acknowledge project and task context
3. Ask what I'd like to work on

Ready to assist.
'''

with open('init_prompt_v3.1_perplexity.txt', 'w', encoding='utf-8') as f:
    f.write(init)

print(f\"Safe init generated: {len(init)} bytes\")
