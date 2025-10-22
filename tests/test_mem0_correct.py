from dotenv import load_dotenv
from mem0 import MemoryClient
import os

load_dotenv()
client = MemoryClient()

print("\n[2A] Get all memories with proper filters:")
# v2 API requires filters parameter
filters = {"AND": [{"user_id": "AgentSystem"}]}
all_memories = client.get_all(filters=filters, page=1, page_size=100)
print(f"  Total memories: {len(all_memories['results'])}")

print("\n[2B] Sample of stored memories (first 5):")
for i, mem in enumerate(all_memories['results'][:5]):
    print(f"  {i+1}. {mem['memory'][:120]}...")
    if 'categories' in mem:
        print(f"     Categories: {mem['categories']}")

print("\n[2C] Search with proper filters:")
search_result = client.search(
    "PowerShell tools",
    filters={"AND": [{"user_id": "AgentSystem"}]}
)
print(f"  Found {len(search_result['results'])} tool-related memories")
if search_result['results']:
    print(f"  Sample: {search_result['results'][0]['memory'][:100]}...")

print("\n[2D] Search for projects:")
project_search = client.search(
    "active projects product-label-bot arin-bot",
    filters={"AND": [{"user_id": "AgentSystem"}]}
)
print(f"  Found {len(project_search['results'])} project memories")

print("\n[2E] Search for recent task:")
task_search = client.search(
    "UTF-8 BOM fix context tools",
    filters={"AND": [{"user_id": "AgentSystem"}]}
)
print(f"  Found {len(task_search['results'])} task-related memories")

print("\n[2F] Memory statistics:")
if all_memories['results']:
    categories = {}
    for mem in all_memories['results']:
        for cat in mem.get('categories', []):
            categories[cat] = categories.get(cat, 0) + 1
    print(f"  Total categories: {len(categories)}")
    print(f"  Top categories: {list(categories.items())[:5]}")

print("\n✓ Mem0 API test completed successfully")
