# Memory-First Protocol - Check before assuming
param(
    [string]$Project,
    [string]$Query
)

if (-not $Project -or -not $Query) {
    Write-Output "Usage: .\tools\check-memory.ps1 -Project <name> -Query <what to check>"
    exit
}

Write-Output "=== MEMORY CHECK: $Project - $Query ==="

# 1. Check project context
Write-Output "`n1. Project Context:"
$contextPath = ".\Projects\$Project\context.md"
if (Test-Path $contextPath) {
    Get-Content $contextPath | Select-String -Pattern $Query -Context 2
} else {
    Write-Output "   No context found"
}

# 2. Check project progress
Write-Output "`n2. Project Progress:"
$progressPath = ".\Projects\$Project\progress.json"
if (Test-Path $progressPath) {
    $progress = Get-Content $progressPath | ConvertFrom-Json
    $progress.Milestones | Where-Object { $_.Name -like "*$Query*" } | ForEach-Object {
        Write-Output "   Milestone: $($_.Name) - $($_.Status)"
    }
}

# 3. Check decisions (ADRs)
Write-Output "`n3. Decision Records (ADRs):"
$registry = Get-Content ".\decisions\adr-registry.json" | ConvertFrom-Json
$proj = $registry.projects.$Project
if ($proj -and $proj.count -gt 0) {
    foreach ($adr in $proj.adrs) {
        Write-Output "   ADR-$($adr.id): $($adr.title) [$($adr.status)]"
    }
} else {
    Write-Output "   No ADRs found (use .\tools\create-adr.ps1 to create)"
}
Write-Output ""

# 3a. OLD ADR check (keep for compatibility)
Write-Output "`n3. Decision Records:"
$adrPath = ".\memory\tenants\$Project\decisions"
if (Test-Path $adrPath) {
    Get-ChildItem $adrPath -Filter "*.md" | ForEach-Object {
        if ((Get-Content $_.FullName) -match $Query) {
            Write-Output "   Found in: $($_.Name)"
        }
    }
} else {
    Write-Output "   No ADRs found (system needs ADR implementation)"
}

# 4. Query mem0 graph memory
Write-Output "`n4. Graph Memory (mem0):"
python -c @"
from mem0 import Memory
import os
import sys
sys.stdout.reconfigure(encoding='utf-8')

try:
    m = Memory()
    query = f'$Project $Query'
    results = m.search(query, user_id='agent_primary', limit=5)
    
    if results:
        for r in results:
            print(f'   - {r.get(\"memory\", r)}')
    else:
        print('   No memories found')
except Exception as e:
    print(f'   Error: {e}')
"@

Write-Output "`n5. Recommendation:"
Write-Output "   If no memories found above, ASK USER directly"
Write-Output "   DO NOT ASSUME or implement blindly"

