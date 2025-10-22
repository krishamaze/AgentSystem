from dotenv import load_dotenv
from mem0 import MemoryClient
import os

load_dotenv()
client = MemoryClient()

print("\n[2A] Get all memories for AgentSystem:")
# v2 API requires filters
all_memories = client.get_all(user_id="AgentSystem")
print(f"  Total memories: {len(all_memories['results'])}")

print("\n[2B] Sample of stored memories:")
for i, mem in enumerate(all_memories['results'][:5]):
    print(f"  {i+1}. {mem['memory'][:120]}...")

print("\n[2C] Search with proper filters:")
# Search with AND filter
search_result = client.search(
    "PowerShell tools",
    filters={"AND": [{"user_id": "AgentSystem"}]}
)
print(f"  Found {len(search_result['results'])} tool-related memories")

print("\n[2D] Search for projects:")
project_search = client.search(
    "active projects",
    filters={"AND": [{"user_id": "AgentSystem"}]}
)
print(f"  Found {len(project_search['results'])} project memories")

print("\n[2E] Memory categories:")
categories = {}
for mem in all_memories['results']:
    for cat in mem.get('categories', []):
        categories[cat] = categories.get(cat, 0) + 1
print(f"  Categories found: {list(categories.keys())[:10]}")

print("\n✓ Mem0 API test completed successfully")
