---
name: preview
description: Preview server start, stop, and status check. Local development server management.
version: 1.0.0
requires_agents: frontend-specialist
requires_skills: verify-changes
artifact_outputs: preview-status, runtime-findings
---

# /preview - Preview Management

$ARGUMENTS

---

## Task

Manage preview server: start, stop, status check.

### Commands

```
/preview           - Show current status
/preview start     - Start server
/preview stop      - Stop server
/preview restart   - Restart
/preview check     - Health check
```

---

## Usage Examples

### Start Server
```
/preview start

Response:
[START] Starting preview...
   Port: 3000
   Type: Next.js

[OK] Preview ready!
   URL: http://localhost:3000
```

### Status Check
```
/preview

Response:
=== Preview Status ===

[WEB] URL: http://localhost:3000
[DIR] Project: C:/projects/my-app
[TAG]️ Type: nextjs
[HEALTHY] Health: OK
```

### Port Conflict
```
/preview start

Response:
[WARNING] Port 3000 is in use.

Options:
1. Start on port 3001
2. Close app on 3000
3. Specify different port

Which one? (default: 1)
```

---

## Technical

Auto preview uses `auto_preview.py` script:

```bash
python .agents/scripts/auto_preview.py start [port]
python .agents/scripts/auto_preview.py stop
python .agents/scripts/auto_preview.py status
```

