# Create new Architecture Decision Record
param(
    [Parameter(Mandatory=$true)]
    [string]$Project,
    
    [Parameter(Mandatory=$true)]
    [string]$Title,
    
    [string]$Status = "Proposed"
)

# Get user info
$users = Get-Content ".meta\users.json" | ConvertFrom-Json
$primaryUser = $users.users | Where-Object { $_.id -eq $users.primary_user }

# Determine next ADR number
$projectPath = if ($Project -eq "AgentSystem") { 
    ".\memory\tenants\AgentSystem\decisions" 
} else { 
    ".\memory\tenants\$Project\decisions" 
}

$existingAdrs = Get-ChildItem $projectPath -Filter "*.md" -ErrorAction SilentlyContinue
$nextNumber = ($existingAdrs.Count + 1).ToString("000")

# Create from template
$template = Get-Content ".\decisions\templates\adr-template.md" -Raw
$adr = $template -replace "ADR-XXX", "ADR-$nextNumber"
$adr = $adr -replace "\[Decision Title\]", $Title
$adr = $adr -replace "YYYY-MM-DD", (Get-Date -Format "yyyy-MM-dd")
$adr = $adr -replace "\[Proposed \| Accepted \| Deprecated \| Superseded\]", $Status
$adr = $adr -replace "\[List of people involved\]", $primaryUser.name
$adr = $adr -replace "\[Project owner\]", $primaryUser.id

# Save
$filename = "$projectPath\$nextNumber-$($Title -replace '\s', '-' -replace '[^\w-]', '').md"
$adr | Out-File $filename -Encoding UTF8

Write-Output "✓ Created: $filename"
Write-Output "`nEdit the file to complete the ADR"
