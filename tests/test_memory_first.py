from dotenv import load_dotenv
from mem0 import MemoryClient

load_dotenv()
client = MemoryClient()

print("=== Checking Memory for Existing Systems ===\n")

# Search for index-related memories
queries = [
    "master index system documentation",
    "system-index.json metadata registry", 
    "file inventory tracking",
    "documentation map overview"
]

found_files = []

for query in queries:
    result = client.search(
        query,
        filters={"AND": [{"user_id": "AgentSystem"}]}
    )
    
    if result["results"]:
        print(f"Query: '{query}'")
        print(f"Found: {len(result['results'])} memories\n")
        
        for i, mem in enumerate(result["results"][:5]):
            print(f"  {i+1}. {mem['memory']}")
            
            # Extract file paths mentioned
            if ".json" in mem["memory"] or ".md" in mem["memory"]:
                found_files.append(mem["memory"])
        print()

# Summary
print("="*60)
print(f"\nSummary: Found {len(set(found_files))} file references in memory")

if found_files:
    print("\nFiles mentioned in memories:")
    for f in set(found_files)[:10]:
        print(f"  - {f[:80]}...")

print("\n✓ Memory search complete")
print("\nNext: Search for specific files mentioned above")
