# Phase 4 Implementation - Revised Barcode-First Flow
Date: 2025-10-25 16:23:09 IST

## User Clarifications Applied

### 1. No Barcode = Ask for Clear Image (NOT OCR Fallback)
**OLD assumption:** No barcode → Run OCR
**CORRECTED:** No barcode → "Please send clearer image with visible barcode"

### 2. IMEI1 = Serial Number (For Mobiles)
**Clarification:** IMEI1 and SN are the same identifier for mobile products
**Search Logic:** Use IMEI1/SN as primary identifier (most specific)

### 3. Simplified Search Priority (2-Tier)
**OLD:** IMEI → EAN → SN (3 levels)
**CORRECTED:** IMEI1/SN → EAN (2 levels only)
- Remove generic SN fallback (redundant with IMEI1)

## Revised Flow

\\\
User sends photo
    ↓
Upload to storage
    ↓
Extract barcode (BarcodeService)
    ↓
Barcode detected?
    ├─ NO → Send "Please send clear image with visible barcode" → EXIT
    └─ YES → Continue
         ↓
    Search Priority:
    1. Search by IMEI1/SN (most specific)
         ├─ Found? → Create session with product → EXIT ✅
         └─ Not found? → Continue
    2. Search by EAN-13 (product code)
         ├─ Found? → Create session with product → EXIT ✅
         └─ Not found? → Continue
         ↓
    Product not in database → Run OCR to extract details
         ↓
    OCR → Brand detection → Data extraction → Create session
\\\

## Key Changes from Original Plan
1. ❌ Removed OCR fallback when no barcode detected
2. ✅ Added "clear image" prompt instead
3. ✅ Unified IMEI1/SN as single search (not separate)
4. ❌ Removed generic SN third-tier search
5. ✅ OCR only runs when barcode works but product not in DB

## Implementation Changes Needed

### PhotoHandler.ts:
1. Add barcode extraction attempt
2. If no barcode → Send error message, EXIT
3. If barcode detected → 2-tier search (IMEI1/SN, then EAN)
4. If product found → Create session from product, EXIT
5. If product NOT found → OCR fallback (existing logic)

### Success Messages:
- **Barcode + Product found:** "✅ Product detected via barcode: [BRAND MODEL]"
- **No barcode:** "❌ No barcode detected. Please send clearer photo."
- **Barcode but no product:** "Barcode detected, extracting details via OCR..."

## Error Handling
- Barcode extraction fails → "No barcode detected" message
- Database query fails → Log error, continue to OCR
- OCR fails → Existing error handling

**Status:** Ready for implementation
