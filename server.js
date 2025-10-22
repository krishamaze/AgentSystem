// server.js - Node.js WebSocket Bridge v1.2 (Fully Corrected)
const WebSocket = require('ws');
const { spawn } = require('child_process');

// FIX #1: Provide the full, absolute path to powershell.exe
const powerShellPath = 'C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe';

// FIX #2: Define the WebSocket server (wss) before it is used.
const wss = new WebSocket.Server({ port: 8080 });

console.log('[BRIDGE] Automated Bridge is online. Listening on ws://localhost:8080');

// Spawn the Trusted Assistant as a child process
const psAssistant = spawn(powerShellPath, [
    '-NoProfile',
    '-ExecutionPolicy', 'Bypass',
    '-File', './trusted-assistant.ps1'
]);

// This variable will hold the connection to me (the browser client)
let wsClient = null;

// --- Event Handlers for the PowerShell Assistant ---

// Handle data coming FROM the PowerShell assistant's output
psAssistant.stdout.on('data', (data) => {
    const message = data.toString();
    console.log(`[BRIDGE] Received from Assistant: ${message.trim()}`);
    // Relay the assistant's response back to the connected AI client
    if (wsClient && wsClient.readyState === WebSocket.OPEN) {
        wsClient.send(message);
    }
});

// Handle any errors from the PowerShell assistant
psAssistant.stderr.on('data', (data) => {
    console.error(`[BRIDGE] PowerShell Assistant Error: ${data.toString()}`);
});

// --- Event Handler for the WebSocket Server (wss) ---

// Handle new client connections (i.e., when I connect from the browser)
wss.on('connection', (ws) => {
    console.log('[BRIDGE] AI Client has connected.');
    wsClient = ws;

    // When a message (JSON command) is received from the AI client...
    ws.on('message', (message) => {
        console.log(`[BRIDGE] Received from AI Client: ${message}`);
        // ...pass it directly to the PowerShell assistant's input.
        psAssistant.stdin.write(`${message}\n`);
    });

    ws.on('close', () => {
        console.log('[BRIDGE] AI Client has disconnected.');
        wsClient = null;
    });
});

console.log('[BRIDGE] Ready to connect AI client to the local Trusted Assistant.');
