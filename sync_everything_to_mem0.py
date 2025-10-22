# sync_everything_to_mem0.py - SMART VERSION (reads system dynamically)
from dotenv import load_dotenv
from mem0 import MemoryClient

load_dotenv()  # Load .env file
import os
import json
import glob
from datetime import datetime

client = MemoryClient()
user_id = "krishna_001"

print("=== Smart Sync: Reading System Dynamically ===\n")

# DYNAMIC: Read actual system structure
print("1. Scanning system structure...")
def scan_directory_tree(root_path, max_depth=3, current_depth=0):
    """Dynamically scan and build directory tree"""
    tree = []
    if current_depth >= max_depth:
        return tree
    
    try:
        for item in os.listdir(root_path):
            if item.startswith('.') and item != '.meta':
                continue
            item_path = os.path.join(root_path, item)
            if os.path.isdir(item_path):
                tree.append(f"{'  ' * current_depth}├── {item}/")
                tree.extend(scan_directory_tree(item_path, max_depth, current_depth + 1))
            elif item.endswith(('.ps1', '.py', '.json', '.md', '.txt')):
                tree.append(f"{'  ' * current_depth}├── {item}")
    except PermissionError:
        pass
    return tree

system_root = "D:/AgentSystem"
tree = scan_directory_tree(system_root, max_depth=3)
system_structure = f"AgentSystem File Structure (scanned {datetime.now().strftime('%Y-%m-%d %H:%M')}):\n\n"
system_structure += "\n".join(tree[:100])  # Limit to prevent overflow

messages = [{"role": "user", "content": system_structure}]
client.add(messages, user_id=user_id, metadata={"type": "system_structure", "scan_date": datetime.now().isoformat()})
print(f"  ✓ Scanned {len(tree)} files/folders")

# DYNAMIC: Read ALL tools automatically
print("\n2. Scanning all tools...")
tools_dir = f"{system_root}/tools"
tool_count = 0
for tool_file in glob.glob(f"{tools_dir}/*.ps1"):
    tool_name = os.path.basename(tool_file)
    with open(tool_file, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read(2000)
    
    messages = [{"role": "user", "content": f"Tool: {tool_name}\nPath: tools/{tool_name}\n\n{content}"}]
    client.add(messages, user_id=user_id, metadata={"type": "tool", "name": tool_name, "scan_date": datetime.now().isoformat()})
    tool_count += 1
print(f"  ✓ {tool_count} tools synced")

# DYNAMIC: Read project metadata from registry
print("\n3. Reading project registry...")
registry_file = f"{system_root}/.meta/tenant-registry.json"
if os.path.exists(registry_file):
    with open(registry_file, 'r', encoding='utf-8') as f:
        projects = json.load(f)
    
    for project in projects.get("projecttenants", []):
        project_info = f"""Project: {project['name']}
Owner: {project.get('owner', 'unknown')}
Path: {project.get('path', 'unknown')}
Namespace: {project.get('namespace', 'unknown')}
"""
        messages = [{"role": "user", "content": project_info}]
        client.add(messages, user_id=user_id, metadata={"type": "project", "name": project['name']})
    print(f"  ✓ {len(projects)} projects synced")

# DYNAMIC: Read project roadmaps
print("\n4. Scanning project roadmaps...")
projects_dir = f"{system_root}/Projects"
roadmap_count = 0
if os.path.exists(projects_dir):
    for project_folder in os.listdir(projects_dir):
        project_path = os.path.join(projects_dir, project_folder)
        if os.path.isdir(project_path):
            roadmap_file = os.path.join(project_path, "roadmap.md")
            if os.path.exists(roadmap_file):
                with open(roadmap_file, 'r', encoding='utf-8', errors='ignore') as f:
                    roadmap = f.read()
                messages = [{"role": "user", "content": f"Roadmap: {project_folder}\n\n{roadmap}"}]
                client.add(messages, user_id=user_id, metadata={"type": "roadmap", "project": project_folder})
                roadmap_count += 1
print(f"  ✓ {roadmap_count} roadmaps synced")

# DYNAMIC: Read all ADRs
print("\n5. Scanning ADRs...")
adr_dir = f"{system_root}/memory/tenants/AgentSystem/decisions"
adr_count = 0
if os.path.exists(adr_dir):
    for adr_file in glob.glob(f"{adr_dir}/*.md"):
        adr_name = os.path.basename(adr_file)
        with open(adr_file, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
        messages = [{"role": "user", "content": f"ADR: {adr_name}\n\n{content}"}]
        client.add(messages, user_id=user_id, metadata={"type": "adr", "name": adr_name})
        adr_count += 1
print(f"  ✓ {adr_count} ADRs synced")

# DYNAMIC: Read all learnings
print("\n6. Scanning learnings...")
learnings_dir = f"{system_root}/memory/tenants/AgentSystem/learnings"
learning_count = 0
if os.path.exists(learnings_dir):
    for learning_file in glob.glob(f"{learnings_dir}/*.md"):
        learning_name = os.path.basename(learning_file)
        with open(learning_file, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
        messages = [{"role": "user", "content": f"Learning: {learning_name}\n\n{content}"}]
        client.add(messages, user_id=user_id, metadata={"type": "learning", "file": learning_name})
        learning_count += 1
print(f"  ✓ {learning_count} learnings synced")

# DYNAMIC: Read system configs
print("\n7. Reading system configs...")
config_files = [
    ".meta/system-optimization.json",
    ".meta/priority-scores.json",
    ".meta/tenant-registry.json"
]
config_count = 0
for config_file in config_files:
    config_path = os.path.join(system_root, config_file)
    if os.path.exists(config_path):
        with open(config_path, 'r', encoding='utf-8') as f:
            config = json.load(f)
        messages = [{"role": "user", "content": f"Config: {config_file}\n\n{json.dumps(config, indent=2)}"}]
        client.add(messages, user_id=user_id, metadata={"type": "config", "file": config_file})
        config_count += 1
print(f"  ✓ {config_count} configs synced")

# HARDCODED: External knowledge (not in system files)
print("\n8. Adding external knowledge (hardcoded)...")

# User preferences from conversation
user_prefs = """Krishna's Preferences (from conversations):

Learning Style: Commands-first, doing over reading, needs inline comments
Workflow: ONE BATCH (3-5 commands), wait for results, iterative feedback
Communication: Direct, actionable, copy-paste ready PowerShell blocks
Location: Coimbatore, India (IST timezone)
User ID: krishna_001
Projects: 3 simultaneous (AgentSystem, product-label-bot, arin-bot-v2)

System Expectations:
- Commands executable immediately
- No "or" options (pick best approach)
- Fail gracefully with clear errors
- Track every session for optimization
"""
messages = [{"role": "user", "content": user_prefs}]
client.add(messages, user_id=user_id, metadata={"type": "user_preferences", "source": "conversation"})

# Core principles discussed in thread
core_principles = """Core Principles (from discussion):

1. MEMORY-FIRST ARCHITECTURE:
   Query graph for relevant knowledge before acting
   Memory → LLM intelligence → Execute
   No memory → Search sources → Try solution
   
2. SELF-IMPROVING LOOP:
   SUCCESS: Add to memory as new learning
   FAILURE with memory: Update memory with correction
   Keep memory error-free through continuous refinement
   
3. BATCH-AT-A-TIME WORKFLOW:
   3-5 commands maximum per response
   Wait for execution results
   Iterative: Command → Execute → Results → Next
   
4. GRAPH OVER RAG:
   Better than traditional RAG
   Relationships between memories
   Confidence scoring
   Error correction capability
   
5. EVERYTHING IN MEMORY:
   Not just success - failures, limitations, anti-patterns
   System structure, tools, projects, preferences
   Capabilities AND limitations
   Methods, patterns, examples
"""
messages = [{"role": "user", "content": core_principles}]
client.add(messages, user_id=user_id, metadata={"type": "principles", "source": "discussion"})

# Enhanced examples from conversation
enhanced_examples = """Enhanced Examples (from thread discussion):

Example: Tool Syntax Not Known
LLM: Queries memory for "tool create-adr syntax"
Memory: No result or outdated
LLM: "I need to check the actual syntax. Please run:"
     Get-Help .\\tools\\create-adr.ps1 -Detailed
User: [pastes showing -Project -Title -Status]
LLM: [Provides correct command]
Result: Updates memory with correct syntax

Example: Security Issue Resolution
LLM: Queries memory for ".env file permissions"
Memory: Shows previous failed attempts
LLM: Uses memory + searches for Administrator solution
LLM: [Provides working command with full path to icacls]
Result: SUCCESS - Updates memory with working solution

Example: Perplexity Refusal (learned failure)
LLM: Sends v3.1 init prompt
Perplexity: Refuses (sees as "roleplay")
Learning: Reframe as real project, user preference, not roleplay
LLM: Sends v4.0 reframed prompt
Perplexity: Accepts and provides commands
Result: Memory updated with correct framing approach
"""
messages = [{"role": "user", "content": enhanced_examples}]
client.add(messages, user_id=user_id, metadata={"type": "examples", "source": "thread_learnings"})

# Known limitations from experience
limitations = """Known Limitations (from experience):

PowerShell:
- icacls not in PATH (use C:\\Windows\\System32\\icacls.exe)
- Administrator required for security descriptor changes
- Parameter naming varies (-Number vs -MilestoneId vs -MilestoneNumber)

Mem0 Platform:
- Uses MemoryClient() not Memory() for platform
- 50,000 API calls/month limit (Pro plan)
- Requires MEM0_API_KEY environment variable

Perplexity LLM:
- Rejects "roleplay" framing
- May violate batch rule (gives 10+ commands)
- Needs explicit "real project" context

Integration:
- PowerShell → Python → paste results flow required
- Cannot directly query Mem0 from LLM (user intermediary)
- Line ending issues (CRLF vs LF) in git
"""
messages = [{"role": "user", "content": limitations}]
client.add(messages, user_id=user_id, metadata={"type": "limitations", "source": "experienced"})

print("  ✓ External knowledge added")

print("\n" + "="*60)
print("SMART SYNC COMPLETE")
print("="*60)
print(f"\nSynced from system files:")
print(f"  ✓ {tool_count} tools")
print(f"  ✓ {roadmap_count} roadmaps")
print(f"  ✓ {adr_count} ADRs")
print(f"  ✓ {learning_count} learnings")
print(f"  ✓ {config_count} configs")
print(f"\nAdded external knowledge:")
print(f"  ✓ User preferences")
print(f"  ✓ Core principles")
print(f"  ✓ Enhanced examples")
print(f"  ✓ Known limitations")
print("\nMemory now dynamically reflects actual system state!")


