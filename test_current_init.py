from dotenv import load_dotenv
from mem0 import MemoryClient

load_dotenv()
client = MemoryClient()

print("Querying memory for init system knowledge...\n")

# Check what we know about init
result = client.search(
    "init initialization system how AgentSystem starts",
    filters={"AND": [{"user_id": "AgentSystem"}]}
)

print(f"Found {len(result['results'])} memories about init:\n")
for i, mem in enumerate(result['results'][:5]):
    print(f"{i+1}. {mem['memory']}")

print("\n--- Current initCMD.txt Analysis ---\n")
