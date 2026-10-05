---
name: preview
description: Local development server management. Start, stop, restart, and health-check the preview server. Use when the user needs to run or check their local dev environment.
when_to_use: "When the user runs /preview, asks to start the server, wants to check if the app is running, or needs to manage the dev server lifecycle."
version: 1.0.0
---

# Preview — Local Dev Server Management

> Manage the local development server lifecycle.

---

## Commands

| Command | Action |
|---------|--------|
| `/preview` | Show current server status |
| `/preview start` | Start the dev server |
| `/preview stop` | Stop the dev server |
| `/preview restart` | Restart the server |
| `/preview check` | Run a health check |

---

## Auto-Detection

Detect the project type and use the appropriate command:

| Project Type | Start Command |
|---|---|
| Next.js / React | `npm run dev` |
| Vite | `npm run dev` |
| Python (FastAPI/Flask) | `uvicorn main:app --reload` or `flask run` |
| Go | `go run ./cmd/...` |
| Rust | `cargo run` |
| Node.js | `npm start` or `node server.js` |

---

## Status Response Format

```
=== Preview Status ===

[WEB] URL: http://localhost:3000
[DIR] Project: /path/to/project
Type: nextjs
[HEALTHY] Health: OK
```

---

## Port Conflict Handling

If the port is already in use:

```
[WARNING] Port 3000 is in use.

Options:
1. Start on port 3001
2. Kill process on port 3000
3. Specify a different port

Which one? (default: 1)
```

---

## Technical Scripts

```bash
python .agents/scripts/auto_preview.py start [port]
python .agents/scripts/auto_preview.py stop
python .agents/scripts/auto_preview.py status
```
