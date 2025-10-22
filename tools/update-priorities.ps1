# Update priority scores based on LLM feedback
# System learns what context is actually useful

param(
    [Parameter(Mandatory=$true)]
    [string]$LearningsJson
)

Write-Output "=== UPDATING PRIORITIES ==="

try {
    $learnings = $LearningsJson | ConvertFrom-Json
} catch {
    Write-Error "Invalid JSON format"
    return
}

$priorityScores = Get-Content ".meta\priority-scores.json" | ConvertFrom-Json

$updated = 0

foreach ($learning in $learnings.learnings) {
    $topic = $learning.topic
    $usefulness = $learning.usefulness
    
    # Map usefulness to score adjustment
    $adjustment = switch ($usefulness) {
        "high" { 0.2 }
        "medium" { 0.1 }
        "low" { -0.1 }
        "none" { -0.2 }
        default { 0 }
    }
    
    # Update or create score
    if ($priorityScores.PSObject.Properties.Name -contains $topic) {
        $oldScore = $priorityScores.$topic
        $newScore = [math]::Max(0.0, [math]::Min(1.0, $oldScore + $adjustment))
        $priorityScores.$topic = $newScore
        Write-Output "  $topic: $([math]::Round($oldScore, 2)) → $([math]::Round($newScore, 2)) ($usefulness)"
    } else {
        $baseScore = 0.5
        $newScore = [math]::Max(0.0, [math]::Min(1.0, $baseScore + $adjustment))
        $priorityScores | Add-Member -MemberType NoteProperty -Name $topic -Value $newScore
        Write-Output "  $topic: NEW → $([math]::Round($newScore, 2)) ($usefulness)"
    }
    
    $updated++
}

# Save updated scores
$priorityScores | ConvertTo-Json -Depth 10 | Out-File ".meta\priority-scores.json" -Encoding UTF8

Write-Output "`n✓ Updated $updated priority scores"
Write-Output "✓ Saved to .meta\priority-scores.json"
Write-Output "`nSystem will use these scores in next session initialization"
