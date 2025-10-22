# Query Mem0 Graph - v4.0
param(
    [Parameter(Mandatory=$true)]
    [string]$Query,
    [int]$Limit = 5
)

Write-Output "=== Mem0 Graph Query ==="
Write-Output "Query: $Query"
Write-Output "Limit: $Limit"
Write-Output ""

$pythonCode = @"
from mem0 import Memory
import json

m = Memory()
results = m.search('$Query', user_id='krishna_001', limit=$Limit)

if not results:
    print('No results found for this query.')
else:
    for i, result in enumerate(results, 1):
        print(f'--- Result {i}/{len(results)} ---')
        print(result.get('memory', ''))
        
        # Show metadata if available
        metadata = result.get('metadata', {})
        if metadata:
            print(f'\nMetadata: {json.dumps(metadata, indent=2)}')
        print()
"@

python -c $pythonCode
