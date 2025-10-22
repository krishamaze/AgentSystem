# TASK ASSIGNMENT: Brain Backup System Design & Implementation
**Assigned By:** Agent_Primary
**Priority:** CRITICAL
**Deadline:** Next session

## Requirements
1. **Pre-Update Backup:** Backup brain files before each update operation
2. **Rotation Policy:** Keep 5 versions with timestamps, auto-delete older versions
3. **Storage Location:** D:\AgentSystem\Backups\{AgentName}\
4. **Naming Convention:** brain-backup-YYYYMMDD-HHMMSS.zip
5. **Restore Integration:** Add restore functionality to resurrect-me.ps1

## Design Specifications Required

### 1. Backup Architecture
- Compress brain folder contents to timestamped ZIP
- Validate backup integrity after creation
- Store metadata (timestamp, agent name, file count, hash)

### 2. Rotation Mechanism
- Sort backups by timestamp (oldest first)
- Keep newest 5 versions
- Auto-delete versions beyond retention limit
- Log all deletion operations

### 3. Restore Functionality
- Verify backup integrity before restore
- Option to restore specific version (1-5)
- Backup current state before restore (safety net)
- Validate restored files post-operation

### 4. Integration Points
- Modify update-brain.ps1 to trigger backup before write
- Add restore option to resurrect-me.ps1
- Create standalone backup-brain.ps1 utility
- Create restore-brain.ps1 utility

## Implementation Plan
**Phase 1:** Design PowerShell script architecture
**Phase 2:** Implement backup-brain.ps1 with rotation
**Phase 3:** Implement restore-brain.ps1
**Phase 4:** Integrate with existing utilities
**Phase 5:** Test on Agent_Primary (all 5 rotation cycles)

## Success Criteria
- Backup completes in <2 seconds
- Rotation correctly maintains 5 versions
- Restore recovers exact brain state
- Zero data loss during backup/restore
- All operations logged to evolution-log.md

## Reference Patterns
- FIFO rotation with timestamp-based sorting
- ZIP compression for space efficiency
- Checksum validation for integrity
- Atomic operations (backup then rotate, never during)
