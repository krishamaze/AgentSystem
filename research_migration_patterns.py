from dotenv import load_dotenv
load_dotenv()

from mem0 import MemoryClient
import json, pathlib, datetime

client = MemoryClient()

q = "migration namespace multi-tenant isolation patterns"
r = client.search(
    query=q,
    filters={"user_id": "AgentSystem"},
    limit=12
)

notes = {
    "timestamp": datetime.datetime.now().isoformat(),
    "query": q,
    "count": len(r.get("results", [])),
    "samples": [m.get("memory","") for m in r.get("results", [])[:6]]
}

out_path = pathlib.Path("D:/AgentSystem/MIGRATION_NOTES.json")
out_path.write_text(json.dumps(notes, indent=2, ensure_ascii=False), encoding="utf-8")
print(f"Wrote {out_path} with {notes['count']} results")
