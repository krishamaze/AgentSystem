# -*- coding: utf-8 -*-
import sys
import os
from pathlib import Path
from datetime import datetime, timezone
from dotenv import load_dotenv

sys.stdout.reconfigure(encoding="utf-8")
load_dotenv()

from supabase import create_client

client = create_client(
    os.getenv('SUPABASE_URL'),
    os.getenv('SUPABASE_SERVICE_ROLE_KEY')
)

agents = ['Agent_Primary', 'Agent_Agent_Architect', 'Agent_CodeAssist']
total_synced = 0

for agent in agents:
    knowledge_file = Path(f"./{agent}/brain/learned-knowledge.md")
    
    if not knowledge_file.exists():
        continue
    
    content = knowledge_file.read_text(encoding='utf-8')
    sections = [s.strip() for s in content.split('\n\n') if s.strip() and len(s.strip()) > 50]
    
    print(f"{agent}: {len(sections)} sections found")
    
    for i, section in enumerate(sections[:3], 1):  # Limit to 3 per agent
        try:
            # Extract title from section (first line)
            lines = section.split('\n')
            title = lines[0].replace('#', '').strip()[:100]
            
            data = {
                'user_id': '00000000-0000-0000-0000-000000000000',
                'category': 'knowledge',
                'title': title,
                'content': section[:1000],
                'tags': [agent.lower(), 'perplexity_sync'],
                'metadata': {'source': 'brain_sync', 'agent': agent},
                'created_at': datetime.now(timezone.utc).isoformat()
            }
            
            result = client.table('learnings').insert(data).execute()
            total_synced += 1
            print(f"  Synced: {title[:50]}...")
            
        except Exception as e:
            print(f"  ERROR: {str(e)[:100]}")

print(f"\nTotal synced: {total_synced} learnings")
