from dotenv import load_dotenv
from mem0 import MemoryClient

load_dotenv()
client = MemoryClient()

# Get all memories
result = client.get_all(
    filters={"AND": [{"user_id": "AgentSystem"}]}, 
    page_size=100
)

print(f"Total memories: {len(result['results'])}")
print(f"\nFirst 5 memories:")
for i, mem in enumerate(result["results"][:5]):
    print(f"{i+1}. {mem['memory']}")
