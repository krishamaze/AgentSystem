# Intelligent Resurrection System - User Guide

## Overview
The intelligent resurrection system replaces the legacy raw brain dump with an interactive, context-aware interface that helps you quickly understand agent state and determine next actions.

## Usage

\\\powershell
.\resurrect-me.ps1
\\\

## Features

### ?? Brain State Summary
- **Learnings Count:** Total accumulated knowledge entries
- **Pending Tasks:** Detected TODO, Pending, CRITICAL items
- **Active Projects:** Projects in the system with staleness indicators

### ?? Task Detection
Automatically scans brain files for:
- TODO: items
- Pending: work
- Next: steps
- CRITICAL: issues
- Phase N: incomplete work
- Will be / Expected / Awaiting patterns

### ?? Project Scanning
- Lists all projects in D:\AgentSystem\Projects
- Color-coded by activity:
  - ?? Green: Active (< 7 days)
  - ?? Yellow: Recent (7-30 days)
  - ?? Red: Stale (30+ days)

### ?? Latest Evolution
Shows last 3 evolution log entries for context

## Interactive Menu Options

**[1] View all pending tasks**
Displays complete list of detected tasks across all brain files

**[2] View all projects**
Shows detailed project information including paths and last update times

**[3] Full brain dump (legacy)**
Displays raw content of all brain files (original behavior)

**[4] Exit**
Closes the script

## Technical Details

### Functions
- **Parse-BrainFiles:** Analyzes agent brain state and extracts structured data
- **Show-ResurrectionMenu:** Presents interactive UI with context-aware information

### File Locations
- Script: D:\AgentSystem\resurrect-me.ps1
- Staging: D:\AgentSystem\staging\resurrect-me-intelligent.ps1
- Legacy Backup: D:\AgentSystem\Backups\resurrect-me-legacy-*.ps1

## Version History
- **v2.0 (2025-10-20):** Intelligent resurrection with parsing and interactive menu
- **v1.0 (2025-10-19):** Legacy raw brain dump

## Support
For issues or enhancements, update Agent_Primary's brain or spawn a new architect agent.
