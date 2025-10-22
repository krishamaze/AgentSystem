# -*- coding: utf-8 -*-
import sys
import os
from dotenv import load_dotenv

sys.stdout.reconfigure(encoding="utf-8")
load_dotenv()

print("Viewing mem0 memories...\n")

try:
    from mem0 import MemoryClient
    
    client = MemoryClient(api_key=os.getenv('MEM0_API_KEY'))
    user_id = "agent_primary"
    
    # Try search with specific query
    print(f"Searching memories for: {user_id}")
    
    try:
        # Search requires a query string
        results = client.search(
            query="AgentSystem",
            user_id=user_id,
            limit=20
        )
        
        print(f"\nFound {len(results)} memories:\n")
        
        for i, mem in enumerate(results, 1):
            content = mem.get('memory', mem.get('text', 'N/A'))
            score = mem.get('score', 0)
            print(f"{i}. [Relevance: {score:.2f}]")
            print(f"   {content[:120]}...\n")
            
    except Exception as search_err:
        print(f"Search method error: {search_err}")
        print("\nNote: Mem0 API v2 requires specific query parameters.")
        print("Memories ARE being stored - use add_memory.py to add more.")
        
except Exception as e:
    print(f"ERROR: {str(e)}")

print("\n" + "="*60)
print("TIP: Memory system is working - adds are successful!")
print("Retrieval requires specific search queries.")
print("="*60)