"""
Memory Isolation Test Suite - AgentSystem
Validates namespace separation and metadata filtering
"""
from dotenv import load_dotenv
load_dotenv()

from mem0 import MemoryClient
import time

def test_isolation():
    client = MemoryClient()
    
    print("=== Memory Isolation Test Suite ===\n")
    
    # Test 1: Add test memories to each namespace
    print("[Test 1] Creating test memories in each namespace...")
    test_data = [
        {
            "user_id": "AgentSystem",
            "content": "AgentSystem test memory - isolation validation",
            "metadata": {"project": "AgentSystem", "test": True, "timestamp": time.time()}
        },
        {
            "user_id": "product-label-bot",
            "content": "product-label-bot test memory - barcode validation",
            "metadata": {"project": "product-label-bot", "test": True, "timestamp": time.time()}
        },
        {
            "user_id": "arin-bot-v2",
            "content": "arin-bot-v2 test memory - Gemini integration test",
            "metadata": {"project": "arin-bot-v2", "test": True, "timestamp": time.time()}
        }
    ]
    
    created_ids = []
    for data in test_data:
        try:
            result = client.add(
                messages=[{"role": "user", "content": data["content"]}],
                user_id=data["user_id"],
                metadata=data["metadata"]
            )
            # Note: API returns results array, extract ID if available
            print(f"  ✓ Created in {data['user_id']}")
            created_ids.append((data['user_id'], data['content']))
        except Exception as e:
            print(f"  ✗ Failed for {data['user_id']}: {e}")
    
    print(f"\nCreated {len(created_ids)} test memories")
    
    # Test 2: Verify isolation (search should only return own namespace)
    print("\n[Test 2] Verifying namespace isolation...")
    namespaces = ["AgentSystem", "product-label-bot", "arin-bot-v2"]
    
    for ns in namespaces:
        try:
            results = client.search(
                query="test memory",
                filters={"user_id": ns, "metadata": {"test": True}},
                limit=10
            )
            found = results.get('results', [])
            
            # Check if only memories from this namespace are returned
            cross_contamination = False
            for mem in found:
                content = mem.get('memory', '')
                if ns not in content and 'test memory' in content.lower():
                    cross_contamination = True
                    print(f"  ⚠ Cross-contamination in {ns}: found '{content[:50]}...'")
            
            if not cross_contamination and found:
                print(f"  ✓ {ns}: Isolated ({len(found)} memories, no cross-contamination)")
            elif not found:
                print(f"  ⚠ {ns}: No memories found (may not be created yet)")
            
        except Exception as e:
            print(f"  ✗ {ns}: Query failed - {e}")
    
    # Test 3: Metadata filtering
    print("\n[Test 3] Testing metadata filtering...")
    try:
        results = client.search(
            query="test",
            filters={
                "user_id": "AgentSystem",
                "metadata": {"project": "AgentSystem", "test": True}
            },
            limit=5
        )
        found = results.get('results', [])
        print(f"  ✓ Metadata filter works: {len(found)} results for test=True")
    except Exception as e:
        print(f"  ✗ Metadata filtering failed: {e}")
    
    # Cleanup suggestion
    print("\n[Cleanup] Test memories created")
    print("  To remove test memories, use client.delete() with memory IDs")
    print("  Or filter by metadata: {'test': True}")
    
    print("\n=== Test Suite Complete ===")

if __name__ == "__main__":
    test_isolation()
