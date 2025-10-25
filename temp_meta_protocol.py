from dotenv import load_dotenv
load_dotenv()
from mem0 import MemoryClient

client = MemoryClient()

# Check if self-improvement protocol exists
existing = client.search('self-improvement meta-protocol memory evolution', filters={'user_id': 'AgentSystem'})

if existing.get('results'):
    print("Self-improvement protocol already exists. Skipping.")
    print(f"Found: {existing['results'][0]['memory']}")
else:
    # Add the meta-learning protocol
    result = client.add(
        messages=[{
            'role': 'system',
            'content': 'Self-Improvement Protocol: Before adding new memories, search if similar exists. Track execution patterns: command efficiency, cycles per task, user corrections. After significant tasks, reflect and update relevant protocol memories with learnings. When encountering contradictions in memory, prioritize recent timestamps and query user for clarification. Memory hygiene: consolidate duplicate information, delete obsolete entries, maintain searchable structure.'
        }],
        user_id='AgentSystem',
        metadata={
            'type': 'meta_protocol',
            'category': 'self_improvement',
            'version': '1.0',
            'date': '2025-10-23',
            'authority_level': 'system_core'
        }
    )
    print("Self-Improvement Protocol Added!")
    print(f"Result: {result}")
