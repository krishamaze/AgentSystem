from dotenv import load_dotenv
load_dotenv()
from mem0 import MemoryClient

client = MemoryClient()

# Update the strict protocols memory with improved rules
result = client.update(
    memory_id='882f895d-e3ff-460e-9e98-487cd0a5affd',
    text='AgentSystem Command Execution Protocol v2.0: Execute batch operations when tasks are independent and parallelizable. Use sequential execution only when outputs feed into subsequent operations. Memory-first discipline maintained: query memory before asking questions. Make decisions autonomously as senior technical partner. Protocol rules are now updatable memories retrieved at session start.'
)

print("Protocol Updated Successfully!")
print(f"Result: {result}")
