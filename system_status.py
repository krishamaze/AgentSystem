# -*- coding: utf-8 -*-
import sys
import os
from pathlib import Path
from dotenv import load_dotenv

sys.stdout.reconfigure(encoding="utf-8")
load_dotenv()

print("=" * 60)
print("AGENT BRAIN SYSTEM STATUS")
print("=" * 60)

# Check .env configuration
print("\n[CONFIG]")
env_vars = ['MEM0_API_KEY', 'SUPABASE_URL', 'SUPABASE_ANON_KEY', 'SUPABASE_SERVICE_ROLE_KEY']
for var in env_vars:
    status = "SET" if os.getenv(var) else "MISSING"
    print(f"  {var}: {status}")

# Check Brain Files
print("\n[BRAIN FILES]")
agents = ['Agent_Primary', 'Agent_Agent_Architect', 'Agent_CodeAssist']
for agent in agents:
    brain_path = Path(f"./{agent}/brain")
    if brain_path.exists():
        files = list(brain_path.glob("*.md"))
        print(f"  {agent}: {len(files)} files")
        for f in files:
            size_kb = f.stat().st_size / 1024
            print(f"    - {f.name}: {size_kb:.1f} KB")
    else:
        print(f"  {agent}: NOT FOUND")

# Check Supabase Connection
print("\n[SUPABASE]")
try:
    from supabase import create_client
    client = create_client(os.getenv('SUPABASE_URL'), os.getenv('SUPABASE_ANON_KEY'))
    result = client.table('learnings').select('id').limit(1).execute()
    print(f"  Connection: OK")
    print(f"  Project: {os.getenv('SUPABASE_URL').split('//')[1].split('.')[0]}")
except Exception as e:
    print(f"  Connection: FAILED - {str(e)[:50]}")

# Check Projects
print("\n[PROJECTS]")
projects_path = Path("./Projects")
if projects_path.exists():
    projects = [p for p in projects_path.iterdir() if p.is_dir()]
    for proj in projects:
        progress_file = proj / "progress.json"
        status = "TRACKED" if progress_file.exists() else "UNTRACKED"
        print(f"  {proj.name}: {status}")
else:
    print("  No projects folder")

print("\n" + "=" * 60)
