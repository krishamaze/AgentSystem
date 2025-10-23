from dotenv import load_dotenv
from mem0 import MemoryClient
from datetime import datetime

load_dotenv()
client = MemoryClient()

# Query mem0 for key context
queries = {
    "protocols": "AgentSystem protocols memory-first task-continuity",
    "capabilities": "AgentSystem capabilities role responsibilities",
    "current_state": "AgentSystem v3.1 current implementation status"
}

print("Querying mem0 for context...")
context = {}
for key, query in queries.items():
    result = client.search(query, filters={'AND': [{'user_id': 'AgentSystem'}]})
    context[key] = [mem['memory'] for mem in result['results'][:5]]
    print(f"  {key}: {len(context[key])} memories loaded")

# Generate expanded init with pre-loaded context
session_id = f"session_{datetime.now().strftime('%Y%m%d_%H%M%S')}"

init_prompt = f"""# AgentSystem v3.1 - Perplexity Init (Context Pre-Loaded)

**Session ID:** {session_id}
**User:** Krishna (krishna_001)
**Intent:** general
**Platform:** Perplexity AI

---

## Your Role & Context (Loaded from Mem0)

### Active Protocols
"""

for protocol in context['protocols']:
    init_prompt += f"- {protocol}\n"

init_prompt += "\n### Your Capabilities\n"
for cap in context['capabilities']:
    init_prompt += f"- {cap}\n"

init_prompt += "\n### Current Project State\n"
for state in context['current_state']:
    init_prompt += f"- {state}\n"

init_prompt += """

---

## Your Instructions

1. **Acknowledge protocols loaded above**
2. **Check for incomplete tasks** (ask user)
3. **Apply memory-first workflow:**
   - Before creating files, ask about existing patterns
   - Before major changes, check dependencies
   - Use task completion checklist (4 levels)
4. **Start with transparency:** 
   - Show what context you loaded
   - Explain your reasoning
   - Provide 3-5 commands per response (batch rule)

---

**You are AgentSystem AI - an autonomous assistant with pre-loaded institutional memory.**

Size: ~{len(init_prompt)} bytes | Context pre-populated from mem0
"""

# Save to file for review
with open('init_prompt_v3.1_perplexity.txt', 'w', encoding='utf-8') as f:
    f.write(init_prompt)

print("\n✓ Perplexity-compatible init generated")
print(f"  Size: {len(init_prompt)} bytes")
print(f"  File: init_prompt_v3.1_perplexity.txt")
print("\nPreview:")
print(init_prompt[:500] + "...")
