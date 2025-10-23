# AgentSystem - Start Session v3.1 (Multi-Platform)
param(
    [string]$Intent = "general",
    [string]$ProjectFocus = "AgentSystem",
    [switch]$Perplexity  # New flag for Perplexity compatibility
)

Write-Host "=== STARTING SESSION (v3.1) ===" -ForegroundColor Cyan

$env:SESSION_ID = "session_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
Write-Host "Session ID: $env:SESSION_ID"
Write-Host "Intent: $Intent"
Write-Host "Platform: $(if($Perplexity){'Perplexity AI'}else{'Local Agent'})`n"

if ($Perplexity) {
    # Generate Perplexity-compatible init with pre-loaded context
    Write-Host "Generating Perplexity init with pre-loaded mem0 context..." -ForegroundColor Yellow
    python generate_perplexity_init.py
    
    $initPrompt = Get-Content "init_prompt_v3.1_perplexity.txt" -Raw
    Write-Host "✓ Context-rich init generated ($(($initPrompt.Length)) bytes)" -ForegroundColor Green
} else {
    # Use minimal template for local agents
    $template = Get-Content ".\init_prompt_v3.1_template.txt" -Raw
    $initPrompt = $template -replace '{SESSION_ID}', $env:SESSION_ID
    $initPrompt = $initPrompt -replace '{INTENT}', $Intent
    Write-Host "✓ Minimal init loaded (500 bytes)" -ForegroundColor Green
}

# Copy to clipboard
$initPrompt | Set-Clipboard

Write-Host "`n=== NEXT STEPS ===" -ForegroundColor Cyan
Write-Host "1. Open NEW thread (Perplexity/ChatGPT/Claude)"
Write-Host "2. Paste clipboard content"
Write-Host "3. AI will start with pre-loaded context`n"

Write-Host "✓ Session ready!" -ForegroundColor Green
