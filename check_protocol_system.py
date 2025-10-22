from dotenv import load_dotenv
from mem0 import MemoryClient

load_dotenv()
client = MemoryClient()

# Check for existing protocol system
result = client.search(
    "AI powered protocol system framework universal",
    filters={"AND": [{"user_id": "AgentSystem"}]}
)

print(f"Existing protocol references: {len(result['results'])}")

if result['results']:
    print("\nMemory found:")
    for i, mem in enumerate(result['results'][:3]):
        print(f"  {i+1}. {mem['memory']}")
else:
    print("\nNo existing universal protocol system found")
    print("Decision: Create new comprehensive framework")
