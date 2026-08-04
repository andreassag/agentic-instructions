# Agent Debugging Guidelines

## Methodology
1. Reproduce the failure before attempting a fix: confirm the bug exists in the current state by running the failing test, reproducing the error, or observing the incorrect output.
2. Isolate before fixing: narrow down the failing scope (which function, which input, which condition) before touching any code.
3. Form a specific hypothesis before each change: "I believe the bug is caused by X because of Y evidence." Test the hypothesis; if it is wrong, form a new one rather than making random changes.
4. Change one thing at a time; do not apply multiple speculative fixes simultaneously — this makes it impossible to know which change resolved the issue.

## Investigation
5. Read the full error message and stack trace before looking at the code; the location of the error is often not the source of the bug.
6. Add logging or assertions to confirm your hypothesis about state at a specific point in the code; remove them when the fix is confirmed.
7. Use binary search (bisect) to locate where correct behaviour diverges: test at the midpoint of the suspected range of commits or code paths, then narrow recursively.
8. Check recent changes first: if the bug is newly introduced, `git log --oneline -20` and `git blame` narrow the search quickly.

## Fixing & Verifying
9. Fix the root cause, not the symptom; a patch that suppresses an error message without addressing why it occurred is not a fix.
10. After applying a fix, run the exact reproduction case that failed to confirm it is resolved.
11. Run the full relevant test suite after the fix to confirm no regressions were introduced.
12. Document the fix with a comment if the root cause is non-obvious: explain what was wrong and why the fix works.
