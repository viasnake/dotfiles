# coding-style.md

## Scope
This document defines the default coding conventions applied across all projects,
unless explicitly overridden by project-level rules.

Consistency, readability, and maintainability take precedence over personal preference.

---

## Core Values

- Readability is not a matter of taste; it is the minimization of comprehension cost.
- Prefer explicitness over cleverness.
- Prefer small, reviewable changes over large refactors.
- Prefer clear and observable failure modes over silent behavior.
- Operability (diagnosability and observability) is part of correctness.

Code must be designed so that
**another person (including your future self) can understand it correctly
in the shortest possible time**.

---

## Naming

- Avoid abbreviations unless they are widely recognized industry standards.
- Names must reveal intent clearly.
- Types / classes: nouns (e.g. `ConfigLoader`, `TokenBucket`).
- Functions / methods: verbs (e.g. `parseConfig`, `buildIndex`).
- Booleans:
  - Use `is*`, `has*`, `can*`, `should*`.
  - Avoid negative forms such as `isNotX`.

Names are the most important form of documentation.
Ambiguous naming is technical debt.

---

## Structure & Modularity

- Each module, class, or function must have a single primary responsibility.
- Prefer composition over deep inheritance.
- Treat public interfaces as high-cost boundaries.
- Avoid global state, implicit side effects, and hidden dependencies.

The structure must make it clear
**what breaks when something is changed**.

---

## Error Handling

- Fail fast on invalid input.
- Never swallow errors silently.
- If recovery is performed, the reason must be explainable.
- Errors must carry sufficient context:
  - what failed
  - where it failed
  - under which input or condition
- Use structured or typed errors when callers need to branch behavior.

---

## Logging & Observability

- Logs are for operators, not developer notes.
- Logs must contain actionable information:
  - identifiers
  - boundaries
  - hints for next actions
- Never log secrets, tokens, or personally identifiable information.
- Prefer structured logging where available.
- Emit metrics on critical paths and failure points.

A system that cannot be observed cannot be operated.

---

## Configuration & Secrets

- Configuration must be explicit and discoverable.
- Do not hardcode environment-specific values.
- Secrets must never be committed, logged, or printed.
- If a secret may have been exposed, treat it as compromised
  and rotate accordingly.

---

## Comments

- Comments explain *why*, not *what*.
- Use comments to document:
  - non-obvious trade-offs
  - constraints and invariants
  - reasons for seemingly odd behavior
- Stale comments are worse than no comments.
- Avoid emojis in comments unless they materially improve comprehension.

---

## Documentation in Code

- Public APIs must document:
  - purpose
  - inputs and outputs
  - failure modes
  - constraints and invariants
- Include minimal usage examples only when they prevent misuse.
- Prefer linking to ADRs or design documents for non-trivial decisions.

---

## Tests

- Tests are part of the artifact.
- Untested behavior is undefined by default.
- Avoid flaky tests (e.g., time-dependent behavior).
- Prioritize tests for:
  - boundary conditions
  - error cases
  - regression of fixed bugs
- If tests are impractical, document the alternative verification strategy.

---

## Backwards Compatibility

- Breaking changes must be explicit and justified.
- Provide migration steps or compatibility layers when reasonable.
- Never change behavior silently under the same interface.

---

## Performance

- Do not micro-optimize without evidence.
- Prefer clarity and structural simplicity.
- Measure before optimizing.
- When introducing caching, define:
  - invalidation strategy
  - failure behavior

---

## Security

- Treat inputs as untrusted by default.
- Validate, sanitize, and constrain inputs at boundaries.
- Prefer allow-lists over deny-lists.
- Follow the principle of least privilege.

---

## Working Outside Your Domain

- Assume you are not an expert in this domain.
- Do not implement based on guesswork.
- Explicitly label unknowns and assumptions.
- Increase abstraction and thicken boundaries.
- Minimize the blast radius of changes.
- Leave structures that domain experts can safely modify later.

**Using AI is not a reason to lower readability requirements;
it is a reason to raise them.**

---

## Overrides

These defaults may be overridden only when:
- a project-level style guide exists, or
- the language or ecosystem has strong conventions, or
- performance or environmental constraints require it.

In all cases, document the reason and the scope of the exception.
