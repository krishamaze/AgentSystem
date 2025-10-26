from dotenv import load_dotenv
load_dotenv()

from mem0 import MemoryClient
import json, pathlib, datetime

client = MemoryClient()

# Confirm Graph Memory status via project interface
try:
    proj = client.project.get(fields=["enable_graph","custom_categories","version"])
except Exception:
    proj = {"enable_graph": None, "custom_categories": None, "version": None}

# Graph-aware search for relationship-rich items
q = "graph memory relationships entities extraction"
results = client.search(
    query=q,
    filters={"user_id": "AgentSystem"},
    enable_graph=True,
    limit=10
)

notes = {
    "timestamp": datetime.datetime.now().isoformat(),
    "project_config": proj,
    "query": q,
    "count": len(results.get("results", [])),
    "samples": [m.get("memory","") for m in results.get("results", [])[:5]]
}

out_path = pathlib.Path("D:/AgentSystem/GRAPHMEM_NOTES.json")
out_path.write_text(json.dumps(notes, indent=2, ensure_ascii=False), encoding="utf-8")
print(f"Wrote {out_path} with {notes['count']} results")
