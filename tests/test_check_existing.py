from dotenv import load_dotenv
from mem0 import MemoryClient

load_dotenv()
client = MemoryClient()

# Search for index-related memories
queries = [
    "master index system map",
    "system index metadata",
    "file inventory documentation"
]

print("Searching memory for existing index systems...\n")

for query in queries:
    result = client.search(
        query,
        filters={"AND": [{"user_id": "AgentSystem"}]}
    )
    
    if result["results"]:
        print(f"Query: '{query}'")
        print(f"Found: {len(result['results'])} memories")
        for i, mem in enumerate(result["results"][:3]):
            print(f"  {i+1}. {mem['memory']}")
        print()

# Also check file system
print("\nChecking actual files for 'index' or 'master'...")
