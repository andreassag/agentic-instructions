# Agent Documentation Guidelines

## Documentation Alongside Code
1. Update documentation in the same PR/commit as the code change it describes; documentation debt accumulates faster than technical debt.
2. For any new public function, class, or module, the documentation must be written before the task is considered complete.
3. For any breaking change, the migration path must be documented alongside the change — not in a follow-up issue.

## Writing Style
4. Write for the reader who is using the API, not the developer who wrote it. Assume the reader is competent but unfamiliar with this codebase.
5. Prefer short sentences and active voice; avoid jargon unless it is defined in a glossary.
6. Lead with a working example before detailed explanation — code is often clearer than prose for technical concepts.
7. Document the *why* and *when* for non-obvious design decisions; the *what* and *how* should be apparent from the code itself.

## README Conventions
8. Every project README must include, in order: one-line description, install/setup steps (that actually work in a fresh environment), a quickstart example, and a link to fuller documentation.
9. Keep the quickstart example minimal and functional; test it regularly (ideally as part of CI).
10. Do not document unimplemented or planned features as if they exist; clearly label roadmap items as "planned" or "not yet implemented."

## Architectural Decisions
11. Record significant architectural decisions in `docs/adr/` as Architecture Decision Records (ADR); use the template: Context → Decision → Consequences.
12. ADRs are append-only: never delete or overwrite an accepted ADR; instead, write a new ADR that supersedes it.
13. Link ADRs from the relevant code with a comment: `// See docs/adr/0003-use-postgres.md`.

## Changelogs
14. Maintain `CHANGELOG.md` in Keep a Changelog format with sections: `Added`, `Changed`, `Deprecated`, `Removed`, `Fixed`, `Security`.
15. Update the changelog for every user-facing change in the same commit; do not batch changelog updates at release time.
