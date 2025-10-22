# AgentSystem v4.0 - Graph-Powered Start Session
param(
    [string]$ProjectFocus = "AgentSystem",
    [string]$Intent = "general"
)

Write-Output "=== STARTING SESSION (v4.0 Graph-Powered) ==="

# Initialize session
$env:SESSION_ID = "session_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
$env:SESSION_START = Get-Date
Write-Output "Session ID: $env:SESSION_ID"
Write-Output "Intent: $Intent"
Write-Output "Project: $ProjectFocus"
Write-Output ""

# Load template
$template = Get-Content ".\init_prompt_v4.0_template.txt" -Raw

# Replace placeholders
$initPrompt = $template -replace '{SESSION_ID}', $env:SESSION_ID
$initPrompt = $initPrompt -replace '{INTENT}', $Intent

# Save with timestamp
$timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$promptPath = ".\init_prompt_v4.0_$timestamp.txt"
$initPrompt | Out-File $promptPath -Encoding UTF8

# Copy to clipboard
$initPrompt | Set-Clipboard

# Show summary
$size = [math]::Round((Get-Item $promptPath).Length / 1KB, 2)

Write-Output "✓ Init prompt generated (v4.0)"
Write-Output "   File: $promptPath"
Write-Output "   Size: $size KB (minimal - queries graph on-demand)"
Write-Output ""
Write-Output "✓ Copied to clipboard"
Write-Output ""
Write-Output "=== SESSION READY ==="
Write-Output ""
Write-Output "Next steps:"
Write-Output "  1. Open NEW Perplexity thread"
Write-Output "  2. Paste clipboard content"
Write-Output "  3. LLM will request Mem0 queries as needed"
Write-Output "  4. Run: .\tools\query-mem0.ps1 -Query '...'"
Write-Output "  5. Paste results, get commands"
Write-Output ""
Write-Output "v4.0: On-demand graph memory - zero token waste!"
