from dotenv import load_dotenv
from mem0 import MemoryClient
import os
import json
import glob
from datetime import datetime

load_dotenv()
client = MemoryClient()
user_id = "AgentSystem"

print("\n=== Smart Sync: Storing to Mem0 Platform ===")

# 1. System Structure
print("\n1. Syncing system structure...")
system_root = "D:\\AgentSystem"
def scan_directory_tree(root_path, max_depth=3, current_depth=0):
    tree = []
    if current_depth >= max_depth:
        return tree
    try:
        for item in os.listdir(root_path):
            if item.startswith('.') and item != '.meta':
                continue
            item_path = os.path.join(root_path, item)
            if os.path.isdir(item_path):
                tree.append(f"{'  ' * current_depth}{item}/")
            elif item.endswith(('.ps1', '.py', '.json', '.md')):
                tree.append(f"{'  ' * current_depth}{item}")
    except PermissionError:
        pass
    return tree

tree = scan_directory_tree(system_root, max_depth=3)
system_structure = f"AgentSystem Structure (scanned {datetime.now().strftime('%Y-%m-%d %H:%M')}):\n" + '\n'.join(tree[:100])

# ACTUALLY ADD TO MEM0
result = client.add(system_structure, user_id=user_id, metadata={"type": "system_structure"})
print(f"  ✓ Structure synced (ID: {result.get('results', [{}])[0].get('id', 'N/A')[:8]}...)")

# 2. Tools
print("\n2. Syncing tools...")
tools_dir = f"{system_root}/tools"
tool_count = 0
for tool_file in glob.glob(f"{tools_dir}/*.ps1"):
    tool_name = os.path.basename(tool_file)
    with open(tool_file, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read(2000)
    
    tool_memory = f"PowerShell Tool: {tool_name}\n{content}"
    result = client.add(tool_memory, user_id=user_id, metadata={"type": "tool", "name": tool_name})
    tool_count += 1

print(f"  ✓ {tool_count} tools synced")

# 3. Projects
print("\n3. Syncing projects...")
registry_file = f"{system_root}/.meta/tenant-registry.json"
if os.path.exists(registry_file):
    with open(registry_file, 'r', encoding='utf-8-sig') as f:
        registry = json.load(f)
    
    for project in registry.get("project_tenants", []):
        project_info = f"""Project: {project['name']}
Owner: {project.get('owner', 'unknown')}
Status: {project.get('status', 'unknown')}
Path: {project.get('repo_path', 'unknown')}
Milestone: {project.get('current_milestone', 1)}"""
        
        result = client.add(project_info, user_id=user_id, metadata={"type": "project", "name": project['name']})
    
    print(f"  ✓ {len(registry.get('project_tenants', []))} projects synced")

# 4. ADRs
print("\n4. Syncing ADRs...")
adr_dir = f"{system_root}/memory/tenants/AgentSystem/decisions"
adr_count = 0
if os.path.exists(adr_dir):
    for adr_file in glob.glob(f"{adr_dir}/*.md"):
        adr_name = os.path.basename(adr_file)
        with open(adr_file, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
        
        adr_memory = f"Architecture Decision Record: {adr_name}\n{content}"
        result = client.add(adr_memory, user_id=user_id, metadata={"type": "adr", "name": adr_name})
        adr_count += 1

print(f"  ✓ {adr_count} ADRs synced")

print("\n" + "="*60)
print("SYNC TO MEM0 PLATFORM COMPLETE")
print("="*60)
print(f"\nMemories now stored in mem0.ai for user_id: {user_id}")
