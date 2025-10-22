# AgentSystem v3.1 - Memory-First Start Session
param(
    [string]$ProjectFocus = "AgentSystem",
    [string]$Intent = "general"
)

Write-Host "=== STARTING SESSION (v3.1 Memory-First) ===" -ForegroundColor Cyan

# Initialize session
$env:SESSION_ID = "session_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
$env:SESSION_START = Get-Date
Write-Host "Session ID: $env:SESSION_ID"
Write-Host "Intent: $Intent"
Write-Host "Project: $ProjectFocus`n"

# Load evolved template
$template = Get-Content ".\init_prompt_v3.1_template.txt" -Raw

# Replace placeholders
$initPrompt = $template -replace '{SESSION_ID}', $env:SESSION_ID
$initPrompt = $initPrompt -replace '{INTENT}', $Intent

# Copy to clipboard
$initPrompt | Set-Clipboard

# Show what's different
Write-Host "✓ Evolved init copied to clipboard" -ForegroundColor Green
Write-Host "  Template: v3.1 (Memory-First)"
Write-Host "  Size: 0.75 KB (59% smaller than v4.0)"
Write-Host "  Focus: Query mem0 for instructions`n"

# Rotational protocol reminder
$protocols = @(
    "Batch Rule: Provide 3-5 commands maximum per response",
    "Memory-First: Query mem0 before creating any files",
    "Predictive Context: After each step, predict next + query context",
    "Transparency: Always explain what you loaded and why",
    "Task Continuity: Check for incomplete tasks before starting new ones"
)

$protocolIndex = (Get-Date).Minute % $protocols.Count
Write-Host "📌 CRITICAL PROTOCOL #$($protocolIndex + 1):" -ForegroundColor Yellow
Write-Host "   $($protocols[$protocolIndex])" -ForegroundColor Yellow
Write-Host "   → You MUST acknowledge this in your first response`n" -ForegroundColor Gray

Write-Host "=== NEXT STEPS ===" -ForegroundColor Cyan
Write-Host "1. Open NEW Perplexity thread"
Write-Host "2. Paste clipboard content"
Write-Host "3. AI queries mem0 for instructions"
Write-Host "4. AI acknowledges protocol reminder`n"

Write-Host "✓ Session ready!" -ForegroundColor Green
