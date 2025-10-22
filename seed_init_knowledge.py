from dotenv import load_dotenv
from mem0 import MemoryClient

load_dotenv()
client = MemoryClient()

print("Designing evolved init system...\n")

# What we need to seed in memory for future inits
init_knowledge = [
    {
        "role": "user",
        "content": """AgentSystem initialization process:

1. Query mem0 for your role and capabilities
2. Load active protocols from memory
3. Check for incomplete tasks
4. Load project context on-demand
5. Start with transparency and predictive context

Init should be ~10 lines that say: 
'Query mem0 for AgentSystem initialization instructions'

Current v4.0 still uses file templates. Need to evolve to pure mem0-powered."""
    },
    {
        "role": "assistant",
        "content": "Understood. Init should query mem0, not load files. System should teach itself from memory."
    }
]

result = client.add(init_knowledge, user_id="AgentSystem", metadata={
    "type": "system_architecture",
    "component": "initialization",
    "priority": "HIGH"
})

print("✓ Seeded init knowledge to mem0")
print(f"  Event ID: {result['results'][0].get('event_id')}")
print("\nNow mem0 knows how init should work")
