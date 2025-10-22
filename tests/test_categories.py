from dotenv import load_dotenv
from mem0 import MemoryClient

load_dotenv()
client = MemoryClient()

# Get all memories
all_mem = client.get_all(
    filters={"AND": [{"user_id": "AgentSystem"}]},
    page_size=150
)

# Count by category with None handling
categories = {}
no_category = 0

for mem in all_mem["results"]:
    cats = mem.get("categories")
    if cats and isinstance(cats, list):
        for cat in cats:
            categories[cat] = categories.get(cat, 0) + 1
    else:
        no_category += 1

print("Memory distribution by category:\n")
for cat, count in sorted(categories.items(), key=lambda x: x[1], reverse=True):
    print(f"  {cat}: {count} memories")

if no_category > 0:
    print(f"\n  [No category yet]: {no_category} memories")
    
print(f"\nTotal categories: {len(categories)}")
print(f"Total memories: {len(all_mem['results'])}")
