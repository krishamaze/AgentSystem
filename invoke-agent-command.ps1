# invoke-agent-command.ps1 - Structured Command Protocol v2.0
# Enforces memory-first, contextual, documented execution

param(
    [Parameter(Mandatory=$true)]
    [string]$Command,                    # The actual command to execute
    
    [Parameter(Mandatory=$true)]
    [string]$Task,                       # What are we doing? (human readable)
    
    [Parameter(Mandatory=$false)]
    [hashtable]$Context = @{},           # project, phase, dependencies
    
    [Parameter(Mandatory=$false)]
    [string]$MemoryQuery = "",           # Query for related memories
    
    [Parameter(Mandatory=$false)]
    [switch]$AutoFetch,                  # Auto-fetch related files from memory
    
    [Parameter(Mandatory=$false)]
    [switch]$SaveLearnings,              # Save result to Mem0
    
    [Parameter(Mandatory=$false)]
    [switch]$UpdateIndex                 # Update system index if files changed
)

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$sessionId = if($env:SESSION_ID){$env:SESSION_ID}else{"session_$(Get-Date -Format 'yyyyMMdd_HHmmss')"

# ===== PHASE 1: PRE-EXECUTION (CHECK) =====
Write-Host "`n+-----------------------------------------------------------+" -ForegroundColor Cyan
Write-Host "¦  STRUCTURED COMMAND EXECUTION                             ¦" -ForegroundColor Cyan
Write-Host "+-----------------------------------------------------------+" -ForegroundColor Cyan

Write-Host "`n[1/6] TASK DEFINITION" -ForegroundColor Yellow
Write-Host "  Task: $Task"
Write-Host "  Command: $Command"
Write-Host "  Project: $(if($Context.project){$Context.project}else{'N/A'})"
Write-Host "  Phase: $(if($Context.phase){$Context.phase}else{'N/A'})"

# Log command
$logEntry = @{
    timestamp = $timestamp
    session_id = $sessionId
    task = $Task
    command = $Command
    context = $Context
} | ConvertTo-Json -Compress
Add-Content -Path ".\.meta\command-history.jsonl" -Value $logEntry

# ===== PHASE 2: MEMORY QUERY (CHECK) =====
Write-Host "`n[2/6] MEMORY RETRIEVAL" -ForegroundColor Yellow
$relatedMemories = @()
if ($MemoryQuery -and (Test-Path ".\list_memories.py")) {
    try {
        Write-Host "  Querying Mem0: '$MemoryQuery'..."
        # Use get_all and filter locally (since search requires complex filters)
        $memResult = python -c @"
from mem0 import MemoryClient
import os
from dotenv import load_dotenv
load_dotenv()
client = MemoryClient(api_key=os.getenv('MEM0_API_KEY'))
try:
    all_mems = client.get_all(user_id='agent_primary')
    query_terms = '$MemoryQuery'.lower().split()
    matches = [m for m in all_mems if any(term in m.get('memory','').lower() for term in query_terms)]
    for i, mem in enumerate(matches[:5], 1):
        print(f"{i}. {mem.get('memory', 'N/A')[:120]}")
except: pass
"@
        $relatedMemories = $memResult
        if ($relatedMemories) {
            Write-Host "  ? Found $($relatedMemories.Count) related memories"
            $relatedMemories | ForEach-Object { Write-Host "    $_" -ForegroundColor Gray }
        } else {
            Write-Host "  No related memories found" -ForegroundColor Gray
        }
    } catch {
        Write-Host "  ? Memory query failed: $_" -ForegroundColor Yellow
    }
}

# ===== PHASE 3: FILE DISCOVERY (CHECK) =====
Write-Host "`n[3/6] FILE DISCOVERY" -ForegroundColor Yellow
$relatedFiles = @()
if ($AutoFetch -and $Context.project) {
    $projectPath = ".\Projects\$($Context.project)"
    if (Test-Path $projectPath) {
        Write-Host "  Auto-fetching files from: $projectPath"
        $relatedFiles = Get-ChildItem $projectPath -File -Recurse | 
                        Where-Object { $_.Extension -in @('.md', '.json', '.ts', '.js', '.py', '.ps1') } | 
                        Select-Object -First 10
        $relatedFiles | ForEach-Object { Write-Host "    - $($_.Name)" -ForegroundColor Gray }
    }
}

# ===== PHASE 4: EXECUTION (APPLY) =====
Write-Host "`n[4/6] COMMAND EXECUTION" -ForegroundColor Green
Write-Host "  Executing: $Command"
$executionStart = Get-Date
try {
    Invoke-Expression $Command
    $exitCode = if($LASTEXITCODE){$LASTEXITCODE}else{0}
    $executionTime = ((Get-Date) - $executionStart).TotalSeconds
    Write-Host "  ? Command completed in $($executionTime)s (exit: $exitCode)" -ForegroundColor Green
} catch {
    $exitCode = 1
    $executionTime = ((Get-Date) - $executionStart).TotalSeconds
    Write-Host "  ? Command failed: $_" -ForegroundColor Red
}

# ===== PHASE 5: LEARNING CAPTURE (GRIND) =====
Write-Host "`n[5/6] LEARNING CAPTURE" -ForegroundColor Yellow
if ($SaveLearnings -and (Test-Path ".\add_memory.py")) {
    $learning = "Task: $Task | Command: $Command | Result: $(if($exitCode -eq 0){'SUCCESS'}else{'FAILED'}) | Time: $($executionTime)s | Project: $($Context.project)"
    try {
        python add_memory.py "$learning"
        Write-Host "  ? Learning saved to Mem0" -ForegroundColor Green
    } catch {
        Write-Host "  ? Failed to save learning: $_" -ForegroundColor Yellow
    }
}

# ===== PHASE 6: INDEX UPDATE (GRIND) =====
Write-Host "`n[6/6] SYSTEM MAINTENANCE" -ForegroundColor Yellow
if ($UpdateIndex) {
    Write-Host "  Checking for file changes..."
    # Simple check: if command modified files, update index
    if ($Command -match "Out-File|Set-Content|New-Item") {
        Write-Host "  ? File modification detected, updating index"
        # TODO: Trigger index rebuild (future enhancement)
    } else {
        Write-Host "  No index update needed" -ForegroundColor Gray
    }
}

Write-Host "`n+-----------------------------------------------------------+" -ForegroundColor Cyan
Write-Host "¦  EXECUTION COMPLETE                                       ¦" -ForegroundColor Cyan
Write-Host "+-----------------------------------------------------------+" -ForegroundColor Cyan
Write-Host "  Task: $Task"
Write-Host "  Status: $(if($exitCode -eq 0){'? SUCCESS'}else{'? FAILED'})"
Write-Host "  Duration: $($executionTime)s"
Write-Host "  Memories: $($relatedMemories.Count) retrieved"
Write-Host "  Files: $($relatedFiles.Count) discovered"
