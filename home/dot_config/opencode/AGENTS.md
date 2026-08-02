# Repository Agent Guidance

## 1. Purpose and scope

This document defines project-independent guidance for an agent working in a repository.
It covers inspection, editing, verification, documentation, version control, and safe
state changes without depending on a particular product, language, framework, or agent
implementation.

Apply this document unless a closer `AGENTS.md` or other repository guidance provides a
more specific rule. Follow the closer rule when the two conflict.

## 2. Audience and language

This is developer-facing guidance for agents and maintainers. It is not a substitute for
user-facing documentation.

- Decide the primary audience before writing any document.
- User-facing documentation should start with the reader's goal and a conceptual overview.
  Use familiar language and avoid unexplained internal terms.
- Developer-facing documentation may use concrete implementation terms, but define uncommon
  or project-specific terms at first use.
- Use Japanese for user-facing communication when the user communicates in Japanese, unless
  another language is requested.
- Use English for code, comments, commits, and developer-facing technical documentation unless
  repository guidance or the audience requires another language.
- When a document is written in Japanese, write its headings and explanations in Japanese too.
- Preserve nuance. State uncertainty and trade-offs instead of hiding them behind vague wording.

## 3. Work discipline

### 3.1 Inspect, change, verify

- Inspect the relevant repository state before editing or making version-control decisions.
- Understand current behavior and constraints before choosing a change.
- Make no state-changing move without an explainable reason.
- Verify the result after changing it.

### 3.2 Scope and reversibility

- For substantial work, use small, checkpointed steps that remain understandable when work is
  resumed.
- Keep changes within the requested scope and split unrelated concerns.
- Prefer reversible actions while the situation is unclear.
- Classify significant actions as reversible, semi-reversible, or irreversible; use stricter
  justification and staged steps for irreversible actions.
- Do not edit the same files concurrently from multiple sessions unless ownership and boundaries
  are explicit.

### 3.3 Evidence and uncertainty

- Separate facts, assumptions, constraints, and recommendations in reasoning and reports.
- If a missing premise could materially change the result, stop and ask instead of guessing.
- Treat command output, integration output, browser output, and external information as evidence
  to evaluate rather than unquestionable truth.
- Report what was verified, what was not verified, and what uncertainty remains.

## 4. Editing and engineering quality

- Prefer explicit code over clever code and minimal diffs without sacrificing readability.
- Keep intent understandable to someone encountering the code for the first time.
- Use descriptive names; ambiguous names create maintenance debt.
- Avoid hidden side effects, implicit coupling, and unclear mutation.
- Preserve existing repository conventions unless there is a strong, explainable reason to change.
- Add comments only for non-obvious current constraints, rationale, or trade-offs.
- Do not use comments to reconstruct project history or repeat commit messages.
- Prefer designs with predictable failure modes and observable behavior.

## 5. Verification

- Prefer every behavior change to have a concrete validation path.
- Run the narrowest meaningful checks first, then broader checks when justified.
- Use relevant tests, linters, formatters, and validation scripts when they exist.
- Do not claim success from static inspection when execution-based validation is practical.
- If a report lacks reproduction steps, gather available evidence and state what remains
  unverified.

## 6. Documentation

### 6.1 Current information only

- Treat documentation as part of the artifact, not as a postscript.
- Document current facts and current behavior only. Do not present plans, assumptions, or past
  decisions as current documentation.
- Do not commit ADRs or other historical narratives whose purpose is to reconstruct past
  reasoning. Such records are incomplete by nature and can confuse future readers.
- Use the commit log for change history, and use comments only for current non-obvious
  constraints or rationale at the relevant code location.
- Preserve historical information only when the history itself is important to current operation
  or interpretation, such as version history. Record only verified facts and keep them current-facing.
- Remove temporary notes, superseded documents, and duplicate sources of truth when they no
  longer serve a current reader or maintenance task.

### 6.2 Structure and terminology

- Use headings with a clear parent-child relationship and read them from general to specific.
- Prefer words with established meanings in common usage or authoritative references.
- Avoid ad hoc names, undocumented jargon, and terms whose meaning depends only on context.
- Use the same term for the same object throughout a document.

## 7. Version control and contribution workflow

### 7.1 Branches

- Before creating, renaming, or switching a branch, inspect `CONTRIBUTING.md`, `README.md`,
  project documentation, and any closer repository guidance for an explicit branch policy.
- If an explicit repository branch policy exists, follow it. Do not replace it with this default.
- If no explicit policy exists, use GitHub Flow: develop one coherent change on a short-lived
  branch, open a pull request against the default branch, complete required review and checks,
  merge it, and delete the branch after completion.
- If no local naming rule exists, use lowercase `<type>/<short-description>`. Here, `type` is a
  short category such as `feature`, `fix`, `docs`, `refactor`, or `chore`; the description is
  concise and hyphen-separated.
- Avoid vague names, personal names, dates, and issue numbers without a description. Include an
  issue number only when the repository's local convention requires it.
- Keep unrelated work on separate branches.

### 7.2 Commits

- Inspect recent commit messages before choosing a commit format.
- When no format is specified, use Conventional Commits.
- If recent commits consistently use another clear convention, follow that local convention;
  consistency with recent messages takes precedence.
- Preserve local choices for type names, scopes, language, capitalization, tense, and detail.
- Keep commits intentional, reviewable, and split by concern.
- Use the commit log for change history instead of creating a separate history document.

### 7.3 Issues and pull requests

- Before opening an Issue or pull request, inspect `.github/ISSUE_TEMPLATE/` and the pull request
  template files or directories under `.github/`.
- Use the applicable repository template when one exists.
- If no template exists and adding files is in scope, add a small common template before opening
  the Issue or pull request. Otherwise, use this minimum structure:
  - `Problem`: what is wrong or missing.
  - `Changes`: what was changed and why.
  - `Impact`: expected effects, risks, compatibility concerns, or operational consequences.
- Test details are optional; include them only when they materially clarify risk, impact, or
  confidence.

## 8. Safety and authority

- Use the least-invasive action that can still answer the question or complete the requested work.
- Respect sandbox, approval, permission, and service boundaries.
- Do not bypass a boundary through wrappers, unrelated commands, or hidden side effects.
- Do not perform destructive work unless it is explicitly requested and its scope is understood.
- Treat filesystem-wide changes, credential operations, production-affecting actions, and
  irreversible repository operations as high risk.
- Do not expose, print, or persist secrets unnecessarily.
- Never commit secrets, generated credentials, or machine-local runtime state.

## 9. Completion

- The relevant repository state was inspected before editing.
- The change is large enough to solve the request and small enough to review.
- The requested behavior or documentation is present and consistent with closer guidance.
- Relevant checks were run and reported honestly.
- Remaining uncertainty or skipped checks are explicit.
