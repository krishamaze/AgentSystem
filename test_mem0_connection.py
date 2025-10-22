# -*- coding: utf-8 -*-
import sys
import os
from dotenv import load_dotenv

sys.stdout.reconfigure(encoding="utf-8")
load_dotenv()

print("Testing mem0 Connection...\n")

try:
    from mem0 import MemoryClient
    
    api_key = os.getenv('MEM0_API_KEY')
    if not api_key:
        print("ERROR: MEM0_API_KEY not found in .env")
        sys.exit(1)
    
    print(f"API Key: {api_key[:10]}...{api_key[-5:]}")
    
    # Initialize client
    client = MemoryClient(api_key=api_key)
    print("Client initialized successfully")
    
    # Test basic operations
    test_user = "agent_system_test"
    
    # Add a test memory
    print(f"\nAdding test memory for user: {test_user}")
    result = client.add(
        messages=[{"role": "user", "content": "Test memory from AgentSystem"}],
        user_id=test_user
    )
    print(f"Memory added: {result}")
    
    # Retrieve memories
    print(f"\nRetrieving memories for user: {test_user}")
    memories = client.get_all(user_id=test_user)
    print(f"Found {len(memories)} memories")
    
    for i, mem in enumerate(memories[:3], 1):
        print(f"  {i}. {mem.get('memory', 'N/A')[:60]}...")
    
    print("\nConnection test: SUCCESS")
    
except ImportError:
    print("ERROR: mem0ai package not installed. Run: pip install mem0ai")
except Exception as e:
    print(f"ERROR: {type(e).__name__}: {str(e)}")
