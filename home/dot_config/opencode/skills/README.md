# OpenCode Skills

## Purpose

This directory is the source of truth for custom OpenCode skills managed by this repository.

## Location

- Source of truth in this repository: `home/dot_config/opencode/skills/`
- Runtime location used by OpenCode: `~/.config/opencode/skills/`

The repository directory is the maintained source. `make apply` publishes it into the runtime location with chezmoi.

## Structure

- Each skill lives in `home/dot_config/opencode/skills/<name>/SKILL.md`
- `<name>` must match the `name` field in the skill frontmatter
- Keep skill names lowercase kebab-case to match OpenCode requirements

## Repository Policy

- All OpenCode skills are managed from this directory
- Runtime skills are published by chezmoi from this source state
- Do not rely on ad-hoc runtime-only skills outside this repository

## Validation

Run a chezmoi dry-run after editing `home/dot_config/opencode/opencode.jsonc.tmpl` or anything under `home/dot_config/opencode/skills/`.

```bash
chezmoi --source "$PWD" apply --dry-run --verbose
```

For schema/format checks, validate generated output directly:

```bash
chezmoi --source "$PWD" execute-template --file home/dot_config/opencode/opencode.jsonc.tmpl
```

## Managed Skills

- `frontend-design` - distinctive frontend design guidance for intentional, non-generic UI work
- `github` - GitHub workflow management through the `gh` CLI
- `playwright-cli` - browser automation through the Playwright CLI instead of the Playwright MCP server
