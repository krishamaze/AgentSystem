from dotenv import load_dotenv
from mem0 import MemoryClient

load_dotenv()
client = MemoryClient()

# Search for tool-related memories
result = client.search(
    "PowerShell tools available",
    filters={"AND": [{"user_id": "AgentSystem"}]}
)

print(f"Found {len(result['results'])} memories about tools\n")
print("Top 3 tool memories:")
for i, mem in enumerate(result["results"][:3]):
    print(f"{i+1}. {mem['memory']}")
