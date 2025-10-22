import json
from datetime import datetime

# Load existing index
with open(".meta/system-index.json", "r") as f:
    index = json.load(f)

# Add cleanup record
index["last_cleanup"] = datetime.now().isoformat()
index["cleanup_summary"] = {
    "date": datetime.now().strftime("%Y-%m-%d"),
    "actions": [
        "Moved 14 test files to tests/",
        "Archived 3 Agent_* legacy directories",
        "Archived manual Backups/ folder (0.16 MB)",
        "Consolidated learned-knowledge.md files"
    ],
    "bloat_reduction": {
        "test_files_organized": 14,
        "legacy_directories_archived": 3,
        "duplicate_files_removed": 5,
        "manual_backups_archived": "0.16 MB"
    },
    "new_structure": {
        "tests/": "All test files",
        "archive/v2-agents/": "Legacy Agent_* code",
        "archive/manual-backups/": "Old Backups/",
        "memory/tenants/AgentSystem/protocols/": "Protocol system"
    }
}

# Update capabilities
index["capabilities"]["total_tools"] = 15  # Still same
index["capabilities"]["protocols_active"] = 3  # memory-first, universal, task-continuity

# Save updated index
with open(".meta/system-index.json", "w") as f:
    json.dump(index, f, indent=2)

print("✓ system-index.json updated with cleanup summary")
print(f"  Last cleanup: {datetime.now().strftime('%Y-%m-%d %H:%M')}")
print(f"  Bloat reduction: 14 test files + 3 directories + backups")
