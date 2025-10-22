from dotenv import load_dotenv
from mem0 import MemoryClient

load_dotenv()
client = MemoryClient()

client.add([{
    "role": "user",
    "content": """Init evolution FULLY complete using checklist protocol:

Component: ✓ All files created and tested
Integration: ✓ initCMD.txt updated, start-session.ps1 redirects to v3.1
End-to-End: ✓ Full workflow tested
Memory: ✓ All changes documented

Key files:
- initCMD.txt → calls start-session.v3.1.ps1
- start-session.ps1 → redirects to v3.1 (backward compat)
- start-session.v3.1.ps1 → new memory-first system
- init_prompt_v3.1_template.txt → 59% smaller

Lesson learned: Task completion checklist prevents missed integration points"""
}], user_id="AgentSystem", metadata={"type": "task_complete", "checklist_verified": True})

print("✓ Full completion synced to mem0")
