Write-Output "=== FIXING SUPABASE DEPLOYMENT ==="

# Link to project
Write-Output "`n1. Linking to project fihvhtoqviivmasjaqxc..."
cd supabase
supabase link --project-ref fihvhtoqviivmasjaqxc 2>&1
cd ..

# Deploy from ROOT directory (not from inside supabase folder)
Write-Output "`n2. Deploying edge function from root..."
supabase functions deploy get-agent-memory --project-ref fihvhtoqviivmasjaqxc 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Output "`n✓ Deployment successful!"
    Write-Output "URL: https://fihvhtoqviivmasjaqxc.supabase.co/functions/v1/get-agent-memory"
} else {
    Write-Output "`n✗ Deployment failed. Check output above."
}
