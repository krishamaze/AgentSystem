# Brain compression - runs when brain exceeds threshold
param([int]$ThresholdKB = 100)

$brainFile = ".\Agent_Primary\brain\learned-knowledge.md"
$brainSize = (Get-Item $brainFile).Length / 1KB

Write-Output "Current brain size: $([math]::Round($brainSize, 2)) KB"

if ($brainSize -gt $ThresholdKB) {
    Write-Output "⚠ Brain exceeds ${ThresholdKB}KB - compressing..."
    
    # Backup before compression
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    Copy-Item $brainFile ".\backups\brain_before_compression_$timestamp.md"
    
    # Read and parse sections
    $content = Get-Content $brainFile -Raw
    $sections = $content -split '(?=## Learning:)'
    
    # Keep header + recent 15 learnings
    $header = $sections[0]
    $recentLearnings = $sections[1..15] -join "`n"
    
    # Archive older learnings
    $archivedLearnings = $sections[16..($sections.Count-1)] -join "`n"
    $archivedLearnings | Out-File ".\backups\brain_archive_$timestamp.md" -Encoding UTF8
    
    # Write compressed brain
    $compressed = $header + "`n" + $recentLearnings
    $compressed | Out-File $brainFile -Encoding UTF8
    
    $newSize = (Get-Item $brainFile).Length / 1KB
    Write-Output "✓ Compressed: $([math]::Round($brainSize, 2))KB → $([math]::Round($newSize, 2))KB"
    Write-Output "Archived: backups/brain_archive_$timestamp.md"
} else {
    Write-Output "✓ Brain size healthy (threshold: ${ThresholdKB}KB)"
}
