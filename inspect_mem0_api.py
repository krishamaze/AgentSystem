from dotenv import load_dotenv
load_dotenv()

from mem0 import MemoryClient
import inspect

print("=== Mem0 MemoryClient API Surface ===\n")

client = MemoryClient()

# List all public methods
methods = [m for m in dir(client) if not m.startswith('_')]
print(f"Available methods ({len(methods)}):")
for method in methods:
    attr = getattr(client, method)
    if callable(attr):
        sig = inspect.signature(attr)
        print(f"  - {method}{sig}")
    else:
        print(f"  - {method} (attribute)")

print("\n=== Testing Graph/Metadata Capabilities ===")

# Test if metadata/tags supported in add()
try:
    add_sig = inspect.signature(client.add)
    print(f"\nadd() signature: {add_sig}")
    print(f"add() parameters: {list(add_sig.parameters.keys())}")
except Exception as e:
    print(f"Error inspecting add(): {e}")

# Test if search supports advanced filtering
try:
    search_sig = inspect.signature(client.search)
    print(f"\nsearch() signature: {search_sig}")
    print(f"search() parameters: {list(search_sig.parameters.keys())}")
except Exception as e:
    print(f"Error inspecting search(): {e}")

print("\n=== Configuration Inspection ===")
print(f"Client type: {type(client)}")
print(f"Client attributes: {[a for a in dir(client) if not a.startswith('_')][:15]}")
