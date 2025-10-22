from dotenv import load_dotenv
from mem0 import MemoryClient

load_dotenv()
client = MemoryClient()

result = client.get_all(filters={"AND": [{"user_id": "AgentSystem"}]}, page_size=50)
print(f"\nTotal memories for AgentSystem: {len(result['results'])}")

if result['results']:
    print("\nSample memories:")
    for i, mem in enumerate(result['results'][:15]):
        mem_text = mem["memory"][:100]
        print(f"  {i+1}. {mem_text}...")
        
    # Count by type
    types = {}
    for mem in result['results']:
        if 'categories' in mem:
            for cat in mem['categories']:
                types[cat] = types.get(cat, 0) + 1
    
    print(f"\nMemories by category: {types}")
else:
    print("\n⚠ No memories found yet - still processing")

print("\n✓ Verification complete")
