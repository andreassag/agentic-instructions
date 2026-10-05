---
name: status
description: Display current project and agent status. Shows task progress, agent activity, file statistics, and preview server state.
when_to_use: "When the user runs /status, asks for project progress, wants to see what agents are doing, or needs a summary of the current session state."
version: 1.0.0
---

# Status — Project & Agent Status Board

> A single-glance summary of what's happening in the project.

---

## What It Shows

1. **Project Info** — Name, path, tech stack, active features
2. **Agent Status Board** — Which agents ran, what they completed, what's pending
3. **File Statistics** — Files created/modified in this session
4. **Preview Status** — Server URL and health

---

## Status Output Format

```
=== Project Status ===

[DIR] Project: my-app
     Path: /projects/my-app
[TAG] Type: nextjs
[METRICS] Status: active

[TOOL] Tech Stack:
   Framework: next.js
   Database: postgresql

[OK] Features (N):
   • feature-1
   • feature-2

[PENDING] Pending (N):
   • pending-feature

[FILE] Files: N created, N modified

=== Agent Status ===

[OK] database-architect -> Completed
[OK] backend-specialist -> Completed
[SYNC] frontend-specialist -> In progress (60%)
[PENDING] test-engineer -> Waiting

=== Preview ===

[WEB] URL: http://localhost:3000
[HEALTHY] Health: OK
```

---

## Technical Scripts

```bash
python .agents/scripts/session_manager.py status
python .agents/scripts/auto_preview.py status
```
