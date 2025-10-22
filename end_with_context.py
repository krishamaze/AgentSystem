from dotenv import load_dotenv
from mem0 import MemoryClient

load_dotenv()
client = MemoryClient()

print("=== Session Ended ===")
print("Predicting next session context...\n")

# Check for incomplete tasks
incomplete = client.search("task IN_PROGRESS PAUSED incomplete", 
    filters={"AND": [{"user_id": "AgentSystem"}]})

# Check for high priority items  
priority = client.search("priority HIGH next session v3.1",
    filters={"AND": [{"user_id": "AgentSystem"}]})

# Load evolving plans
plans = client.search("DRAFT plan v3.1 implementation",
    filters={"AND": [{"user_id": "AgentSystem"}]})

print("Next Session Context Preview:\n")

if incomplete["results"]:
    print("📋 Incomplete Tasks:")
    for mem in incomplete["results"][:3]:
        print(f"  • {mem['memory']}")

if priority["results"]:
    print("\n⭐ High Priority Items:")
    for mem in priority["results"][:3]:
        print(f"  • {mem['memory']}")
        
if plans["results"]:
    print("\n📝 Active Plans:")
    for mem in plans["results"][:2]:
        print(f"  • {mem['memory']}")

print("\n✓ Context loaded for next session")
print("Next session AI will have this context ready")
