# Check Supabase CLI
$cliCheck = supabase --version 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Output "ERROR: Supabase CLI not installed. Install: https://supabase.com/docs/guides/cli"
    exit 1
}

# Deploy get-agent-memory function
cd supabase
supabase functions deploy get-agent-memory --no-verify-jwt 2>&1 | Out-Null
if ($LASTEXITCODE -eq 0) {
    Write-Output "Edge function deployed: https://fihvhtoqviivmasjaqxc.supabase.co/functions/v1/get-agent-memory"
} else {
    Write-Output "Deployment failed. Run manually: cd supabase; supabase functions deploy get-agent-memory"
}
cd ..
