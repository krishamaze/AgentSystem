# Git Auto-Commit Script
# Usage: .\commit-session.ps1 -Message "Your message"

param(
    [Parameter(Mandatory=$false)]
    [string]$Message = "Session 2025-10-25 17:30 IST - Auto-commit"
)

Write-Host "=== AUTO-COMMITTING AGENTSYSTEM ===" -ForegroundColor Cyan
cd D:\AgentSystem

# Stage all changes
git add -A

# Check if there are changes to commit
$status = git status --porcelain
if ($status) {
    git commit -m "$Message"
    Write-Host "✅ AgentSystem committed" -ForegroundColor Green
    
    # Optional: Push to remote (uncomment when ready)
    # git push origin main
} else {
    Write-Host "⚠️  No changes in AgentSystem" -ForegroundColor Yellow
}

Write-Host "
=== AUTO-COMMITTING PRODUCT-LABEL-BOT ===" -ForegroundColor Cyan
cd D:\product-label-bot

# Stage all changes
git add -A

# Check if there are changes
$status = git status --porcelain
if ($status) {
    git commit -m "$Message"
    Write-Host "✅ product-label-bot committed" -ForegroundColor Green
    
    # Optional: Push to remote (uncomment when ready)
    # git push origin main
} else {
    Write-Host "⚠️  No changes in product-label-bot" -ForegroundColor Yellow
}

Write-Host "
✅ Git auto-commit complete" -ForegroundColor Green
