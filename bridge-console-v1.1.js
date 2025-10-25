// Perplexity Bridge Console Script v1.1
console.log('🔗 Bridge Console Script v1.1 - Starting...');

const CONFIG = {
    checkInterval: 5000,
    apiEndpoint: 'http://localhost:5000/execute'
};

let lastMessageCount = 0;

function getMessages() {
    return document.querySelectorAll('.prose');
}

function extractCommands(text) {
    // Match code blocks with powershell language tag
    const blocks = text.match(/``````/g);
    if (!blocks) return [];
    
    return blocks.map(block => {
        const match = block.match(/``````/);
        return match ? match[1].trim() : '';
    }).filter(cmd => cmd.length > 0);
}

function addExecuteButton(codeBlock, command, index) {
    if (codeBlock.querySelector('.execute-btn')) return;
    
    const btn = document.createElement('button');
    btn.className = 'execute-btn';
    btn.textContent = '▶ Execute';
    btn.style.cssText = 'position:absolute;top:8px;right:8px;background:#4CAF50;color:white;border:none;padding:6px 12px;border-radius:4px;cursor:pointer;font-size:12px;font-weight:bold;z-index:1000;';
    
    btn.onmouseover = () => btn.style.background = '#45a049';
    btn.onmouseout = () => btn.style.background = '#4CAF50';
    
    btn.onclick = async () => {
        btn.textContent = '⏳ Executing...';
        btn.disabled = true;
        
        try {
            console.log('Executing command:', command.substring(0, 80));
            
            const response = await fetch(CONFIG.apiEndpoint, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ command })
            });
            
            const result = await response.json();
            console.log('Execution result:', result);
            
            const inputBox = document.querySelector('[contenteditable="true"]');
            if (inputBox) {
                const output = result.output || result.error || 'No output';
                inputBox.textContent = '**Executed:**\n``````';
                inputBox.focus();
                
                // Trigger input event to enable send button
                inputBox.dispatchEvent(new Event('input', { bubbles: true }));
                
                btn.textContent = '✓ Done';
                btn.style.background = '#2196F3';
            } else {
                throw new Error('Input box not found');
            }
        } catch (error) {
            console.error('Execution failed:', error);
            btn.textContent = '✗ Failed';
            btn.style.background = '#f44336';
        }
        
        setTimeout(() => {
            btn.textContent = '▶ Execute';
            btn.style.background = '#4CAF50';
            btn.disabled = false;
        }, 3000);
    };
    
    const wrapper = codeBlock.closest('pre') || codeBlock.parentElement;
    wrapper.style.position = 'relative';
    wrapper.appendChild(btn);
}

function processMessages() {
    const messages = getMessages();
    const currentCount = messages.length;
    
    if (currentCount > lastMessageCount) {
        console.log('📩 New messages detected! (' + lastMessageCount + ' → ' + currentCount + ')');
        
        for (let i = lastMessageCount; i < currentCount; i++) {
            const message = messages[i];
            const text = message.textContent;
            const commands = extractCommands(text);
            
            if (commands.length > 0) {
                console.log('🔧 Found ' + commands.length + ' command(s) in message ' + (i + 1));
                console.log('Commands:', commands.map(c => c.substring(0, 50)));
                
                const codeBlocks = message.querySelectorAll('code');
                codeBlocks.forEach((block, idx) => {
                    const blockText = block.textContent.trim();
                    if (blockText.length > 5 && idx < commands.length) {
                        addExecuteButton(block, commands[idx], idx);
                    }
                });
            }
        }
        
        lastMessageCount = currentCount;
    }
}

lastMessageCount = getMessages().length;
console.log('✓ Initialized - Monitoring ' + lastMessageCount + ' existing messages');

const monitorInterval = setInterval(processMessages, CONFIG.checkInterval);
console.log('✓ Bridge active - checking every 5 seconds');
console.log('To stop: clearInterval(' + monitorInterval + ')');
