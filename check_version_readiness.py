from dotenv import load_dotenv
from mem0 import MemoryClient

load_dotenv()
client = MemoryClient()

print("=== Version Readiness Check ===\n")

# Check for version plans and requirements
queries = [
    "v4.0 v3.1 next version requirements",
    "ADR architecture decisions autonomous",
    "init prompt thread prompt simplified"
]

for query in queries:
    result = client.search(query, filters={"AND": [{"user_id": "AgentSystem"}]})
    if result["results"]:
        print(f"Query: '{query}'")
        print(f"Found: {len(result['results'])} memories\n")
        for i, mem in enumerate(result["results"][:3]):
            print(f"  {i+1}. {mem['memory']}")
        print()
