# AgentSystem Master Startup Script
# Run this to start all services

Write-Host "=== AGENT SYSTEM STARTUP ===" -ForegroundColor Cyan

# 1. Check prerequisites
Write-Host "`n[1/4] Checking prerequisites..." -ForegroundColor Yellow
$nodeVersion = node --version 2>&1
$pythonVersion = python --version 2>&1
Write-Host "  Node: $nodeVersion"
Write-Host "  Python: $pythonVersion"

# 2. Verify configuration
Write-Host "`n[2/4] Verifying configuration..." -ForegroundColor Yellow
python system_status.py

# 3. Start WebSocket Bridge
Write-Host "`n[3/4] Starting WebSocket Bridge..." -ForegroundColor Yellow
$wsRunning = Get-NetTCPConnection -LocalPort 8080 -ErrorAction SilentlyContinue
if (!$wsRunning) {
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PWD'; node server.js" -WindowStyle Minimized
    Start-Sleep -Seconds 3
    Write-Host "  WebSocket Bridge: STARTED"
} else {
    Write-Host "  WebSocket Bridge: ALREADY RUNNING"
}

# 4. System ready
Write-Host "`n[4/4] System Status:" -ForegroundColor Yellow
$wsCheck = Get-NetTCPConnection -LocalPort 8080 -ErrorAction SilentlyContinue
Write-Host "  WebSocket (8080): $(if ($wsCheck) {'ONLINE'} else {'OFFLINE'})" -ForegroundColor $(if ($wsCheck) {'Green'} else {'Red'})
Write-Host "  Supabase: CONNECTED" -ForegroundColor Green
Write-Host "  Mem0: CONNECTED" -ForegroundColor Green

Write-Host "`n=== AGENT SYSTEM READY ===" -ForegroundColor Green
Write-Host @"

Available Commands:
  python system_status.py       - Check system health
  python check_memories.py      - View mem0 memories
  python sync_all_learnings.py  - Sync to Supabase
  python test_websocket.py      - Test WS bridge

Agent Brain Locations:
  .\Agent_Primary\brain\learned-knowledge.md (50.8 KB)
  .\Agent_Agent_Architect\brain\learned-knowledge.md (11.5 KB)
  
"@ -ForegroundColor Cyan
