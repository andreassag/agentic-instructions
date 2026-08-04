# obsidian-ai Setup Guide

**obsidian-ai** ([sup3rus3r/obsidian-ai](https://github.com/sup3rus3r/obsidian-ai)) is an open-source visual platform for building, managing, and running AI agents — no SDKs or boilerplate required.

> [!NOTE]
> obsidian-ai is **optional** and is not installed automatically by `install.sh`. It is a full web application (FastAPI backend + Next.js frontend), not a CLI binary. Use the Docker Compose setup below for the quickest path to getting it running.

---

## Quick Start with Docker Compose

A `docker-compose.yml` is provided in this directory for running obsidian-ai locally.

### 1. Prerequisites

- [Docker](https://docs.docker.com/get-docker/) 24+
- [Docker Compose](https://docs.docker.com/compose/install/) v2+ (`docker compose` — note: no hyphen)
- The obsidian-ai source repository cloned locally

### 2. Clone obsidian-ai

Clone the project **next to** this repo, or anywhere convenient:

```bash
git clone https://github.com/sup3rus3r/obsidian-ai.git
```

### 3. Create a `.env` file

Copy the template below and save it as `.env` in the **same directory as `docker-compose.yml`**:

```bash
# ── Required ──────────────────────────────────────────────────────────────────
# A long random secret used to sign JWT tokens. Generate one with:
#   python3 -c "import secrets; print(secrets.token_hex(32))"
SECRET_KEY=replace_with_a_random_secret

# ── Optional LLM provider keys ─────────────────────────────────────────────
# Set the keys for whichever providers you want to use.
# You can add these later from the UI too.
OPENAI_API_KEY=
ANTHROPIC_API_KEY=
GOOGLE_API_KEY=

# ── Database (default: SQLite, zero config) ────────────────────────────────
# Change to MongoDB URI for production multi-user deployments.
DATABASE_URL=sqlite:///./data/obsidian.db

# ── JWT settings ───────────────────────────────────────────────────────────
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=1440

# ── Frontend → Backend URL (must match what your browser can reach) ────────
NEXT_PUBLIC_API_URL=http://localhost:8000

# ── CORS: allow the frontend origin to call the backend ───────────────────
CORS_ORIGINS=http://localhost:3000
```

### 4. Adjust the volume path

By default the `docker-compose.yml` expects the obsidian-ai repo at `./obsidian-ai` relative to where you run the compose file. If you cloned it elsewhere, update the `volumes:` paths:

```yaml
# docker-compose.yml — change these two lines:
  - ./obsidian-ai/backend:/app      # ← backend source
  - ./obsidian-ai/frontend:/app     # ← frontend source
```

### 5. Start the stack

```bash
# From the directory containing docker-compose.yml and .env:
docker compose up -d
```

Then open **http://localhost:3000** in your browser.

On first run, Docker will:
1. Install Python dependencies inside the backend container (~60–90s)
2. Install Node.js dependencies inside the frontend container (~60–120s)

Subsequent starts are fast because `node_modules` and the database are persisted in named volumes.

---

## Common Commands

```bash
# Start in background
docker compose up -d

# View live logs
docker compose logs -f

# View backend logs only
docker compose logs -f backend

# Stop (keeps data)
docker compose stop

# Stop and remove containers (keeps volume data)
docker compose down

# Full teardown including all data volumes
docker compose down -v

# Rebuild after source changes
docker compose up -d --build

# Open a shell in the backend container
docker compose exec backend bash
```

---

## Accessing the API

Once running, the FastAPI backend exposes:

| URL | Description |
|---|---|
| `http://localhost:8000` | REST API root |
| `http://localhost:8000/docs` | Swagger UI (interactive API docs) |
| `http://localhost:8000/redoc` | ReDoc API docs |
| `http://localhost:8000/health` | Health check endpoint |

---

## Architecture

```
┌──────────────────────────────────────────────────────────────┐
│  Browser → http://localhost:3000                             │
│  Next.js frontend (React 19, Tailwind CSS)                   │
└────────────────────────┬─────────────────────────────────────┘
                         │ HTTP / SSE
┌────────────────────────▼─────────────────────────────────────┐
│  http://localhost:8000                                        │
│  FastAPI backend (Python 3.12, uvicorn)                      │
│  ├── Auth: JWT + TOTP 2FA                                    │
│  ├── LLM: OpenAI / Anthropic / Google / Ollama / OpenRouter  │
│  ├── Memory: FAISS vector store (per-session and KB)         │
│  ├── Tools: HTTP, Python, MCP Protocol                       │
│  └── Storage: SQLite (default) or MongoDB                    │
└────────────────────────┬─────────────────────────────────────┘
                         │
              ┌──────────▼──────────┐
              │  obsidian_data vol  │
              │  (SQLite DB, uploads│
              │   FAISS indexes)    │
              └─────────────────────┘
```

---

## Switching to MongoDB

For multi-user or production deployments, switch to MongoDB:

```bash
# In .env:
DATABASE_URL=mongodb://mongo:27017/obsidian
```

Add a MongoDB service to `docker-compose.yml`:

```yaml
  mongo:
    image: mongo:7
    container_name: obsidian-ai-mongo
    volumes:
      - mongo_data:/data/db
    restart: unless-stopped

volumes:
  mongo_data:
    driver: local
```

---

## Troubleshooting

**Backend not starting?**
```bash
docker compose logs backend
# Common: missing SECRET_KEY → add it to .env
```

**Frontend can't reach backend?**
- Ensure `NEXT_PUBLIC_API_URL=http://localhost:8000` in `.env`
- The backend container must be healthy before the frontend starts (enforced by `depends_on`)

**Permission denied on volume?**
```bash
# Reset all data and restart fresh:
docker compose down -v
docker compose up -d
```

**Slow first start?**
- Normal — pip and npm install on first boot. Use `docker compose logs -f` to watch progress.

---

## Further Reading

- [obsidian-ai README](https://github.com/sup3rus3r/obsidian-ai)
- [Docker Compose reference](https://docs.docker.com/compose/compose-file/)
