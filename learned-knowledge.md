

## Learning: 2025-10-19 20:22 - Supabase JWT Bypass Configuration
**SOLUTION:** Add [functions.chat-api] section with verify_jwt = false to config.toml
**SYNTAX:** [functions.function-name] followed by verify_jwt = false on new line
**DEPLOYMENT:** Changes apply on next supabase functions deploy
**SECURITY:** Allows anonymous access - function must implement own auth if needed
**REFERENCE:** Supabase official docs - Function Configuration


## Learning: 2025-10-19 20:25 - TOML Duplicate Key Resolution
**PROBLEM:** verify_jwt defined twice in [functions.chat-api] section
**CAUSE:** Script added new line without removing old one
**SOLUTION:** Line-by-line processing - skip all verify_jwt lines in section, add single one after header
**METHOD:** foreach loop with section tracking, filter duplicates, insert at correct position
**RESULT:** Deployment successful with verify_jwt = false


## Learning: 2025-10-19 20:46 - Continuous Brain Update Protocol
**CRITICAL USER MANDATE:** Update brain simultaneously on EVERY session, not just at milestones
**APPLICATION:** Add learning entries during investigation, not just after fixes
**REASON:** Prevents knowledge loss if session terminates unexpectedly
**METHOD:** Include brain updates in same command block as work being done


## Learning: 2025-10-19 20:47 - Function Request Format Investigation
**FINDING:** chat-api expects { events, roomPath, botPlatformId } not { model, messages }
**ERROR CAUSE:** Sent wrong payload format - generic LLM format instead of bot-specific format
**NEXT:** Need to understand events array structure and required fields


## Learning: 2025-10-19 20:47 - Chat-API Payload Structure
**CORRECT FORMAT:**
- events: array of { platformId, username, text, timestamp, type }
- roomPath: string (room identifier)
- botPlatformId: string (bot's platform ID)
**NOT generic LLM format** - this is a bot-specific WhatsApp handler


## Learning: 2025-10-19 20:48 - Error Code Progression
**PROGRESS:** 400 Bad Request -> 500 Internal Server Error
**MEANING:** Payload format now correct, but function execution failed
**INVESTIGATION:** Need Supabase dashboard logs to see actual error
**DASHBOARD:** https://supabase.com/dashboard/project/{project-ref}/functions/{function-name}/logs


## Learning: 2025-10-19 20:49 - Database Constraint Violation
**ERROR:** duplicate key value violates unique constraint 'bots_username_key'
**CAUSE:** getOrCreateBot() trying to insert bot that already exists
**LOCATION:** index.ts line 104
**INVESTIGATION NEEDED:** Check getOrCreateBot logic - should SELECT first, only INSERT if not found


## Learning: 2025-10-19 20:50 - Race Condition Fix
**ROOT CAUSE:** SELECT by platform_id but INSERT has unique constraint on username
**SCENARIO:** Different platform_id but same username = duplicate key error
**FIX:** Change .insert() to .upsert() with onConflict: 'username'
**RESULT:** Updates existing bot instead of throwing error


## Learning: 2025-10-19 20:52 - PowerShell Regex Multi-Line Fix
**PROBLEM:** Options placed after .single() instead of inside .upsert()
**CAUSE:** Line-by-line processing doesn't see multi-line function chain
**SOLUTION:** Use -Raw mode + regex to capture entire statement, reorder correctly
**SYNTAX:** .upsert({data}, {options}).select().single() NOT .upsert({data}).select().single(), {options}


## Learning: 2025-10-19 20:55 - CRITICAL FAILURE PATTERN
**MISTAKE:** Blindly applying regex without verifying results
**USER FEEDBACK:** Not utilizing memory system, not asking what-ifs
**CORRECT APPROACH:**
1. Inspect EXACT current state
2. Define EXACT target state
3. Test approach mentally first
4. Use simplest method (manual line replacement if needed)
5. Verify result before moving on
**NEVER:** Chain multiple regex attempts without verification


## Learning: 2025-10-19 20:55 - Simple Fix After Analysis
**CURRENT:** }, { onConflict: 'username', ignoreDuplicates: false })}).select
**TARGET:** }, { onConflict: 'username', ignoreDuplicates: false }).select
**FIX:** Remove extra }) - changed })}) to })
**METHOD:** Analyze first, then apply simplest regex


## Learning: 2025-10-19 20:56 - Fix Verified Successfully
**STATUS:** Syntax corrected - .upsert with proper options placement
**DEPLOYING:** Pushing fix to Supabase Edge Functions
**NEXT:** Retest with same payload to verify duplicate key error resolved


## Learning: 2025-10-19 20:56 - Deployment Complete
**STATUS:** Code deployed successfully
**TEST:** Retrying same payload that caused duplicate key error
**EXPECTED:** Either success or different error (not duplicate key)


## Learning: 2025-10-19 20:59 - CRITICAL: Memory Utilization Failure
**USER FEEDBACK:** Writing to memory but NOT reading it back to inform decisions
**PROBLEM:** Operating from initial context only, ignoring accumulated learnings
**CORRECT PROTOCOL:** After each brain update, READ IT BACK to use in next decision
**APPLICATION:** Before each action, review relevant learnings from current session


## Learning: 2025-10-19 21:03 - Multiple Issues Identified
**1. FIXED:** Duplicate key - upsert working ?
**2. TIMESTAMP BUG:** Sending ISO string to bigint field - need Unix timestamp
**3. OPENAI QUOTA:** No credits on OpenAI key - function defaulting to OpenAI
**4. CONFIG LOADING:** YAML files not found - falling back to hardcoded OpenAI
**ROOT ISSUE:** Original goal was test Gemini, but config not loading + OpenAI has no quota
**SOLUTION:** Fix config loading OR force Gemini in code OR test with different approach


## Learning: 2025-10-19 21:04 - Config Loading Path Issue Investigation
**ERROR:** /var/tmp/sb-compile-edge-runtime/config/models.yaml not found
**CONFIG.TOML:** static_files = ['./functions/chat-api/config/*.yaml']
**HYPOTHESIS:** Relative path in static_files may not resolve correctly in Edge Runtime
**CHECKING:** Need to verify if YAML files are being bundled with deployment
