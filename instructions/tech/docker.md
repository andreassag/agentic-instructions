# Docker & Container Technical Guidelines

## Dockerfile Conventions
1. Use official minimal base images: prefer `alpine`, `debian-slim`, or distroless over full OS images; document the choice.
2. Multi-stage builds are required for any compiled language: a `builder` stage compiles, the final stage contains only the runtime artifact.
3. Pin base image tags to a specific digest or version tag — never use `latest` in production Dockerfiles.
4. Order `COPY` and `RUN` layers from least- to most-frequently changed to maximize build cache reuse.
5. Combine related `RUN` commands with `&&` into a single layer to avoid layer bloat; clean package manager caches in the same layer (`apt-get clean && rm -rf /var/lib/apt/lists/*`).
6. Run containers as a non-root user: create a dedicated user in the Dockerfile (`RUN useradd -m appuser`) and `USER appuser` before the entrypoint.
7. Use `COPY --chown=user:group` to set file ownership without an extra `RUN chown` layer.
8. Declare all expected volumes with `VOLUME` and all exposed ports with `EXPOSE` — these are documentation, not enforcement.
9. Set a `HEALTHCHECK` instruction for any long-running service container.
10. Use `ENTRYPOINT` for the fixed command and `CMD` for its default arguments; this allows override at `docker run` time.

## .dockerignore
11. Every project with a Dockerfile must have a `.dockerignore`; it must exclude at minimum: `.git/`, `node_modules/`, `__pycache__/`, `*.log`, `*.env`, `.DS_Store`.

## Docker Compose
12. Use `docker compose` (v2) syntax; avoid legacy `docker-compose` (v1).
13. Define services with explicit `image` tags or `build.context` + `build.dockerfile`; never both in the same service.
14. Use named volumes for persistent data; never rely on bind-mounting host paths for production data.
15. Set resource limits (`cpus`, `memory`) for services in production Compose files.
16. Use `depends_on` with `condition: service_healthy` (not just `service_started`) to enforce readiness ordering.
17. Keep secrets out of Compose files; use `secrets:` blocks, `env_file:`, or Docker secrets management.

## Singularity / Apptainer (HPC)
18. For HPC workflows, always build Singularity/Apptainer images from a pinned Docker image (`Bootstrap: docker`, `From: registry/image:tag`) to ensure reproducibility.
19. Use `.def` (definition files) committed to the repository as the source of truth for image builds; do not distribute images built interactively.
20. Enable `--no-home` and `--containall` flags when running sensitive workflows to prevent host filesystem leakage.
21. Bind-mount only the required paths explicitly with `--bind`; rely on `autoMounts` only in trusted Nextflow/Snakemake contexts.
22. Tag image files with the tool version and build date: `toolname_1.2.3_2025-01-15.sif`.
23. Cache `.sif` files in a shared project directory (e.g., `/path/to/project/containers/`) specified in Nextflow's `singularity.cacheDir` or Snakemake's `--singularity-prefix`.
