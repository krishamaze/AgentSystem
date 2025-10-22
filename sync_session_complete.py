from dotenv import load_dotenv
from mem0 import MemoryClient

load_dotenv()
client = MemoryClient()

# Session summary as conversation
messages = [
    {
        "role": "user",
        "content": """Today's session (2025-10-22):

1. Investigated Mem0 Platform integration and tested memory access methods
2. Discovered memory-first workflow prevents duplication
3. Identified system bloat: 14 test files in root, 3 legacy Agent_* dirs, manual backups
4. Created 3 comprehensive protocols:
   - memory-first-workflow.md: Query memory before any action
   - universal-protocol-system.md: 10 protocols covering all operations
   - task-continuity.md: Prevent forgotten tasks during deviations

5. Executed system cleanup:
   - Moved 14 test files to tests/
   - Archived 3 Agent_* directories
   - Archived manual Backups/ folder
   - Consolidated learned-knowledge.md files
   - Committed all changes to Git

6. Key insight: Memory-first prevents bloat, but we also need task tracking to prevent incomplete work.

Result: Bloat reduced from 6/10 to 2/10. System now has strict protocols."""
    },
    {
        "role": "assistant",
        "content": "Excellent session! I've documented the memory-first workflow, created comprehensive protocols, and successfully cleaned up the system. The task continuity protocol will prevent future incomplete work."
    }
]

result = client.add(messages, user_id="AgentSystem", metadata={
    "type": "session_complete",
    "date": "2025-10-22",
    "major_milestone": "Protocol System Established"
})

print("✓ Session learnings synced to Mem0")
print(f"  Event ID: {result['results'][0].get('event_id')}")
print("\nProcessing in background (~30s)...")
