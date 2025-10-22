from dotenv import load_dotenv
from mem0 import MemoryClient
import os

load_dotenv()
client = MemoryClient()

print("\n[Test 1A] Verify API key is loaded:")
api_key = os.getenv("MEM0_API_KEY")
if api_key:
    print(f"  ✓ API Key found: {api_key[:20]}...{api_key[-4:]}")
else:
    print("  ✗ API Key NOT found in environment")
    exit(1)

print("\n[Test 1B] Test API connection:")
try:
    # This should work if API key is valid
    response = client.get_all(filters={"AND": [{"user_id": "test-connection"}]})
    print(f"  ✓ API connection successful")
    print(f"  Response: {response}")
except Exception as e:
    print(f"  ✗ API connection failed: {e}")

print("\n[Test 1C] Check API response structure:")
try:
    # Try getting memories (even if empty)
    response = client.get_all(filters={"AND": [{"user_id": "test"}]})
    print(f"  ✓ API responds correctly")
    print(f"  Structure: {list(response.keys())}")
    print(f"  Results: {len(response.get('results', []))} memories found")
except Exception as e:
    print(f"  ✗ Error: {e}")

print("\n✓ Test 1 complete")
