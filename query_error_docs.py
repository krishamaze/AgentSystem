from dotenv import load_dotenv
from mem0 import MemoryClient

load_dotenv()
client = MemoryClient()

print("=== Protocol Step 1: Query Memory ===\n")
print("Task: Document common error patterns\n")

queries = [
    "error documentation tracking system",
    "common errors pattern library",
    "knowledge.md learning capture",
    "error logging mistakes documented"
]

all_findings = []

for query in queries:
    result = client.search(
        query,
        filters={"AND": [{"user_id": "AgentSystem"}]}
    )
    
    if result["results"]:
        print(f"Query: '{query}'")
        print(f"Found: {len(result['results'])} memories\n")
        
        for i, mem in enumerate(result["results"][:3]):
            print(f"  {i+1}. {mem['memory']}")
            all_findings.append(mem['memory'])
        print()

print("="*60)
print(f"\nTotal findings: {len(all_findings)}")

if all_findings:
    print("\nMemory suggests checking:")
    print("  - memory/system/core/knowledge.md (error learnings)")
    print("  - Existing error documentation")
    
print("\nNext: Check files memory mentioned")
