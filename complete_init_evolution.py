from dotenv import load_dotenv
from mem0 import MemoryClient

load_dotenv()
client = MemoryClient()

# Complete init evolution task
messages = [
    {
        "role": "user",
        "content": """Task complete: Init evolution to v3.1 memory-first

Completed:
- Init size reduced 59% (1.84 KB → 0.75 KB)
- AI queries mem0 for instructions instead of loading files
- Template is instructions, not hardcoded rules
- v3.1 foundation ready

Enhancements noted:
- Rotational protocol injection (implement later)
- Memory seeding when empty results
- Smart trigger-based reminders

Next predicted step: Test v3.1 init in real session"""
    }
]

result = client.add(messages, user_id="AgentSystem", metadata={
    "type": "task_complete",
    "milestone": "init_evolution"
})

print("✓ Task completion synced to mem0")
print(f"  Event ID: {result['results'][0].get('event_id')}")

# Predictive context for next session
print("\n=== Predictive Context for Next Session ===\n")

# Query what typically comes after init evolution
context = client.search(
    "v3.1 autonomous architecture implementation intent detection",
    filters={"AND": [{"user_id": "AgentSystem"}]}
)

print("Next likely tasks:")
for i, mem in enumerate(context['results'][:3]):
    print(f"  {i+1}. {mem['memory']}")

print("\nRelevant context loaded for continuation.")
