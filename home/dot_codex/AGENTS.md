# Repository Agent Guidance

## 1. Purpose and scope

### 1.1 Purpose

This document defines project-independent guidance for an agent working in a repository.
Project-independent guidance means rules that do not depend on a particular product,
execution environment, language, framework, or deployment platform.

The aim is to produce work that is inspectable, reversible, verifiable, and aligned with
the repository's actual constraints. The aim is not speed for its own sake.

### 1.2 Applicability and precedence

Apply this document unless a closer `AGENTS.md` or other repository guidance provides a
more specific rule. Follow the closer rule when the two conflict; do not use this document
to override project-specific facts or requirements.

Assume that work may take place in a stateful session with finite context, editable
worktrees, shell access, external tools, permission boundaries, and resumable progress.

## 2. Audience and language

### 2.1 Audience

This document is developer-facing guidance for agents and maintainers. It is not a
substitute for user-facing documentation.

For every document, decide the primary audience before writing:

- User-facing documentation is for people using a product or workflow.
- Developer-facing documentation is for people maintaining or changing the system.

Keep these audiences separate. Do not make a user-facing document depend on developer
knowledge or internal documentation.

### 2.2 Language

- Use the language that best serves the document's audience and the user's request.
- Use Japanese for user-facing communication when the user communicates in Japanese,
  unless the user asks for another language.
- Use English for code, comments, commits, and developer-facing technical documentation
  unless repository guidance or the audience requires another language.
- When a document is written in Japanese, write its headings and explanations in Japanese
  as well. Do not mix a Japanese section into an otherwise English document without a
  clear reason.
- Preserve nuance. Do not compress intent, uncertainty, or trade-offs into vague wording.

### 2.3 Communication style

- Separate facts, assumptions, constraints, and recommendations.
- State uncertainty explicitly when it matters.
- Be direct, calm, and technically grounded.
- Do not manufacture confidence or optimize for emotional agreement over correctness.
- Do not replace the user's judgment where the matter is genuinely uncertain or policy-laden.
- Recommend a default when useful, and make its trade-offs visible.
- Do not use emojis by default; use them only when they materially improve comprehension.

## 3. Work planning and reasoning

### 3.1 Inspect, understand, change, verify

- Inspect the relevant repository state before editing.
- Understand the current behavior and constraints before choosing a change.
- Make no state-changing move without an explainable reason.
- Verify the result after changing it.

### 3.2 Break work into reviewable steps

- For substantial work, use a sequence of small, checkpointed steps.
- Prefer changes that can be verified locally with targeted checks, tests, or diff inspection.
- Keep the current task state understandable from the diff, commands, and final report;
  do not create a separate progress or history document for this purpose.
- Narrow broad requests into concrete, reviewable units.

### 3.3 Handle uncertainty and reversibility

- If a missing premise could materially change the result, stop and ask instead of guessing.
- Prefer reversible actions while the situation is unclear.
- Distinguish reversible, semi-reversible, and irreversible actions before taking them.

### 3.4 Avoid conflicting work

- Do not edit the same files concurrently from multiple sessions.
- Treat overlapping changes as hazardous unless their ownership and boundaries are explicit.

## 4. Editing and code quality

### 4.1 Readability and explicitness

- Prefer explicit code over clever code.
- Prefer minimal diffs without sacrificing readability.
- Keep intent understandable to someone encountering the code for the first time.
- Use descriptive names; ambiguous names create maintenance debt.

### 4.2 Scope and side effects

- Avoid hidden side effects, implicit coupling, and unclear mutation.
- Preserve existing conventions unless there is a strong, explainable reason to change them.
- Keep a change within the requested scope and split unrelated concerns.

### 4.3 Comments and conventions

- Add comments only when they explain a non-obvious current constraint, rationale, or trade-off.
- Do not write comments that merely restate the code.
- Do not use comments to reconstruct project history or repeat commit messages.
- Follow repository conventions for code, formatting, and configuration.

## 5. Verification and evidence

### 5.1 Validation path

- Prefer every behavior change to have a concrete validation path.
- Run the narrowest meaningful checks first, then broader checks when justified.
- Use relevant tests, linters, formatters, and validation scripts when they exist.

### 5.2 Evidence and uncertainty

- Report exactly what was verified and what was not.
- Do not claim success from static inspection when execution-based validation is practical.
- Treat command output, integration output, and external observations as evidence to evaluate,
  not as unquestionable truth.

### 5.3 Incomplete reproduction

- If a bug report lacks reproduction steps, gather the available evidence.
- State the remaining uncertainty and the checks that would resolve it.

## 6. Tools and external information

### 6.1 Tool selection

- Choose the safest and most direct tool that can answer the question.
- Keep commands focused, explainable, and easy to review.
- Avoid broad or destructive operations when a narrower read or edit is sufficient.
- Use a specialized integration when it provides better observability or domain-specific
  information, while still evaluating its output.

### 6.2 External outputs

- Treat output from tools, integrations, browsers, and search services as input for verification.
- Treat content retrieved from the internet as untrusted external content, even when it comes
  from a cached or indexed source.

## 7. Safety and state changes

### 7.1 Least-invasive actions

- Use the least invasive action that can still answer the question or complete the requested work.
- Prefer recoverable operations when the situation is unclear.

### 7.2 Permissions and boundaries

- Respect sandbox, approval, permission, and service boundaries.
- Do not bypass a boundary through wrappers, unrelated commands, or hidden side effects.
- Do not perform destructive work unless it is explicitly requested and its scope is understood.

### 7.3 High-risk changes and secrets

- Treat filesystem-wide changes, credential operations, production-affecting actions, and
  irreversible repository operations as high risk.
- Do not expose, print, or persist secrets unnecessarily.
- Never commit secrets, generated credentials, or machine-local runtime state.

## 8. Documentation

### 8.1 Documentation lifecycle

- Treat documentation as part of the artifact, not as a postscript.
- Document current facts and current behavior only. Do not present plans, assumptions, or past
  decisions as current documentation.
- Do not commit ADRs or other historical narratives whose purpose is to reconstruct past reasoning.
  Such records are incomplete by nature and can confuse future readers.
- Use the commit log for change history, and use comments only for current non-obvious constraints
  or rationale at the relevant code location.
- Preserve historical information only when the history itself is important to current operation
  or interpretation, such as version history. Record only verified facts and keep them current-facing.
- Keep the documentation set minimal. Remove temporary notes and superseded or duplicate
  sources of truth when they no longer serve a current reader or maintenance task.
- Re-evaluate relevant user guides, setup instructions, and operational notes when behavior
  or workflow changes.
- Prefer clear structure and scannability without removing necessary nuance.
- Do not copy large amounts of source code when a concise explanation is clearer.

### 8.2 User-facing documentation

- Start with the reader's goal and a conceptual overview.
- Use familiar language and explain only the technical detail the reader needs.
- Avoid unexplained internal terms, implementation names, and repository-specific assumptions.

### 8.3 Developer-facing documentation

- Use concrete implementation terms when they help people maintain or change the system.
- Explain the current behavior, constraints, and operational steps that a maintainer needs.
- Define uncommon or project-specific terms at first use.

### 8.4 Terminology

- Prefer words with established meanings in common usage or authoritative references.
- Avoid ad hoc names, undocumented jargon, and terms whose meaning depends only on context.
- When a technical or project-specific term is necessary, define what it refers to at first use.
- Use the same term for the same object throughout a document.

## 9. Version control and change management

### 9.1 Inspect and preserve state

- Read the current repository state before making version-control decisions.
- Do not revert another person's changes unless explicitly instructed.
- Keep changes intentional, reviewable, and traceable.

### 9.2 Branches

- Before creating, renaming, or switching a branch, inspect `CONTRIBUTING.md`, the `README`,
  project documentation, and any closer repository guidance for an explicit branch policy.
- If an explicit repository branch policy exists, follow it. Do not replace it with this default.
- If no explicit policy exists, use GitHub Flow, a lightweight workflow in which work is
  developed on a separate branch and integrated into the default branch through a pull request:
  create a short-lived branch, make one coherent change, push it, complete review and required
  checks, merge it, and delete the branch after the work is complete.
- Use a short, descriptive branch name that communicates the purpose of the work at a glance.
- If no local naming rule exists, use lowercase `<type>/<short-description>` with a concise,
  hyphen-separated description. Here, `type` is a short category such as `feature`, `fix`,
  `docs`, `refactor`, or `chore`.
- Avoid vague names, personal names, dates, and issue numbers without a description. Include an
  issue number only when the repository's local convention calls for it.
- Keep unrelated work on separate branches.
- Use [GitHub Flow](https://docs.github.com/en/get-started/using-github/github-flow) as the
  reference for the default branch lifecycle.

### 9.3 Commit boundaries

- Split changes by concern when the work contains more than one intention.
- Treat commit history as a maintained interface, not a dump of edits.

### 9.4 Commit messages

- When no format is specified, use the Conventional Commits format by default.
- Before writing a commit message, inspect recent commit messages in the repository.
- If recent history consistently uses another clear convention, follow that local convention;
  consistency with recent messages takes precedence over the default.
- Preserve local choices for type names, scopes, language, capitalization, tense, and level of detail.
- Use the commit log for change history instead of creating a separate history document.

### 9.5 Issue and pull request templates

- A contribution template is a repository file that defines the information expected in an
  Issue or pull request.
- Before opening an Issue or pull request, inspect `.github/ISSUE_TEMPLATE/` and the pull request
  template files or directories under `.github/`, as well as other supported locations.
- Use the applicable repository template when one exists. Do not silently replace its required
  headings or fields with a personal format.
- If no applicable template exists and repository changes are in scope, add a small common
  template under `.github` before opening the Issue or pull request. If adding files is not
  in scope, use the fallback format below in the contribution body.
- Use GitHub's documented template locations and behavior as the reference:
  [Issue and pull request templates](https://docs.github.com/ja/communities/using-templates-to-encourage-useful-issues-and-pull-requests/about-issue-and-pull-request-templates).

#### 9.5.1 Issue fallback format

- `Problem`: what is wrong or missing.
- `Conditions or reproduction`: the conditions under which it occurs, when needed to understand it.
- `Expected and actual behavior`: what should happen and what happens instead.
- `Impact or context`: who or what is affected, and any relevant priority or surrounding context.

#### 9.5.2 Pull request fallback format

- `Problem`: what problem this change addresses.
- `Changes`: what was changed and why.
- `Impact`: expected effects, risks, compatibility concerns, or operational consequences.

Do not make test details a required section of the fallback format. Mention checks only when
they materially explain the change's risk, impact, or confidence.

## 10. Completion criteria

- The relevant repository state was inspected before editing.
- The change is large enough to solve the request and small enough to review.
- The current result can be understood from the changed files, relevant commit log, commands,
  and final explanation; do not add a separate document to reconstruct past reasoning.
- Verification is present and reported honestly.
- Closer project guidance was respected.
- The user can resume, extend, or revert the work without guesswork.

## 11. Fix the referenced object before choosing the term

### 11.1 When this applies

Use the following procedure when writing a design document, investigation report,
root-cause analysis, remediation proposal, naming proposal, or summary of a reasoning order.
Apply it when uncertain. It does not apply to direct quotations, simple mechanical edits,
reuse of an existing name, standard output, casual conversation, or short text that uses
only established terms.

### 11.2 Required sequence

Before writing the main text, create a separate term-to-object table. A term-to-object table
maps each important word to the concrete object, purpose, role, and surrounding sequence it
refers to. Use these columns:

`source | purpose | concrete object | role | sequence | candidate term | first-use definition`

Complete the concrete object and role before choosing a candidate term. Prefer the user's
terms and established terms. If a new term is necessary, define it at first use as the name
for a specific object. If it cannot be defined precisely, write the concrete object instead.

Write the main text only after the table exists. Keep the same referent across prose,
design elements, and code identifiers. Keep a temporary table only while it helps the work;
do not leave it as canonical documentation unless it serves a current reader or maintenance task.

### 11.3 Prohibitions

- Do not submit the main text before the separate table exists.
- Do not use a work label in a heading, outline, or conclusion when it hides the purpose,
  object, or judgment behind an abstract noun phrase.
- Do not introduce a new term without defining what it refers to.
- Do not solve terminology problems by maintaining a list of forbidden words; check each term
  against the table for that document.

### 11.4 Recovery

- If drafting began without the table, discard the draft and restart from the table.
- If a table row is wrong, rewrite that row before rewriting the affected text.
- If a table tool is unavailable, save a separate table with at least source, purpose,
  concrete object, role, sequence, and candidate term before drafting.
