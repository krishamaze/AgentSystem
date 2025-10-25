# /addtemplate Implementation Plan
Generated: 2025-10-25 12:56 IST

## Architecture
Location: D:\product-label-bot\supabase\functions\telegram-bot\handlers\addtemplate.ts

## User Flow (Conversational State Machine)
1. /addtemplate → Request brand name
2. User sends brand name → Request detection patterns (comma-separated)
3. User sends patterns → Request extraction fields one-by-one
   - For each field: name, regex pattern
   - Type 'done' to finish
4. User completes fields → Request mandatory field names
5. User sends mandatory → Show preview, request confirmation
6. User confirms → Save to database, test with sample OCR

## State Management
- Store in bot_sessions.extracted_data: { step, brand_name, detection_patterns[], extraction_patterns{}, mandatory_fields[] }
- Use telegram_user_id + status='addtemplate' for state tracking

## Validation Rules
- Brand name: Not empty, unique (check existing)
- Detection patterns: Valid regex, test compilation
- Extraction patterns: Field names match products schema, regex valid, has capture group
- Mandatory fields: Subset of extraction_patterns keys

## Files to Create/Modify
1. handlers/addtemplate.ts (new) - State machine logic
2. repositories/BrandTemplateRepository.ts (new) - CRUD operations
3. index.ts (modify) - Route /addtemplate command
4. types/SessionState.ts (modify) - Add addtemplate state type

## Next Actions
1. Create BrandTemplateRepository with CRUD methods
2. Build state machine handler for conversational flow
3. Integrate into main bot index.ts
4. Test with real Telegram bot
