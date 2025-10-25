from playwright.sync_api import sync_playwright

with sync_playwright() as p:
    browser = p.chromium.launch_persistent_context(
        user_data_dir='playwright-profile', headless=False
    )
    page = browser.pages[0]
    page.goto('https://www.perplexity.ai/search/analyse-deep-the-below-you-age-7pyh8Ei7Q4u4m1M9NWVw2w')
    
    input("\nPress Enter after page loads...")
    
    print("\n=== FINDING INPUT ELEMENT ===")
    
    # Try different selectors
    tests = [
        'textarea',
        'input[type=\"text\"]',
        '[contenteditable=\"true\"]',
        '[role=\"textbox\"]',
        '[placeholder*=\"Ask\"]',
        'div[contenteditable]'
    ]
    
    for sel in tests:
        count = page.locator(sel).count()
        print(f"{sel:40} → {count} found")
        if count > 0:
            try:
                elem = page.locator(sel).first
                tag = elem.evaluate('el => el.tagName')
                classes = elem.evaluate('el => el.className')
                print(f"  ✓ Tag: {tag}, Classes: {classes[:100]}")
            except:
                pass
    
    input("\nPress Enter to close...")
    browser.close()
