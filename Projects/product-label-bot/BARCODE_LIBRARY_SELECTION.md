# Barcode Library Evaluation for Deno/Supabase Edge Functions
Date: 2025-10-25 15:25 IST
Phase: 1 of 5

## Requirements
- Deno/Supabase Edge Function compatible (no Node.js native modules)
- EAN-13 barcode support
- Process image buffers (ArrayBuffer/Uint8Array)
- Active maintenance
- TypeScript support preferred

## Candidates Evaluated

### 1. jsQR (QR Code Only)
**Package:** https://github.com/cozmo/jsQR
**Compatibility:** ✅ Pure JavaScript, Deno compatible
**EAN-13 Support:** ❌ QR codes only
**Decision:** REJECTED - Does not support EAN-13 barcodes

### 2. @undecaf/zbar-wasm
**Package:** https://github.com/undecaf/zbar-wasm  
**Compatibility:** ✅ WebAssembly, works in Deno
**EAN-13 Support:** ✅ Supports EAN-13, UPC, Code128, QR codes
**Size:** ~400KB wasm file
**API:** Clean, Promise-based
**Decision:** ✅ SELECTED - Best fit for requirements

### 3. quagga2
**Package:** https://github.com/ericblade/quagga2
**Compatibility:** ⚠️ Requires browser APIs (camera access)
**EAN-13 Support:** ✅ Full support
**Decision:** REJECTED - Needs browser environment, not Supabase compatible

## Selected Library: @undecaf/zbar-wasm

### Import Method for Deno
\\\	ypescript
import { scanImageData } from 'https://esm.sh/@undecaf/zbar-wasm@0.10.1';
\\\

### Usage Pattern
\\\	ypescript
// Convert image buffer to ImageData
const imageData = await decodeImage(buffer);

// Scan for barcodes
const symbols = await scanImageData(imageData);

// Extract results
for (const symbol of symbols) {
  console.log('Type:', symbol.typeName);  // 'EAN-13'
  console.log('Data:', symbol.decode());   // '1234567890123'
}
\\\

### Advantages
- ✅ Native EAN-13 support
- ✅ WebAssembly (fast, no native dependencies)
- ✅ Works in Deno Deploy
- ✅ Actively maintained
- ✅ Supports multiple barcode formats
- ✅ Good error handling

### Limitations
- Requires image conversion to ImageData format
- ~400KB WASM file (acceptable for edge function)

## Implementation Strategy

1. Create BarcodeService wrapper around zbar-wasm
2. Add image buffer → ImageData converter
3. Implement EAN-13 validation (checksum)
4. Parse barcode data to extract IMEI/SN/product code
5. Handle errors gracefully (no barcode found, invalid format)

## Next Steps (Phase 2)
Create services/barcode.ts with:
- scanBarcode(imageBuffer): Promise<BarcodeResult>
- validateEAN13(code: string): boolean
- parseBarcodePy(data: string): BarcodeData

## Decision Rationale
@undecaf/zbar-wasm chosen because it's the only library that:
- Works in Supabase Edge Functions (pure WASM)
- Supports EAN-13 natively
- Has clean async API
- Is actively maintained

**Phase 1 Status:** ✅ COMPLETE
