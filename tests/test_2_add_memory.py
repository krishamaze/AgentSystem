from dotenv import load_dotenv
from mem0 import MemoryClient
import json

load_dotenv()
client = MemoryClient()

print("\n[Test 2A] Add memory using conversation format:")
# Mem0 Platform requires messages in conversation format
messages = [
    {"role": "user", "content": "My name is Krishna and I live in Coimbatore, India. I work on AgentSystem project."},
    {"role": "assistant", "content": "Nice to meet you Krishna! I'll remember that you're from Coimbatore and working on AgentSystem."}
]

try:
    result = client.add(messages, user_id="test-user-001")
    print(f"  ✓ Memory added successfully")
    print(f"  Response structure: {list(result.keys())}")
    print(f"  Full response: {json.dumps(result, indent=2)}")
    
    # Check if extraction succeeded
    if 'results' in result and len(result['results']) > 0:
        print(f"  ✓ Extraction successful: {len(result['results'])} memories extracted")
        for i, mem in enumerate(result['results']):
            print(f"    {i+1}. Memory: {mem.get('memory', 'N/A')}")
            print(f"       ID: {mem.get('id', 'N/A')}")
    else:
        print(f"  ⚠ Warning: No memories extracted (empty results)")
        
except Exception as e:
    print(f"  ✗ Failed to add memory: {e}")

print("\n[Test 2B] Try with simpler message:")
# Sometimes simpler is better
simple_messages = [
    {"role": "user", "content": "I am Krishna"},
    {"role": "assistant", "content": "Hello Krishna"}
]

try:
    result2 = client.add(simple_messages, user_id="test-user-002")
    print(f"  ✓ Simple memory added")
    print(f"  Memories extracted: {len(result2.get('results', []))}")
except Exception as e:
    print(f"  ✗ Failed: {e}")

print("\n✓ Test 2 complete")
