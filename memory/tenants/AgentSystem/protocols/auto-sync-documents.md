# Auto-Sync Documents to Mem0

**Problem:** Manual sync is tedious and error-prone

**Solution:** Background watcher that syncs documents automatically

---

## Implementation: Git Post-Commit Hook

**When:** After every Git commit
**What:** Extract key information from changed files
**How:** Parse diffs, send summaries to mem0

### Setup: .git/hooks/post-commit

\\\ash
#!/bin/bash
# Auto-sync to mem0 after commit

echo "Syncing commit to mem0..."
python tools/auto-sync-to-mem0.py
\\\

### tools/auto-sync-to-mem0.py

\\\python
from dotenv import load_dotenv
from mem0 import MemoryClient
import subprocess
import json

load_dotenv()
client = MemoryClient()

# Get last commit details
commit_msg = subprocess.check_output(['git', 'log', '-1', '--pretty=%B']).decode()
changed_files = subprocess.check_output(['git', 'diff-tree', '--no-commit-id', '--name-only', '-r', 'HEAD']).decode().split()

# Extract key info
protocols_changed = [f for f in changed_files if 'protocols/' in f]
plans_changed = [f for f in changed_files if 'plans/' in f]

# Build summary
summary = f"Git commit: {commit_msg[:100]}\\n"
if protocols_changed:
    summary += f"Protocols updated: {', '.join(protocols_changed)}\\n"
if plans_changed:
    summary += f"Plans updated: {', '.join(plans_changed)}"

# Sync to mem0 (fire and forget, background processing)
client.add([{
    "role": "user",
    "content": summary
}], user_id="AgentSystem", metadata={
    "type": "auto_sync",
    "source": "git_commit"
})

print("✓ Auto-synced to mem0 (background)")
\\\

---

## Alternative: File Watcher

**When:** File saved (any .md in protocols/ or plans/)
**What:** Parse file, extract key sections
**How:** Background daemon watching directories

### Using watchdog library:

\\\python
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
from mem0 import MemoryClient

class ProtocolSyncHandler(FileSystemEventHandler):
    def on_modified(self, event):
        if event.is_directory:
            return
        if '/protocols/' in event.src_path or '/plans/' in event.src_path:
            sync_file_to_mem0(event.src_path)

def sync_file_to_mem0(filepath):
    # Parse file, extract summary
    # Send to mem0 in background
    pass
\\\

---

## Benefits

1. **Zero manual effort** - happens automatically
2. **Never forget** - every change synced
3. **Background** - doesn't block work
4. **Git integration** - tied to commits
5. **Selective** - only protocols/plans/important files

---

## Risks

**Risk:** Too much noise in mem0
**Mitigation:** Only sync meaningful changes (protocols, plans, ADRs)

**Risk:** Background failures silent
**Mitigation:** Log to .meta/auto-sync.log

**Risk:** Mem0 rate limits
**Mitigation:** Batch updates, throttle

---

## Recommendation

**Phase 1 (Now):** Git post-commit hook (simple)
**Phase 2 (Later):** File watcher (advanced)
**Phase 3 (Future):** Smart parsing (extract key info only)

---

**Next Step:** Create tools/auto-sync-to-mem0.py + post-commit hook
