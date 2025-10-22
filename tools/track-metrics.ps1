# Track session metrics in real-time
# Auto-called by other tools to collect telemetry

param(
    [string]$Event,
    [hashtable]$Data = @{}
)

# Initialize session tracking if not exists
if (-not $env:SESSION_ID) {
    $env:SESSION_ID = "session_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    $env:SESSION_START = Get-Date
    $env:COMMAND_COUNT = 0
    $env:ERROR_COUNT = 0
    $env:CONTEXT_REQUEST_COUNT = 0
    $env:TOOLS_USED = ""
}

# Track event
switch ($Event) {
    "COMMAND_EXECUTED" {
        $env:COMMAND_COUNT = [int]$env:COMMAND_COUNT + 1
        if ($Data.tool) {
            $env:TOOLS_USED += "$($Data.tool),"
        }
    }
    "ERROR_OCCURRED" {
        $env:ERROR_COUNT = [int]$env:ERROR_COUNT + 1
    }
    "CONTEXT_REQUESTED" {
        $env:CONTEXT_REQUEST_COUNT = [int]$env:CONTEXT_REQUEST_COUNT + 1
    }
}

# Save event to telemetry
$telemetryEntry = @{
    session_id = $env:SESSION_ID
    timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    event = $Event
    data = $Data
} | ConvertTo-Json -Compress

Add-Content ".meta\telemetry.jsonl" -Value $telemetryEntry
