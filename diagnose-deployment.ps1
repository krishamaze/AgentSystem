Write-Output "=== SUPABASE DEPLOYMENT DIAGNOSTICS ==="

# Check Supabase CLI
Write-Output "`n1. Supabase CLI:"
$cliVersion = supabase --version 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Output "✓ Installed: $cliVersion"
} else {
    Write-Output "✗ Not installed"
}

# Check if logged in
Write-Output "`n2. Supabase Auth:"
cd supabase
$authCheck = supabase projects list 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Output "✓ Authenticated"
    Write-Output $authCheck
} else {
    Write-Output "✗ Not authenticated"
    Write-Output $authCheck
}

# Check if linked to project
Write-Output "`n3. Project Link:"
if (Test-Path ".\.supabase\config.toml") {
    Write-Output "✓ Config exists"
    $projectRef = supabase status 2>&1 | Select-String "Project ref"
    Write-Output $projectRef
} else {
    Write-Output "✗ Not linked to project"
}

# Try manual deploy with verbose
Write-Output "`n4. Attempting deployment with verbose output:"
supabase functions deploy get-agent-memory --project-ref fihvhtoqviivmasjaqxc 2>&1

cd ..
