from dotenv import load_dotenv
from mem0 import MemoryClient
import json
from datetime import datetime

load_dotenv()
client = MemoryClient()

# Get current memory stats
result = client.get_all(
    filters={"AND": [{"user_id": "AgentSystem"}]},
    page_size=150
)

# Load existing index
with open(".meta/system-index.json", "r") as f:
    index = json.load(f)

# Update with current stats
index["last_updated"] = datetime.now().isoformat()
index["memory_stats"] = {
    "total_memories": len(result["results"]),
    "last_sync": datetime.now().isoformat()
}

# Save updated index
with open(".meta/system-index.json", "w") as f:
    json.dump(index, f, indent=2)

print("✓ system-index.json updated")
print(f"  Total memories: {len(result['results'])}")
print(f"  Last updated: {datetime.now().strftime('%Y-%m-%d %H:%M')}")
