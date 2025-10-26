from dotenv import load_dotenv
load_dotenv()

from mem0 import MemoryClient
import json, pathlib, datetime, time

client = MemoryClient()

# Ensure Graph Memory is enabled at project level (preferred over per-call flags)
try:
    client.project.update(enable_graph=True)
except Exception:
    pass

experiments = {
    "timestamp": datetime.datetime.now().isoformat(),
    "exp1": {"title": "Entity Extraction", "status": "pending"},
    "exp2": {"title": "Relationship Formation", "status": "pending"}
}

# Experiment 1: clear entities in content
messages1 = [{
    "role": "user",
    "content": "product-label-bot is a Telegram bot built with Deno, deployed on Supabase, using @undecaf/zbar-wasm for EAN-13 barcode detection."
}]
try:
    client.add(messages=messages1, user_id="AgentSystem", enable_graph=True, metadata={"experiment": "entity_extraction", "test_id": "exp1"})
    time.sleep(1.0)
    res1 = client.search(query="barcode detection", filters={"user_id": "AgentSystem"}, enable_graph=True, limit=5)
    experiments["exp1"].update({
        "status": "done",
        "query": "barcode detection",
        "results": [m.get("memory","") for m in res1.get("results", [])]
    })
except Exception as e:
    experiments["exp1"]["status"] = f"error: {e}"

# Experiment 2: temporal relationship across milestones
try:
    client.add(messages=[{"role": "user", "content": "product-label-bot Milestone 1 completed on 2025-10-19"}], user_id="AgentSystem", enable_graph=True, metadata={"experiment": "relationships", "test_id": "exp2a"})
    client.add(messages=[{"role": "user", "content": "product-label-bot Milestone 2 started after Milestone 1"}], user_id="AgentSystem", enable_graph=True, metadata={"experiment": "relationships", "test_id": "exp2b"})
    time.sleep(1.0)
    res2 = client.search(query="Milestone 1", filters={"user_id": "AgentSystem"}, enable_graph=True, limit=5)
    experiments["exp2"].update({
        "status": "done",
        "query": "Milestone 1",
        "results": [m.get("memory","") for m in res2.get("results", [])]
    })
except Exception as e:
    experiments["exp2"]["status"] = f"error: {e}"

out_path = pathlib.Path("D:/AgentSystem/GRAPHMEM_EXPERIMENTS.json")
out_path.write_text(json.dumps(experiments, indent=2, ensure_ascii=False), encoding="utf-8")
print(f"Wrote {out_path}")
