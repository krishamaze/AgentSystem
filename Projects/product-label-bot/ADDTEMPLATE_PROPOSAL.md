# /addtemplate Implementation Proposal
Generated: 2025-10-25 13:15 IST
Status: AWAITING APPROVAL

## Overview
Add conversational /addtemplate command allowing users to create brand templates via Telegram without database access.

## Files to Modify/Create

### 1. repositories/brand-template.ts (MODIFY - Add 3 methods)

**Add to existing class:**

\\\	ypescript
/**
 * Check if brand name already exists
 * @param brandName - Brand name to check
 * @returns true if available, false if taken
 */
async isBrandNameAvailable(brandName: string): Promise<boolean> {
  try {
    const { data, error } = await this.client
      .from(this.tableName)
      .select('id')
      .ilike('brand_name', brandName)
      .limit(1);

    if (error) throw new DatabaseError(error.message);
    
    return data.length === 0;
  } catch (error) {
    this.logger.error('Failed to check brand name availability', error as Error);
    throw error;
  }
}

/**
 * Validate regex pattern syntax
 * @param pattern - Regex pattern string
 * @returns Validation result
 */
validateRegexPattern(pattern: string): { valid: boolean; error?: string } {
  try {
    new RegExp(pattern);
    return { valid: true };
  } catch (e) {
    return { valid: false, error: (e as Error).message };
  }
}

/**
 * Get next priority value for new template
 * @returns Next priority number
 */
async getNextPriority(): Promise<number> {
  try {
    const { data, error } = await this.client
      .from(this.tableName)
      .select('priority')
      .order('priority', { ascending: false })
      .limit(1);

    if (error) throw new DatabaseError(error.message);
    
    return data.length > 0 ? (data[0].priority || 0) + 1 : 1;
  } catch (error) {
    this.logger.error('Failed to get next priority', error as Error);
    throw error;
  }
}
\\\

**Why these methods:**
- \isBrandNameAvailable\: Prevent duplicate brand names
- \alidateRegexPattern\: Catch invalid regex before database save
- \getNextPriority\: Auto-assign priority (lower = higher priority)

**Risk: LOW** - Adding methods to existing class, no breaking changes

---

### 2. handlers/addtemplate.ts (CREATE NEW - ~200 lines)

**State Machine Flow:**
\\\
User: /addtemplate
Bot: "Enter brand name:"
User: "Samsung"
Bot: "Enter detection patterns (comma-separated regex):"
User: "Samsung, Galaxy, SM-[A-Z]\\d{3}"
Bot: "Add extraction pattern. Format: field_name:regex or 'done'"
User: "imei1:IMEI1?[:\\s]*(\\d{15})"
User: "model:SM-[A-Z]\\d{3}"
User: "done"
Bot: "Enter mandatory fields (comma-separated):"
User: "imei1"
Bot: [Shows preview]
Bot: "Confirm? Reply 'yes' to save, 'no' to cancel"
User: "yes"
Bot: " Template saved!"
\\\

**Handler Structure:**
- Uses SessionRepository to track state (store in extracted_data field)
- Validates each input before moving to next state
- Supports /cancel at any point
- Shows preview with all collected data
- Saves to database on confirmation

**Risk: MEDIUM** - New file, but follows existing handler patterns (MessageHandler, PhotoHandler)

---

### 3. index.ts (MODIFY - Add route)

**Insert after /end command check, before photo handling:**

\\\	ypescript
// Handle /addtemplate command
if (message.text === '/addtemplate') {
  const addTemplateHandler = container.getAddTemplateHandler();
  await addTemplateHandler.handleCommand(message);
  return new Response('OK', { status: 200 });
}

// Handle /cancel command (works in any flow)
if (message.text === '/cancel') {
  await messageHandler.handleEndCommand(message);
  return new Response('OK', { status: 200 });
}
\\\

**Risk: LOW** - Simple route addition, doesn't break existing flow

---

### 4. utils/container.ts (MODIFY - Add getter)

**Add to Container class:**

\\\	ypescript
getAddTemplateHandler(): AddTemplateHandler {
  if (!this.addTemplateHandler) {
    this.addTemplateHandler = new AddTemplateHandler(
      this.logger,
      this.getBrandTemplateRepository(),
      this.getSessionRepository(),
      this.getTelegramService()
    );
  }
  return this.addTemplateHandler;
}
\\\

**Risk: LOW** - Follows existing dependency injection pattern

---

### 5. types/index.ts (MODIFY - Add types)

**Add near other state types:**

\\\	ypescript
/**
 * Add template session state
 */
export type AddTemplateState = 
  | 'AWAITING_BRAND_NAME'
  | 'AWAITING_DETECTION_PATTERNS'
  | 'AWAITING_EXTRACTION_FIELD'
  | 'AWAITING_MANDATORY_FIELDS'
  | 'AWAITING_CONFIRMATION';

/**
 * Add template session data
 */
export interface AddTemplateData {
  state: AddTemplateState;
  brand_name?: string;
  detection_patterns?: string[];
  extraction_patterns?: Record<string, string>;
  mandatory_fields?: string[];
}
\\\

**Risk: LOW** - Type additions, no breaking changes

---

## Implementation Order

1. **Enhance repository** (lowest risk, foundational)
2. **Add types** (enables handler development)
3. **Create handler** (core logic)
4. **Update container** (dependency injection)
5. **Wire into index.ts** (routing)

## Testing Strategy

**Manual Testing via Telegram:**
1. Send /addtemplate  Should prompt for brand name
2. Enter brand name  Should prompt for detection patterns
3. Complete flow  Should save to database
4. Query database  Verify saved correctly
5. Try /cancel mid-flow  Should abort cleanly
6. Try duplicate brand name  Should reject

**Database Validation:**
\\\sql
SELECT * FROM brand_templates ORDER BY created_at DESC LIMIT 1;
\\\

## Rollback Plan

If issues arise:
1. Remove /addtemplate route from index.ts
2. Remove getAddTemplateHandler from container.ts
3. Delete handlers/addtemplate.ts
4. Keep repository enhancements (harmless if unused)

## Questions Before Implementation

1. **Priority assignment:** Auto-increment (recommended) or ask user?
2. **Validation level:** Strict (block invalid regex) or permissive (warn but save)?
3. **Testing:** Add test pattern validation step in flow?
4. **Authorization:** Admin-only or all approved users?

## My Recommendations

- Priority: **Auto-increment** (simpler UX, can edit later)
- Validation: **Strict** (prevent broken templates)
- Testing: **Phase B** (optional test step, not blocking)
- Authorization: **Admin-only** (add admin check in handler)

## Approval Request

Please review and confirm:
- [ ] Architecture approach acceptable
- [ ] State machine flow makes sense
- [ ] Validation strategy appropriate
- [ ] Ready to proceed with implementation

Or suggest modifications before I start.
