# List all project tenants
$registry = Get-Content ".meta\tenant-registry.json" | ConvertFrom-Json

Write-Output "=== PROJECT TENANTS ==="
foreach ($project in $registry.project_tenants) {
    $status = if ($project.status -eq "active") { "🟢" } else { "🔴" }
    Write-Output "$status $($project.name)"
    Write-Output "   Namespace: $($project.namespace)"
    Write-Output "   Supabase: $($project.supabase_url)"
    Write-Output "   Path: $($project.repo_path)"
    Write-Output "   Milestone: $($project.current_milestone)"
    Write-Output ""
}
