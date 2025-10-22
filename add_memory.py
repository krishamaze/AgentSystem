# -*- coding: utf-8 -*-
import sys
import os
from dotenv import load_dotenv

sys.stdout.reconfigure(encoding="utf-8")
load_dotenv()

print("Adding memory to mem0...\n")

try:
    from mem0 import MemoryClient
    
    client = MemoryClient(api_key=os.getenv('MEM0_API_KEY'))
    
    # Add a memory with context
    result = client.add(
        messages=[{
            "role": "assistant",
            "content": "Agent Primary brain contains 50.8 KB of learned knowledge about the AgentSystem architecture"
        }],
        user_id="agent_primary",
        metadata={"source": "system_scan", "agent": "Agent_Primary"}
    )
    
    print(f"Memory added: {result}")
    print("\nMemory will be indexed in background (~5-10 seconds)")
    
except Exception as e:
    print(f"ERROR: {str(e)}")
