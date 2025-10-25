# PhotoHandler Structure Analysis
Date: 2025-10-25 16:26:26 IST

## Current File Size
5231 characters

## Key Sections to Integrate Barcode Logic

### Current Flow (Identified):
1. Photo received
2. Download photo from Telegram
3. Upload to Supabase Storage
4. Get download URL
5. Run Google Vision OCR
6. Detect brand from OCR text
7. Extract data using brand template
8. Create session
9. Send payment keyboard

### Integration Points for Barcode:

**INSERTION POINT:** After storage upload, before Google Vision

**New Section to Add (between steps 4 and 5):**
\\\
4.5. Try barcode extraction
     ├─ Download image buffer
     ├─ Call BarcodeService.extractBarcode()
     ├─ If no barcode → Send error message, EXIT
     ├─ If barcode found → 2-tier database search:
     │   ├─ Search by IMEI1/SN
     │   ├─ Search by EAN-13
     │   └─ If found → Create session from product, EXIT
     └─ If not found → Continue to OCR (step 5)
\\\

## Dependencies to Import
- BarcodeService from '../services/barcode.ts'
- ProductRepository from '../repositories/product.ts'

## Methods to Add
1. tryBarcodeExtraction(imageBuffer): Promise<BarcodeResult>
2. searchProductByBarcode(barcodeData): Promise<Product | null>
3. createSessionFromProduct(product, chatId, messageId): Promise<void>

## Existing Methods to Preserve
- All OCR-related logic (brand detection, data extraction)
- Session creation logic
- Error handling

## Messages to Add
1. No barcode: "❌ Barcode not detected. Please send a clearer photo showing the barcode clearly."
2. Barcode success: "✅ Product identified: {brand} {model}"
3. Barcode but not in DB: "📦 Barcode detected, extracting additional details..."

**Status:** Structure analyzed, ready for implementation
