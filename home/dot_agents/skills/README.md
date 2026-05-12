# Agent Skills

## Purpose

This directory is the source of truth for personal agent skills managed by this repository.

## Location

- Source of truth in this repository: `home/dot_agents/skills/`
- Runtime location: `~/.agents/skills/`

Both Codex and OpenCode discover skills from `~/.agents/skills/<name>/SKILL.md`, so this repository uses that shared location instead of tool-specific skill directories.

## Structure

- Each skill lives in `home/dot_agents/skills/<name>/SKILL.md`
- `<name>` must match the `name` field in the skill frontmatter
- Keep skill names lowercase kebab-case
- Keep each skill focused on one reusable workflow

## Validation

Run a chezmoi dry-run after editing skills:

```bash
chezmoi --source "$PWD" apply --dry-run --verbose
```

For quick static checks:

```bash
find home/dot_agents/skills -name SKILL.md -print
```

## Managed Skills

- `brooks-audit` - repository architecture and onboarding audit workflow
- `brooks-debt` - technical debt discovery and prioritization workflow
- `brooks-health` - repository health assessment workflow
- `brooks-review` - pull request review workflow focused on durable risks
- `brooks-sweep` - broad repository sweep workflow
- `brooks-test` - test quality and coverage review workflow
- `changelog-generator` - user-facing changelog generation from git history
- `frontend-design` - distinctive frontend design guidance for intentional, non-generic UI work
- `gh-fix-ci` - GitHub Actions PR check inspection and approved fix workflow
- `github` - GitHub workflow management through the `gh` CLI
- `ja-writing-humanizer` - Japanese writing humanization and polishing guidance
- `playwright` - official Playwright browser automation workflow
- `playwright-cli` - browser automation through the Playwright CLI instead of the Playwright MCP server
- `security-threat-model` - security threat modeling workflow
- `unslop` - AI-text cleanup workflow
- `unslop-commit` - AI-text cleanup for commit messages
- `unslop-file` - file-level AI-text detection and cleanup tools
- `unslop-help` - unslop usage guidance
- `unslop-reasoning` - AI reasoning text cleanup workflow
- `unslop-review` - AI-text review workflow

## Imported Sources

- `brooks-*`: `https://github.com/hyhmrright/brooks-lint`
- `ja-writing-humanizer`: `https://github.com/viasnake/ja-humanizer`
- `changelog-generator`, `gh-fix-ci`: `https://github.com/ComposioHQ/awesome-codex-skills`
- `unslop*`: `https://github.com/MohamedAbdallah-14/unslop`
- `playwright`, `security-threat-model`: `https://github.com/openai/skills`

The Brooks skills share supporting references in `_shared/`.
