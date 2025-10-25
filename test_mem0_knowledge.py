from dotenv import load_dotenv
from mem0 import MemoryClient

load_dotenv()
client = MemoryClient()

print("Test 1: What does mem0 know about initCMD.txt?\n")
result = client.search("initCMD.txt", filters={"AND": [{"user_id": "AgentSystem"}]})
print(f"Found: {len(result['results'])} memories")
for mem in result['results'][:3]:
    print(f"  • {mem['memory']}")

print("\n---")

print("\nTest 2: What does mem0 know about init system?\n")
result = client.search("init system initialization", filters={"AND": [{"user_id": "AgentSystem"}]})
print(f"Found: {len(result['results'])} memories")
for mem in result['results'][:5]:
    print(f"  • {mem['memory']}")

print("\n---")

print("\nTest 3: What does mem0 know about dependencies?\n")
result = client.search("depends on references entry point", filters={"AND": [{"user_id": "AgentSystem"}]})
print(f"Found: {len(result['results'])} memories")
for mem in result['results'][:3]:
    print(f"  • {mem['memory']}")

print("\n=== DIAGNOSIS ===")
print("If Test 1 returns 0: We never told mem0 about initCMD.txt")
print("If Test 3 returns 0: We never stored dependency information")
print("\nRoot cause: Not mem0's fault - we didn't give it the knowledge")
