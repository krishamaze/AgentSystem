# -*- coding: utf-8 -*-
import sys
import os
from dotenv import load_dotenv

sys.stdout.reconfigure(encoding="utf-8")
load_dotenv()

user_id = "agent_primary"

print(f"Checking memories for user: {user_id}\n")

try:
    from mem0 import MemoryClient
    
    client = MemoryClient(api_key=os.getenv('MEM0_API_KEY'))
    
    # Use search with query instead of get_all (API v2 requirement)
    memories = client.search(
        query="agent system learnings",
        user_id=user_id,
        limit=10
    )
    
    print(f"Found {len(memories)} memories\n")
    
    if memories:
        print("Recent memories:")
        for i, mem in enumerate(memories, 1):
            content = mem.get('memory', mem.get('text', 'N/A'))
            score = mem.get('score', 'N/A')
            print(f"{i}. [Score: {score}] {content[:80]}...")
    else:
        print("No memories found. Add some first!")
        
except Exception as e:
    print(f"ERROR: {str(e)}")
