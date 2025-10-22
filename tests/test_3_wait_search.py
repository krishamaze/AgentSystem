from dotenv import load_dotenv
from mem0 import MemoryClient
import time

load_dotenv()
client = MemoryClient()

print("\n[Test 3A] Add memory and get event_id:")
messages = [
    {"role": "user", "content": "I am Krishna from Coimbatore working on AgentSystem"},
    {"role": "assistant", "content": "Got it, Krishna!"}
]

result = client.add(messages, user_id="test-user-003")
event_id = result['results'][0].get('event_id')
status = result['results'][0].get('status')
print(f"  ✓ Memory queued")
print(f"  Status: {status}")
print(f"  Event ID: {event_id}")

print("\n[Test 3B] Wait for background processing (30 seconds):")
for i in range(6):
    time.sleep(5)
    print(f"  ... waiting ({i*5 + 5}s)")

print("\n[Test 3C] Search for the memory:")
search_result = client.search(
    "Krishna Coimbatore AgentSystem",
    filters={"AND": [{"user_id": "test-user-003"}]}
)
print(f"  Memories found: {len(search_result['results'])}")

if search_result['results']:
    print(f"  ✓ SUCCESS! Memory retrieved:")
    for mem in search_result['results']:
        print(f"    - {mem['memory']}")
else:
    print(f"  Still processing... try get_all:")
    all_mem = client.get_all(filters={"AND": [{"user_id": "test-user-003"}]})
    print(f"  Total memories: {len(all_mem['results'])}")
    if all_mem['results']:
        for mem in all_mem['results']:
            print(f"    - {mem['memory']}")

print("\n[Test 3D] Check all test users:")
for user_id in ["test-user-001", "test-user-002", "test-user-003"]:
    result = client.get_all(filters={"AND": [{"user_id": user_id}]})
    print(f"  {user_id}: {len(result['results'])} memories")

print("\n✓ Test 3 complete")
