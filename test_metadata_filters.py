from dotenv import load_dotenv
load_dotenv()

from mem0 import MemoryClient

client = MemoryClient()

print("=== Testing Metadata & Filtering ===\n")

# Test 1: Add memory with metadata
print("[Test 1] Adding memory with metadata...")
try:
    result = client.add(
        messages=[{"role": "user", "content": "Test memory for isolation architecture research"}],
        user_id="AgentSystem",
        metadata={"project": "AgentSystem", "session": "research_2025_10_25", "type": "test"}
    )
    print(f"✓ Added memory: {result.get('results', [{}])[0].get('id', 'N/A')}")
except Exception as e:
    print(f"✗ Error: {e}")

# Test 2: Search with metadata filters
print("\n[Test 2] Searching with metadata filters...")
try:
    results = client.search(
        query="isolation architecture",
        filters={
            "user_id": "AgentSystem",
            "metadata": {"project": "AgentSystem"}
        },
        limit=3
    )
    print(f"✓ Found {len(results.get('results', []))} results")
    for r in results.get('results', [])[:2]:
        print(f"  - {r.get('memory', 'N/A')[:80]}...")
except Exception as e:
    print(f"✗ Error: {e}")

# Test 3: Get all memories with filters
print("\n[Test 3] Testing get_all() with filters...")
try:
    all_mems = client.get_all(user_id="AgentSystem", limit=5)
    print(f"✓ Total memories: {len(all_mems.get('results', []))}")
except Exception as e:
    print(f"✗ Error: {e}")

print("\n=== Metadata Test Complete ===")
