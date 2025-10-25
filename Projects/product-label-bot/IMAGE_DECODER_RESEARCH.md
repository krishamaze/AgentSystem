# Image Decoder Requirement for zbar-wasm
Phase: 2.5 (Between Phase 2 and Phase 4)
Date: 2025-10-25 16:02:52 IST

## Problem
zbar-wasm requires ImageData format (width, height, pixel data array).
Current bufferToImageData() in BarcodeService is stubbed.

## User Decision
Use proper zbar-wasm integration with image decoder (not OCR text regex fallback).

## Requirements
- Deno-compatible (no Node.js native modules)
- Decode JPEG and PNG formats
- Convert to ImageData format { width, height, data: Uint8ClampedArray }
- Works in Supabase Edge Functions (Deno Deploy)

## Library Candidates to Evaluate

### 1. imagescript (Pure JS)
**URL:** https://deno.land/x/imagescript
**Compatibility:** ✅ Pure TypeScript, Deno-first
**Formats:** PNG, JPEG, BMP, TIFF, GIF
**API:** Clean, async
**Status:** INVESTIGATING

### 2. image_rs (WASM)
**URL:** https://github.com/image-rs/image (via wasm-bindgen)
**Compatibility:** ✅ WebAssembly
**Formats:** PNG, JPEG, many others
**API:** Rust-based, WASM bindings
**Status:** INVESTIGATING

### 3. sharp (Deno port)
**URL:** Check if Deno-compatible version exists
**Compatibility:** ⚠️ Originally Node.js, may not work
**Formats:** All major formats
**Status:** INVESTIGATING

## Next Steps
1. Test import of each library in Deno
2. Verify ImageData conversion capability
3. Check Supabase Edge Function compatibility
4. Benchmark performance/size
5. Present recommendation with pros/cons

## Blockers
Phase 4 (PhotoHandler refactor) is BLOCKED until image decoder is implemented.
