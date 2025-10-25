from dotenv import load_dotenv
load_dotenv()
from mem0 import MemoryClient

client = MemoryClient()
results = client.search('command execution protocol one command response strict rules', filters={'user_id': 'AgentSystem'})

for m in results.get('results', []):
    print(f"ID: {m['id']}")
    print(f"Memory: {m['memory']}")
    print("-" * 50)
