from dotenv import load_dotenv
load_dotenv()
from mem0 import MemoryClient

client = MemoryClient()
# Get the specific memory details
results = client.get_all(filters={'user_id': 'AgentSystem'})

# Find and display the strict protocols memory
for m in results.get('results', []):
    if m['id'] == '882f895d-e3ff-460e-9e98-487cd0a5affd':
        print(f"ID: {m['id']}")
        print(f"Memory: {m['memory']}")
        if 'metadata' in m:
            print(f"Metadata: {m['metadata']}")
        print('=' * 60)
