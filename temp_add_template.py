from dotenv import load_dotenv
load_dotenv()
from mem0 import MemoryClient

client = MemoryClient()

# First, check if query template already exists
existing = client.search('session initialization query template', filters={'user_id': 'AgentSystem'})

if existing.get('results'):
    print("Query template already exists. Skipping creation.")
    print(f"Found: {existing['results'][0]['memory']}")
else:
    # Only add if it doesn't exist
    result = client.add(
        messages=[{
            'role': 'system',
            'content': 'Session initialization standard query: Search for project_name current_milestone active_tasks pending_issues last_session_outcome established_protocols. This query template runs at every session start to load context.'
        }],
        user_id='AgentSystem',
        metadata={
            'type': 'query_template',
            'trigger': 'session_start',
            'version': '1.0',
            'date': '2025-10-23'
        }
    )
    print("Query Template Added Successfully!")
    print(f"Result: {result}")
