# Repository Guidance

## 1. Scope and precedence

This file applies to work in this repository and its child directories. It records current
repository facts, local commands, and repository-specific constraints.

General agent guidance may come from a parent or user-level `AGENTS.md`. A closer
`AGENTS.md`, `CONTRIBUTING.md`, or other repository document takes precedence when it
defines a more specific rule. Do not use this file to override a closer rule.

## 2. Current repository facts

- This repository contains source files for user configuration and setup scripts.
- `chezmoi` is the tool used here to render those source files into a target home directory.
- `.chezmoiroot` points `chezmoi` at `home/` as the source directory.
- `home/` contains managed files, templates, and scripts.
- `home/.chezmoiscripts/` contains setup scripts run by `chezmoi`.
- `agent-skills.tsv` is a tab-separated manifest of the skills managed by this repository.
- `Makefile` is the common entry point for setup, inspection, and validation commands.

## 3. Common operations

### 3.1 Setup and apply

- `make help` lists the available targets.
- `make init` installs `chezmoi` when needed and applies the source files.
- `make apply` applies all managed files and scripts.
- `make apply-scripts` applies only managed scripts.
- `make remove-managed` removes the currently managed files and symbolic links from the
  target home directory. Confirm the target before running this command.

### 3.2 Inspect the rendered state

- `make status` shows pending changes.
- `make diff` shows the rendered difference.
- `make managed` lists managed target paths.

### 3.3 Validate without changing the target

- `make dry-run` shows the verbose apply plan without mutating target files.
- `make verify` checks whether the target state matches the rendered source state.
- `chezmoi --source "$PWD" apply --dry-run --verbose` validates rendering without applying it.

## 4. Verification by change

- For changes under `home/.chezmoiscripts/`, run `make dry-run` and
  `chezmoi --source "$PWD" apply --include=scripts --dry-run --verbose`.
- For managed configuration or template changes, run
  `chezmoi --source "$PWD" apply --dry-run --verbose`.
- For `Makefile` changes, run `make help`, `make dry-run`, and `make managed`.
- For `agent-skills.tsv` changes, run `make help` and the available skill-update dry run.
- For shell or setup behavior, run the narrowest relevant shell or container check listed by
  `make help`.
- For changes that may affect secrets or repository safety, inspect the diff and run the
  narrowest relevant checks. Never put secrets, generated credentials, or host-local runtime
  state into the repository.

## 5. Code and configuration conventions

Follow existing repository patterns before introducing a new one.

### 5.1 Shell and templates

- Use Bash when shell behavior is required in a setup script.
- Prefer `#!/usr/bin/env bash` and `set -euo pipefail` for new or substantially changed
  scripts.
- Use `[[ ... ]]` for Bash conditionals and quote expansions unless unquoted behavior is
  intentional.
- Keep rendering logic in templates when the source format supports it.
- Use two spaces for Bash indentation and no tabs.
- End every file with a trailing newline.

### 5.2 Structured configuration

- Treat JSON, JSONC, and TOML schemas as contracts.
- Preserve key stability and existing grouping unless a reorganization improves clarity.
- Avoid unrelated formatting changes.
- Use the repository's secret-backed template mechanism or environment placeholders for
  secret-bearing values.

## 6. Documentation

- This file is developer-facing guidance. Keep it separate from user-facing instructions in
  `README.md` and other user documentation.
- User-facing documentation should begin with the reader's goal and a conceptual overview;
  explain internal terms only when the reader needs them.
- Developer-facing documentation may use concrete implementation terms, but define uncommon or
  repository-specific terms at first use.
- Document current facts and current behavior only. Do not commit ADRs or other historical
  narratives whose purpose is to reconstruct past reasoning.
- Use the commit log for change history, and use comments only for current non-obvious
  constraints or rationale at the relevant code location.
- Remove temporary notes, superseded documents, and duplicate sources of truth when they no
  longer serve a current reader.

## 7. Version control

### 7.1 Branches

- Before creating, renaming, or switching a branch, inspect `CONTRIBUTING.md`, `README.md`,
  project documentation, and any closer repository guidance for an explicit branch policy.
- If an explicit policy exists, follow it. Do not replace it with this default.
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
- When no local convention is clear, use Conventional Commits.
- If recent commits consistently use another clear convention, follow that convention instead.
- Keep commits intentional, reviewable, and split by concern.
- Use the commit log for change history instead of creating a separate history document.

### 7.3 Issues and pull requests

- Before opening an Issue or pull request, inspect `.github/ISSUE_TEMPLATE/` and the pull request
  template files or directories under `.github/`.
- Use the applicable repository template when one exists.
- If no template exists and adding files is in scope, add a small common template before opening
  the Issue or pull request. Otherwise, use the following minimum structure:
  - `Problem`: what is wrong or missing.
  - `Changes`: what was changed and why.
  - `Impact`: expected effects, risks, compatibility concerns, or operational consequences.
- Test details are optional; include them only when they materially clarify risk, impact, or
  confidence.

## 8. Reporting and completion

- Report exactly which commands were executed and which were skipped.
- State explicitly when a check was not run to avoid mutating the target environment.
- Do not claim full validation when only static inspection or a dry run was performed.
- A change is complete when the relevant state was inspected, the requested files were updated,
  the narrowest meaningful checks passed, and remaining uncertainty is stated.
