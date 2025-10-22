# -*- coding: utf-8 -*-
import sys
import json
from websocket import create_connection

sys.stdout.reconfigure(encoding="utf-8")

print("Testing WebSocket Bridge...\n")

try:
    ws = create_connection("ws://localhost:8080")
    print("Connected to ws://localhost:8080")
    
    # Send test message
    test_msg = {
        "type": "test",
        "content": "Hello from Python test script",
        "timestamp": "2025-10-21T21:55:00"
    }
    
    ws.send(json.dumps(test_msg))
    print(f"Sent: {test_msg}")
    
    # Wait for response (with timeout)
    ws.settimeout(5)
    result = ws.recv()
    print(f"Received: {result}")
    
    ws.close()
    print("\nWebSocket test: SUCCESS")
    
except ConnectionRefusedError:
    print("ERROR: Connection refused. Is the server running?")
    print("Start server with: node server.js")
except Exception as e:
    print(f"ERROR: {str(e)}")
