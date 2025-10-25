# Known Issues - product-label-bot
**Last Updated:** 2025-10-25 17:21:04 IST

## Active Issues

### 1. UTF-8 BOM Corruption in .env and config.toml
**Symptom:** Supabase CLI fails with unexpected character errors (» symbol)
**Cause:** Windows text editors (Notepad) add BOM by default
**Fix:**
\\\powershell
$content = Get-Content ".env" -Raw
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText("$PWD\.env", $content, $utf8NoBom)
\\\
**Prevention:** Always use UTF8Encoding($false) when writing config files
**Last Occurred:** 2025-10-25 16:55 IST

### 2. Template Literal Corruption
**Symptom:** TypeScript code has .eq.Cyan{variable} instead of .eq(\\\)
**Cause:** Unknown (possibly copy/paste encoding issue)
**Fix:** Manually restore template literal syntax
**Files Affected:** product.ts, barcode.ts
**Last Occurred:** 2025-10-25 17:00 IST

### 3. config.toml Unsupported Keys
**Symptom:** Supabase deploy fails on email_optional key
**Fix:** Comment out unsupported keys in config.toml
**Last Occurred:** 2025-10-25 16:54 IST

## Resolved Issues
(None yet - move issues here once permanently fixed)

## Pre-Deployment Checklist
Before running \supabase functions deploy\:
- [ ] Check .env for BOM (look for » character)
- [ ] Check config.toml for BOM
- [ ] Verify config.toml has no unsupported keys commented
- [ ] Scan .ts files for template literal corruption (.Cyan{ pattern)
- [ ] Run local TypeScript validation if possible

**Last Updated:** 2025-10-25 17:21:04 IST

## 4. Code Corruption from AI-Generated Content (CRITICAL)
**Symptom:** TypeScript syntax errors - template literals corrupted, strings malformed
**Cause:** AI response markdown code blocks embedded in actual code during copy/paste
**Date:** 2025-10-25 18:00-18:22 IST
**Files Affected:** product.ts (lines 174, 202), photo.ts (20+ lines)

**Corruption Patterns:**
1. **Template literal corruption:** Triple backticks (\\\) from markdown → Remove, use single backticks
2. **String delimiter corruption:** Backslashes (\) instead of backticks (\) → Replace with proper template literals
3. **Regex over-escaping:** \\\\/\\.jpg\\ instead of /\\.jpg/ → Fix backslash escaping
4. **Callback_data malformation:** \\payment_cash_\\\\ instead of 'payment_cash_' → Use proper string quotes

**Fix Applied:** Manual correction of all template literals and string delimiters
**Prevention:**
- Always validate TypeScript syntax before deployment
- Search for `
- Use linter/formatter (deno fmt) to catch syntax errors
- Test compilation locally before deploying

**Last Occurred:** 2025-10-25 18:22 IST (RESOLVED)


## 5. Supabase Edge Function 401 Authentication (RESOLVED)
**Symptom:** Telegram bot not responding, all webhook requests return 401
**Cause:** Default JWT verification blocks unauthenticated requests
**Date:** 2025-10-25 18:30-18:41 IST
**Solution:** Set \"verify_jwt": false\ in deno.json
**Prevention:** Always configure verify_jwt: false for public webhooks (Telegram, GitHub, etc.)
**Last Occurred:** 2025-10-25 18:41 IST (RESOLVED)

