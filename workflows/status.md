---
name: status
description: Display agent and project status. Progress tracking and status board.
version: 1.0.0
requires_agents: orchestrator
requires_skills: context-compression
artifact_outputs: status-report
---

# /status - Show Status

$ARGUMENTS

---

## Task

Show current project and agent status.

### What It Shows

1. **Project Info**
   - Project name and path
   - Tech stack
   - Current features

2. **Agent Status Board**
   - Which agents are running
   - Which tasks are completed
   - Pending work

3. **File Statistics**
   - Files created count
   - Files modified count

4. **Preview Status**
   - Is server running
   - URL
   - Health check

---

## Example Output

```
=== Project Status ===

[DIR] Project: my-ecommerce
 Path: C:/projects/my-ecommerce
[TAG]️ Type: nextjs-ecommerce
[METRICS] Status: active

[TOOL] Tech Stack:
   Framework: next.js
   Database: postgresql
   Auth: clerk
   Payment: stripe

[OK] Features (5):
   • product-listing
   • cart
   • checkout
   • user-auth
   • order-history

[PENDING] Pending (2):
   • admin-panel
   • email-notifications

[FILE] Files: 73 created, 12 modified

=== Agent Status ===

[OK] database-architect -> Completed
[OK] backend-specialist -> Completed
[SYNC] frontend-specialist -> Dashboard components (60%)
[PENDING] test-engineer -> Waiting

=== Preview ===

[WEB] URL: http://localhost:3000
[HEALTHY] Health: OK
```

---

## Technical

Status uses these scripts:
- `python .agents/scripts/session_manager.py status`
- `python .agents/scripts/auto_preview.py status`
