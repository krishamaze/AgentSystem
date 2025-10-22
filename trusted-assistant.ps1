# trusted-assistant.ps1 - Autonomous Execution Engine v0.4 (Definitive Manual Fix)

# --- Main Loop: Reads a command from the bridge, executes, and sends a response back ---
while (($jsonCommand = [Console]::In.ReadLine()) -ne $null) {
    try {
        if ([string]::IsNullOrWhiteSpace($jsonCommand)) { continue }

        $command = $jsonCommand | ConvertFrom-Json -ErrorAction Stop
        $response = $null

        # --- SECURITY CORE ---
        switch ($command.action) {
            "read_file" {
                $filePath = $command.parameters.path
                if ($filePath -ne "D:\test.txt") {
                    throw "SECURITY VIOLATION: Attempted to access a non-whitelisted file path: $filePath"
                }

                if (Test-Path $filePath) {
                    $content = Get-Content $filePath -Raw
                    $response = @{
                        request_id = $command.request_id;
                        status     = "success";
                        data       = $content
                    }
                } else {
                    throw "File not found at path: $filePath"
                }
            }
            default {
                throw "Unknown action: '$($command.action)'. Action is not whitelisted."
            }
        }
    }
    catch {
        $reqId = "unknown"
        if ($command -and $command.request_id) {
            $reqId = $command.request_id
        }
        $response = @{
            request_id    = $reqId;
            status        = "error";
            error_message = $_.Exception.Message
        }
    }
    finally {
        if ($null -ne $response) {
            $jsonResponse = $response | ConvertTo-Json -Compress
            # Send the response to the Node.js bridge via the standard output stream.
            Write-Host $jsonResponse
        }
    }
}
