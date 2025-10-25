from playwright.sync_api import sync_playwright
import os

with sync_playwright() as p:
    browser = p.chromium.launch_persistent_context(
        user_data_dir='playwright-profile',
        headless=False
    )
    
    page = browser.pages[0]
    page.goto('https://www.perplexity.ai/search/analyse-deep-the-below-you-age-7pyh8Ei7Q4u4m1M9NWVw2w')
    
    input("\nWait for page to fully load, then press Enter...")
    
    print("\n=== TESTING SELECTORS ===")
    
    # Try various selectors
    selectors = [
        '[data-testid=\"answer\"]',
        '.prose',
        'div.markdown',
        'div[class*=\"answer\"]',
        'div[class*=\"response\"]',
        'div[class*=\"message\"]',
        'article',
        'main > div > div'
    ]
    
    for sel in selectors:
        count = page.locator(sel).count()
        print(f"{sel:40} → {count} elements")
    
    print("\n=== PAGE STRUCTURE ===")
    print("Getting outer HTML of main content area...")
    
    # Get a sample of the HTML
    html_sample = page.locator('main').inner_html() if page.locator('main').count() > 0 else page.content()
    print(f"\nHTML length: {len(html_sample)} chars")
    print("\nFirst 1000 chars:")
    print(html_sample[:1000])
    
    input("\n\nPress Enter to close...")
    browser.close()
