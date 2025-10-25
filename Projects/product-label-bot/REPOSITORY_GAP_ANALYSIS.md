# BrandTemplateRepository Gap Analysis
Generated: 2025-10-25 13:07 IST

## Current Implementation âœ… 
- **Base CRUD**: create(), findById(), findAll(), update(), delete() (via BaseRepository)
- **Query Methods**: getActiveTemplates(), findByBrandName()
- **State Management**: activate(id), deactivate(id)
- **Error Handling**: DatabaseError wrapping, logger integration
- **Type Safety**: Full TypeScript interfaces

## Missing for /addtemplate âŒ
1. **Validation Methods**
   - validateBrandNameUnique(brandName: string): Promise<boolean>
   - validateDetectionPatterns(patterns: string[]): ValidationResult
   - validateExtractionPatterns(patterns: Record<string, string>): ValidationResult
   - validateMandatoryFields(fields: string[], extractionKeys: string[]): ValidationResult

2. **Testing Methods**
   - testPatternMatch(ocrText: string, patterns: string[]): boolean
   - testFieldExtraction(ocrText: string, pattern: string): string | null

3. **Priority Management**
   - getNextPriority(): Promise<number>
   - updatePriorities(ids: number[], newPriorities: number[]): Promise<void>

## Implementation Strategy (Phase A - Today)
### Step 1: Enhance BrandTemplateRepository (20 mins)
Add validation methods:
\\\	ypescript
async validateBrandNameUnique(brandName: string): Promise<boolean>
validateRegexPattern(pattern: string): { valid: boolean; error?: string }
\\\

### Step 2: Create /addtemplate Handler (30 mins)
Location: handlers/addtemplate.ts
State machine for conversational flow:
- AWAITING_BRAND_NAME
- AWAITING_DETECTION_PATTERNS
- AWAITING_EXTRACTION_FIELD
- AWAITING_MANDATORY_FIELDS
- AWAITING_CONFIRMATION

### Step 3: Wire into main index.ts (5 mins)
Add route: \/addtemplate\ → AddTemplateHandler

### Step 4: Update types/index.ts (5 mins)
Add AddTemplateSessionState interface

## Testing Checklist
- [ ] Can start /addtemplate command
- [ ] Validates brand name uniqueness
- [ ] Accepts detection patterns (comma-separated)
- [ ] Collects extraction patterns (field: regex)
- [ ] Validates mandatory fields subset
- [ ] Shows preview before saving
- [ ] Saves to database successfully
- [ ] Handles cancellation (/cancel)

## Success Criteria
User can add brand template via Telegram without touching database directly.
