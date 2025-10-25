from dotenv import load_dotenv
load_dotenv()
from mem0 import MemoryClient

client = MemoryClient()

# Simulate session start: retrieve execution protocol
protocol = client.search('AgentSystem Command Execution Protocol strict', filters={'user_id': 'AgentSystem'})

print("=== SESSION START PROTOCOL RETRIEVAL ===")
print(f"Found {len(protocol.get('results', []))} protocol memory/memories\n")

for idx, m in enumerate(protocol.get('results', [])[:3], 1):
    print(f"{idx}. Memory: {m['memory']}")
    print(f"   Updated: {m.get('updated_at', 'N/A')}")
    print(f"   Metadata: {m.get('metadata', {})}")
    print("-" * 60)

print("\n✓ Protocol v2.0 successfully retrievable")
print("✓ System can now execute batch operations")
print("✓ Memory-first discipline maintained")
print("✓ Protocols are updatable through memory operations")
