---
name: code-review-checklist
description: Code review guidelines covering code quality, security, and best practices.
when_to_use: "When reviewing code for quality, security, and best practices. When the user says 'review my code' or 'check this PR'."
allowed-tools: Read, Glob, Grep
version: 1.0.0
---

# Code Review Checklist

## Quick Review Checklist

### Correctness
- [ ] Code does what it's supposed to do
- [ ] Edge cases handled
- [ ] Error handling in place
- [ ] No obvious bugs

### Security
- [ ] Input validated and sanitized
- [ ] No SQL/NoSQL injection vulnerabilities
- [ ] No XSS or CSRF vulnerabilities
- [ ] No hardcoded secrets or sensitive credentials
- [ ] **AI-Specific:** Protection against Prompt Injection (if applicable)
- [ ] **AI-Specific:** Outputs are sanitized before being used in critical sinks

### Performance
- [ ] No N+1 queries
- [ ] No unnecessary loops
- [ ] Appropriate caching
- [ ] Bundle size impact considered

### Code Quality
- [ ] Clear naming
- [ ] DRY - no duplicate code
- [ ] SOLID principles followed
- [ ] Appropriate abstraction level

### Testing
- [ ] Unit tests for new code
- [ ] Edge cases tested
- [ ] Tests readable and maintainable

### Documentation
- [ ] Complex logic commented
- [ ] Public APIs documented
- [ ] README updated if needed

## AI & LLM Review Patterns

### Logic & Hallucinations
- [ ] **Chain of Thought:** Does the logic follow a verifiable path?
- [ ] **Edge Cases:** Did the AI account for empty states, timeouts, and partial failures?
- [ ] **External State:** Is the code making safe assumptions about file systems or networks?

### Prompt Engineering Review
```markdown
// [NO] Vague prompt in code
const response = await ai.generate(userInput);

// [OK] Structured & Safe prompt
const response = await ai.generate({
  system: "You are a specialized parser...",
  input: sanitize(userInput),
  schema: ResponseSchema
});
```

## Anti-Patterns to Flag

```typescript
// [NO] Magic numbers
if (status === 3) { ... }

// [OK] Named constants
if (status === Status.ACTIVE) { ... }

// [NO] Deep nesting
if (a) { if (b) { if (c) { ... } } }

// [OK] Early returns
if (!a) return;
if (!b) return;
if (!c) return;
// do work

// [NO] Long functions (100+ lines)
// [OK] Small, focused functions

// [NO] any type
const data: any = ...

// [OK] Proper types
const data: UserData = ...
```

## Review Comments Guide

```
// Blocking issues use [CRITICAL]
[CRITICAL] BLOCKING: SQL injection vulnerability here

// Important suggestions use [WARN]
[WARN] SUGGESTION: Consider using useMemo for performance

// Minor nits use [OK]
[OK] NIT: Prefer const over let for immutable variable

// Questions use [QUESTION]
[QUESTION] QUESTION: What happens if user is null here?
```
