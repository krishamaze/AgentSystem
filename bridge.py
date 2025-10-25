from playwright.sync_api import sync_playwright
import time, os, subprocess, re

THREAD_URL = input("Paste thread URL: ").strip()
USER_DATA_DIR = os.path.join(os.getcwd(), 'playwright-profile')

print("\n🔗 Connecting...")

with sync_playwright() as p:
    browser = p.chromium.launch_persistent_context(
        user_data_dir=USER_DATA_DIR, headless=False, args=['--start-maximized']
    )
    
    page = browser.pages[0]
    page.goto(THREAD_URL)
    input("\nPress Enter after thread visible...")
    print("\n✓ Bridge active (checking every 20s)\n")
    
    last_count = 0
    
    try:
        while True:
            page.reload()
            time.sleep(4)  # Wait for load
            
            messages = page.locator('.prose').all()
            current = len(messages)
            
            if current > last_count:
                print(f"\n📩 NEW! (Total: {current})")
                latest_text = messages[-1].inner_text()
                print(f"Preview: {latest_text[:150]}")
                
                matches = re.findall(r'powershell\n(.*?)\n', latest_text, re.DOTALL)
                
                if matches:
                    for cmd in matches:
                        cmd = cmd.strip()
                        if len(cmd) < 5: continue
                        
                        print(f"\n🔧 EXECUTING: {cmd[:80]}...")
                        
                        try:
                            result = subprocess.run(
                                ['C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe', '-Command', cmd],
                                capture_output=True, text=True, timeout=30, cwd='D:\\AgentSystem'
                            )
                            
                            output = (result.stdout or result.stderr).strip()
                            print(f"✓ Output: {len(output)} chars")
                            
                            inputbox = page.locator('[contenteditable=\"true\"]').first
                            inputbox.click()
                            inputbox.fill(f"**Executed:**\n{output[:700]}")
                            page.keyboard.press('Enter')
                            print("✓ Pasted")
                            time.sleep(3)
                            
                        except Exception as e:
                            print(f"❌ {e}")
                else:
                    print("No commands")
                
                last_count = current
            else:
                print(f"⏱️ ({current})")
            
            time.sleep(16)  # Total: 20s between checks
    except KeyboardInterrupt:
        print("\n🛑 Stopped")
        try: browser.close()
        except: pass