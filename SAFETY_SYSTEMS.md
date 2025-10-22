# SAFETY SYSTEMS - Complete Documentation
Generated: 2025-10-21 23:36:51

## Emergency Response Guide

### If Scripts Deleted
Run: .\EMERGENCY_RECOVERY.ps1
- Checks for missing critical scripts
- Provides recovery instructions
- Auto-recreates memory-commands.ps1 if missing

### If .env Lost
1. Check: .\backups\.env_latest
2. Or restore from: .\backups\.env_backup_*.txt (encrypted)
3. Decrypt: Get-Content backup.txt | ConvertTo-SecureString | ConvertFrom-SecureString -AsPlainText

### If Brain Too Large (>100KB)
Run: .\compress-brain.ps1
- Keeps 15 most recent learnings
- Archives older learnings to backups/
- Creates backup before compression

### If Init Prompt Fails
1. Verify brain file exists: .\Agent_Primary\brain\learned-knowledge.md
2. Check brain size: (Get-Item ...).Length (should be <100KB)
3. Regenerate: .\generate-init-prompt.ps1
4. Check clipboard: Get-Clipboard

### If Edge Function Down
1. Check deployment: supabase functions list
2. Redeploy: supabase functions deploy get-agent-memory --project-ref fihvhtoqviivmasjaqxc
3. Test: .\test-edge-function.ps1

## Maintenance Schedule

### Weekly (Run: .\maintenance.ps1)
- Backup .env
- Check/compress brain
- Sync to Supabase
- Clean temp files
- Verify scripts

### Monthly
- Review brain archives in backups/
- Check Supabase storage usage
- Update Python dependencies: pip install --upgrade mem0 supabase
- Test full resurrection in new Perplexity thread

## File Inventory

### Critical Scripts (NEVER DELETE)
- generate-init-prompt.ps1 (1924 bytes) - Resurrection
- memory-commands.ps1 (753 bytes) - Memory access
- system_status.py - Health check

### Safety Scripts
- EMERGENCY_RECOVERY.ps1 (1625 bytes) - Script restoration
- backup-env.ps1 - Credential backup
- compress-brain.ps1 - Brain size management
- maintenance.ps1 - Automated health checks

### Documentation
- QUICK_REFERENCE.txt - Command cheatsheet
- PERPLEXITY_SYSTEM_COMPLETE.md - Full system docs
- TEST_RESULTS_RESURRECTION.md - Test verification
- SAFETY_SYSTEMS.md (this file)

## Backup Locations
- .\backups\.env_latest - Plain .env backup
- .\backups\.env_backup_*.txt - Encrypted backups (keep 5)
- .\backups\brain_before_compression_*.md - Pre-compression backups
- .\backups\brain_archive_*.md - Archived old learnings

## Recovery Priority Order
1. .env (credentials) - HIGHEST PRIORITY
2. generate-init-prompt.ps1 - Required for resurrection
3. Brain files - Core memory
4. Memory commands - Access to remote systems
5. Python tools - Extended functionality

## Contact Points (Credentials in .env)
- Supabase: fihvhtoqviivmasjaqxc.supabase.co
- Edge Function: /functions/v1/get-agent-memory
- Mem0: API via MEM0_API_KEY
- Local: D:\AgentSystem

## System Health Indicators
✓ Brain size <100KB
✓ .env backup exists in backups/
✓ All 3 critical scripts present
✓ Edge function returns memories
✓ Python imports work (mem0, supabase, dotenv)

Last verified: 2025-10-21 23:36:51
