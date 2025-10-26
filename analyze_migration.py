"""
Memory Migration Tool - AgentSystem
Analyzes current memories and prepares migration plan
PHASE 1: Analysis only (no actual migration)
"""
from dotenv import load_dotenv
load_dotenv()

from mem0 import MemoryClient
import json
from collections import defaultdict

def analyze_memories():
    client = MemoryClient()
    
    print("=== Memory Migration Analysis ===\n")
    
    # Fetch all memories
    print("[1/4] Fetching current memories...")
    try:
        memories = client.search(
            query="",
            filters={"user_id": "AgentSystem"},
            limit=1000
        )
        results = memories.get('results', [])
        print(f"✓ Total memories: {len(results)}\n")
        
        # Analyze project distribution
        print("[2/4] Analyzing project distribution...")
        project_mentions = defaultdict(int)
        
        for mem in results:
            content = mem.get('memory', '').lower()
            
            # Count project mentions
            if 'product-label-bot' in content or 'productlabelbot' in content:
                project_mentions['product-label-bot'] += 1
            elif 'arin-bot-v2' in content or 'arinbot' in content:
                project_mentions['arin-bot-v2'] += 1
            elif 'agentsystem' in content:
                project_mentions['AgentSystem'] += 1
            else:
                project_mentions['unclear'] += 1
        
        print("\nProject Distribution (by content analysis):")
        for project, count in sorted(project_mentions.items()):
            pct = (count / len(results)) * 100
            print(f"  - {project}: {count} ({pct:.1f}%)")
        
        # Analyze metadata usage
        print("\n[3/4] Analyzing metadata patterns...")
        metadata_keys = defaultdict(int)
        memories_with_metadata = 0
        
        for mem in results:
            meta = mem.get('metadata', {})
            if meta:
                memories_with_metadata += 1
                for key in meta.keys():
                    metadata_keys[key] += 1
        
        print(f"\nMemories with metadata: {memories_with_metadata}/{len(results)} ({memories_with_metadata/len(results)*100:.1f}%)")
        if metadata_keys:
            print("Metadata keys found:")
            for key, count in sorted(metadata_keys.items()):
                print(f"  - {key}: {count}")
        else:
            print("No metadata found in existing memories")
        
        # Migration recommendations
        print("\n[4/4] Migration Recommendations...")
        print("\nRecommended Actions:")
        print(f"  1. Create backup first (run backup_memories.py)")
        print(f"  2. Migrate {project_mentions.get('product-label-bot', 0)} memories → user_id='product-label-bot'")
        print(f"  3. Migrate {project_mentions.get('arin-bot-v2', 0)} memories → user_id='arin-bot-v2'")
        print(f"  4. Keep {project_mentions.get('AgentSystem', 0)} memories in user_id='AgentSystem'")
        print(f"  5. Review {project_mentions.get('unclear', 0)} unclear memories manually")
        print(f"\n  Note: Current analysis based on content keywords")
        print(f"  For precise migration, manual review recommended for 'unclear' items")
        
        print("\n=== Analysis Complete ===")
        
    except Exception as e:
        print(f"✗ Analysis failed: {e}")

if __name__ == "__main__":
    analyze_memories()
