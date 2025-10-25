# Pre-Task Query Protocol

**Purpose:** Before starting any significant task, query mem0 to discover:
- What files should be updated
- What dependencies exist
- Common mistakes or missed steps
- Checklist for completion

---

## Procedure

1. Identify task name and scope
2. Query mem0 with relevant queries:
   - '{task} update entry points dependencies'
   - '{task} common mistakes'
   - '{task} completion checklist'
3. Review returned memories for:
   - Files or modules needing update
   - Known pitfalls
   - Integration points
4. Add these to task plan
5. Proceed with task implementation confidently

---

## Example in Python

from dotenv import load_dotenv
from mem0 import MemoryClient

load_dotenv()
client = MemoryClient()

task = "init evolution"

queries = [
    f"{task} update entry points dependencies",
    f"{task} common mistakes",
    f"{task} completion checklist"
]

for query in queries:
    print(f"Querying mem0: {query}")
    results = client.search(query, filters={"AND": [{"user_id": "AgentSystem"}]})
    for mem in results['results'][:5]:
        print(f"  • {mem['memory']}")

---

## Next Step

Add this check as a mandatory first step in all new task workflows.

