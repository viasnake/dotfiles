# OpenCode Skills

## Purpose

This directory is the source of truth for custom OpenCode skills managed by this repository.

## Location

- Source of truth in this repository: `config/opencode/skills/`
- Runtime location used by OpenCode: `~/.config/opencode/skills/`

The repository directory is the maintained source. Link scripts publish it into the runtime location.

## Structure

- Each skill lives in `config/opencode/skills/<name>/SKILL.md`
- `<name>` must match the `name` field in the skill frontmatter
- Keep skill names lowercase kebab-case to match OpenCode requirements

## Repository Policy

- All OpenCode skills are managed from this directory
- Runtime skills are published by the link scripts as a single directory symlink
- Local-only personal skills may exist here without being committed, and they will still be linked at runtime
- Do not rely on ad-hoc runtime-only skills outside this repository

## Validation

Run `make opencode_validate` after editing `config/opencode/opencode.jsonc` or anything under `config/opencode/skills/`.

The validator checks:

- `config/opencode/opencode.jsonc` is valid JSON
- `mcp.playwright` is absent because Playwright is managed by a CLI skill
- each skill directory contains `SKILL.md`
- each skill defines a `name` and `description`
- each skill `name` matches its directory name

## Managed Skills

- `frontend-design` - distinctive frontend design guidance for intentional, non-generic UI work
- `github` - GitHub workflow management through the `gh` CLI
- `playwright-cli` - browser automation through the Playwright CLI instead of the Playwright MCP server
