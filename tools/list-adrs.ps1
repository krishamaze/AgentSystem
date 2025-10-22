# List all Architecture Decision Records
param([string]$Project)

$registry = Get-Content ".\decisions\adr-registry.json" | ConvertFrom-Json

if ($Project) {
    $proj = $registry.projects.$Project
    if ($proj) {
        Write-Output "=== ADRs for $Project ==="
        foreach ($adr in $proj.adrs) {
            Write-Output "ADR-$($adr.id): $($adr.title) [$($adr.status)]"
        }
    } else {
        Write-Output "Project not found: $Project"
    }
} else {
    Write-Output "=== ALL ADRs ==="
    foreach ($projName in $registry.projects.PSObject.Properties.Name) {
        $proj = $registry.projects.$projName
        if ($proj.count -gt 0) {
            Write-Output "`n$projName ($($proj.count) ADRs):"
            foreach ($adr in $proj.adrs) {
                Write-Output "  ADR-$($adr.id): $($adr.title) [$($adr.status)]"
            }
        }
    }
}
