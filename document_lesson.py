from dotenv import load_dotenv
from mem0 import MemoryClient

load_dotenv()
client = MemoryClient()

client.add([{
    "role": "user",
    "content": """Critical lesson from init evolution task:

PROBLEM: We created new files (start-session.v3.1.ps1, init template) 
but forgot to update entry point (initCMD.txt). Task appeared complete 
but was actually 58% done.

SOLUTION: Task Completion Checklist Protocol with 4 levels:
1. Component Level - files created/tested
2. Integration Level - entry points and dependencies updated
3. End-to-End Level - full workflow tested
4. Memory Level - changes documented

IMPACT: Found 12 files referencing old v4.0 system. Checklist caught 
the incomplete integration immediately.

RULE: A task is NOT complete until all 4 levels pass 100%.

This checklist will prevent shipping incomplete work in the future."""
}], user_id="AgentSystem", metadata={
    "type": "lesson_learned",
    "priority": "HIGH",
    "applies_to": "all_future_tasks"
})

print("✓ Lesson learned synced to institutional memory")
print("  Future tasks will follow checklist protocol")
