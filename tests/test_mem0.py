from dotenv import load_dotenv
from mem0 import MemoryClient
import os

load_dotenv()
client = MemoryClient()

print("\n[2A] Search for tools:")
tools_result = client.search("PowerShell tools available", user_id="AgentSystem")
print(f"  Found {len(tools_result['results'])} results")
if tools_result['results']:
    print(f"  Sample: {tools_result['results'][0]['memory'][:100]}...")

print("\n[2B] Search for our recent task:")
task_result = client.search("fix UTF-8 BOM error context tools", user_id="AgentSystem")
print(f"  Found {len(task_result['results'])} results")
if task_result['results']:
    print(f"  Sample: {task_result['results'][0]['memory'][:100]}...")

print("\n[2C] Search for projects:")
project_result = client.search("active projects AgentSystem product-label-bot", user_id="AgentSystem")
print(f"  Found {len(project_result['results'])} results")
if project_result['results']:
    print(f"  Sample: {project_result['results'][0]['memory'][:100]}...")

print("\n[2D] Get all memories (last 10):")
all_memories = client.get_all(user_id="AgentSystem")
print(f"  Total memories: {len(all_memories['results'])}")
for i, mem in enumerate(all_memories['results'][:10]):
    print(f"  {i+1}. {mem['memory'][:80]}...")

print("\n✓ Mem0 API queries completed")
