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
