from dotenv import load_dotenv
load_dotenv()

from mem0 import MemoryClient
import json

client = MemoryClient()

# Use filters for get_all; optionally enable graph for richer context
res = client.get_all(
    filters={"user_id": "AgentSystem"},
    enable_graph=True,
    page=1,
    page_size=10
)
print(json.dumps({"count": len(res.get("results", []))}, indent=2))
