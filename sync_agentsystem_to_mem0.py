from dotenv import load_dotenv
from mem0 import MemoryClient
import os
import json
import glob
from datetime import datetime

load_dotenv()
client = MemoryClient()
user_id = "AgentSystem"

print("\n=== AgentSystem → Mem0 Platform Sync ===")
print(f"User ID: {user_id}")
print(f"Timestamp: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")

event_ids = []

# 1. Sync Projects
print("1. Syncing projects...")
registry_file = "D:\\AgentSystem\\.meta\\tenant-registry.json"
if os.path.exists(registry_file):
    with open(registry_file, 'r', encoding='utf-8-sig') as f:
        registry = json.load(f)
    
    for project in registry.get("project_tenants", []):
        # Format as conversation
        messages = [
            {
                "role": "user",
                "content": f"I have a project called {project['name']}. It's owned by {project.get('owner', 'unknown')} and located at {project.get('repo_path', 'unknown')}. Current status is {project.get('status', 'active')} and we're on milestone {project.get('current_milestone', 1)}."
            },
            {
                "role": "assistant",
                "content": f"I'll remember your {project['name']} project details."
            }
        ]
        
        result = client.add(messages, user_id=user_id, metadata={"type": "project", "name": project['name']})
        event_id = result['results'][0].get('event_id')
        event_ids.append(event_id)
        print(f"  ✓ {project['name']} (event: {event_id[:8]}...)")

# 2. Sync Tools
print("\n2. Syncing PowerShell tools...")
tools_dir = "D:\\AgentSystem\\tools"
tool_files = glob.glob(f"{tools_dir}/*.ps1")[:10]  # Limit to 10 for testing

for tool_file in tool_files:
    tool_name = os.path.basename(tool_file)
    
    with open(tool_file, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read(500)  # First 500 chars
    
    messages = [
        {
            "role": "user",
            "content": f"I have a PowerShell tool called {tool_name}. Here's what it does: {content}"
        },
        {
            "role": "assistant",
            "content": f"Got it, I'll remember the {tool_name} tool."
        }
    ]
    
    result = client.add(messages, user_id=user_id, metadata={"type": "tool", "name": tool_name})
    event_id = result['results'][0].get('event_id')
    event_ids.append(event_id)
    print(f"  ✓ {tool_name} (event: {event_id[:8]}...)")

# 3. Sync Current Task
print("\n3. Syncing current task...")
task_file = "D:\\AgentSystem\\memory\\tenants\\AgentSystem\\tasks\\mem0-investigation.md"
if os.path.exists(task_file):
    with open(task_file, 'r', encoding='utf-8') as f:
        task_content = f.read(1000)
    
    messages = [
        {
            "role": "user",
            "content": f"I just completed research on Mem0 Platform integration. We discovered it uses async processing, requires conversation format, and extracts atomic facts automatically. Task status: SUCCESS"
        },
        {
            "role": "assistant",
            "content": "Great work on the Mem0 investigation! I'll remember those key findings."
        }
    ]
    
    result = client.add(messages, user_id=user_id, metadata={"type": "task", "status": "complete"})
    event_id = result['results'][0].get('event_id')
    event_ids.append(event_id)
    print(f"  ✓ Mem0 investigation task (event: {event_id[:8]}...)")

print("\n" + "="*60)
print("SYNC QUEUED SUCCESSFULLY")
print("="*60)
print(f"\nTotal events queued: {len(event_ids)}")
print(f"Processing time: ~30 seconds")
print(f"\nEvent IDs saved for tracking:")
for i, eid in enumerate(event_ids[:5]):
    print(f"  {i+1}. {eid}")

# Save event IDs for later verification
with open(".meta/sync-events.json", "w") as f:
    json.dump({
        "timestamp": datetime.now().isoformat(),
        "user_id": user_id,
        "event_ids": event_ids,
        "total": len(event_ids)
    }, f, indent=2)

print(f"\n✓ Event tracking saved to .meta/sync-events.json")
