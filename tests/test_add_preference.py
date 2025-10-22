from dotenv import load_dotenv
from mem0 import MemoryClient

load_dotenv()
client = MemoryClient()

# Add preferences as conversation
messages = [
    {
        "role": "user",
        "content": "I prefer explanations in the chat thread, not just in PowerShell output. I also prefer working one step at a time, one test at a time, one action at a time. This helps me understand better."
    },
    {
        "role": "assistant", 
        "content": "Got it! I'll provide detailed explanations here in the thread and work one step at a time with you, Krishna."
    }
]

result = client.add(messages, user_id="AgentSystem", metadata={"type": "user_preference"})
event_id = result["results"][0].get("event_id")
print(f"Preference saved! Event ID: {event_id}")
print("Processing in background (~30s)...")
