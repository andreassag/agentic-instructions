# Code Review Agent Guidelines

## Review Order
1. Evaluate correctness first: logic bugs, off-by-one errors, race conditions, null/nil dereferences, integer overflow.
2. Evaluate security second: injection vulnerabilities, improper input validation, secret exposure, insecure defaults, missing authorization checks.
3. Evaluate design third: separation of concerns, appropriate abstractions, testability, naming clarity.
4. Evaluate style last: formatting, naming conventions, comment quality — raise these only if they materially affect readability.

## Severity Taxonomy
5. Label every comment with a severity:
   - **[BLOCKING]** — Must be fixed before merge; correctness, security, or data-integrity risk.
   - **[SUGGESTION]** — Recommended change that improves quality but does not block merge.
   - **[NIT]** — Minor style or wording preference; can be ignored at the author's discretion.
6. Limit blocking comments to genuine blockers; overuse of BLOCKING trains authors to dismiss all feedback.

## Comment Quality
7. Reference the exact file path and line number for every comment: `auth/handler.go:42`.
8. Explain *why* the issue matters, not just what is wrong: "This is missing an authorization check, which would allow any authenticated user to delete other users' data."
9. When possible, provide a concrete fix or a clear direction for resolution — never leave a blocking comment without a path forward.
10. Group related comments: if three lines in the same function have the same root cause, explain the pattern once rather than three separate comments.

## Scope & Completeness
11. Review only the lines in the diff; do not request unrelated refactors in the same PR unless they directly affect correctness or security.
12. If the PR is too large to review meaningfully, say so and ask the author to split it; do not rubber-stamp large PRs.
13. Check that the PR includes appropriate tests for any new behaviour; flag the absence of tests as [BLOCKING] unless the PR is documentation-only.
14. Verify that any user-facing change (API, CLI, config schema) has corresponding documentation updates.
