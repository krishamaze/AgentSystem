from dotenv import load_dotenv
from mem0 import MemoryClient

load_dotenv()
client = MemoryClient()

messages = [
    {
        "role": "user",
        "content": "Important workflow insight: Plans should be transparent living documents, not hidden approvals. Create DRAFT plans that evolve with learning. Users want transparency (shared understanding), not approval gates. Plan files should be marked DRAFT and updated as implementation reveals better approaches."
    },
    {
        "role": "assistant",
        "content": "Understood. Plans are transparent communication tools, not approval documents. Will create evolving DRAFT plans that update as we learn."
    }
]

client.add(messages, user_id="AgentSystem", metadata={
    "type": "workflow_principle",
    "topic": "transparency"
})

print("✓ Transparency principle synced to Mem0")
