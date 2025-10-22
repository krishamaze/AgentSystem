from dotenv import load_dotenv
from mem0 import MemoryClient

load_dotenv()
client = MemoryClient()

messages = [
    {
        "role": "user",
        "content": """Next session plan: Complete v3.1 implementation

Current status: v3.1 is 40% complete (protocols done, autonomous architecture missing)

Next session goals:
1. Implement ADR-004 autonomous architecture
2. Create intent detection system (analyze user query → determine needed context)
3. Build context loader (query mem0 for relevant memories automatically)
4. Simplify init.ps1 to be mem0-powered (10 lines instead of current)
5. Test autonomous operation (can system work with minimal init?)

Success criteria:
- Init prompt reduced from current to ~10 lines
- System loads own context from mem0
- AI detects intent and fetches relevant memories
- Session starts with: "Load your config from mem0" instead of pasting everything

This completes v3.1, making v4.0 possible."""
    },
    {
        "role": "assistant", 
        "content": "Understood. Next session will implement the autonomous architecture. I'll query mem0 for this plan and pick up where we left off."
    }
]

result = client.add(messages, user_id="AgentSystem", metadata={
    "type": "next_session_plan",
    "milestone": "v3.1_completion",
    "priority": "HIGH"
})

print("✓ Next session plan synced to Mem0")
print(f"  Event ID: {result['results'][0].get('event_id')}")
print("\nNext session: AI will query mem0 and resume v3.1 implementation")
