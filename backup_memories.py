"""
Memory Backup Tool - AgentSystem
Creates complete backup of current memories before migration
"""
from dotenv import load_dotenv
load_dotenv()

from mem0 import MemoryClient
import json
from pathlib import Path
from datetime import datetime

def backup_memories():
    client = MemoryClient()
    backup_dir = Path("D:/AgentSystem/.meta/memory_backups")
    backup_dir.mkdir(parents=True, exist_ok=True)
    
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_file = backup_dir / f"backup_{timestamp}.json"
    
    print(f"=== Memory Backup Tool ===\n")
    print(f"Backup file: {backup_file}")
    
    # Get all memories for AgentSystem user_id
    print("\n[1/3] Fetching all AgentSystem memories...")
    try:
        # Use filters to avoid 400 error
        memories = client.search(
            query="",  # Empty query returns all
            filters={"user_id": "AgentSystem"},
            limit=1000  # Adjust if more memories exist
        )
        results = memories.get('results', [])
        print(f"✓ Found {len(results)} memories")
        
        # Save backup
        print("\n[2/3] Saving backup...")
        backup_data = {
            "timestamp": timestamp,
            "user_id": "AgentSystem",
            "total_memories": len(results),
            "memories": results
        }
        
        with open(backup_file, 'w', encoding='utf-8') as f:
            json.dump(backup_data, f, indent=2, ensure_ascii=False)
        
        print(f"✓ Backup saved: {backup_file}")
        print(f"  Size: {backup_file.stat().st_size / 1024:.2f} KB")
        
        # Create metadata summary
        print("\n[3/3] Creating metadata summary...")
        metadata_counts = {}
        for mem in results:
            meta = mem.get('metadata', {})
            for key in meta.keys():
                metadata_counts[key] = metadata_counts.get(key, 0) + 1
        
        summary_file = backup_dir / f"summary_{timestamp}.txt"
        with open(summary_file, 'w', encoding='utf-8') as f:
            f.write(f"Backup Summary - {timestamp}\n")
            f.write(f"{'='*50}\n\n")
            f.write(f"Total Memories: {len(results)}\n")
            f.write(f"User ID: AgentSystem\n\n")
            f.write(f"Metadata Fields Found:\n")
            for key, count in sorted(metadata_counts.items()):
                f.write(f"  - {key}: {count} memories\n")
        
        print(f"✓ Summary saved: {summary_file}")
        print(f"\n=== Backup Complete ===")
        print(f"Backup location: {backup_dir}")
        
        return backup_file
        
    except Exception as e:
        print(f"✗ Backup failed: {e}")
        return None

if __name__ == "__main__":
    backup_memories()
