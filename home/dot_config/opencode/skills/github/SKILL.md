---
name: github
description: Manage GitHub workflows with the gh CLI for pull requests, issues, checks, workflow runs, and API queries.
---

# GitHub

Use the `gh` CLI to inspect and manage GitHub state from the terminal.

## Core rules

- Use `gh` for pull requests, issues, checks, workflow runs, releases, and API access
- When outside a git repository, pass `--repo owner/repo` or use a full GitHub URL
- Prefer structured output with `--json` and `--jq` when summarizing results
- Do not mutate remote state unless the user explicitly asks

## Common workflows

### Pull requests

```bash
gh pr view 55 --repo owner/repo
gh pr checks 55 --repo owner/repo
gh pr diff 55 --repo owner/repo
gh pr create --title "title" --body "body"
```

### Issues

```bash
gh issue list --repo owner/repo
gh issue view 123 --repo owner/repo
gh issue create --title "title" --body "body"
```

### Workflow runs

```bash
gh run list --repo owner/repo --limit 10
gh run view <run-id> --repo owner/repo
gh run view <run-id> --repo owner/repo --log-failed
```

### API queries

```bash
gh api repos/owner/repo/pulls/55 --jq '.title, .state, .user.login'
gh issue list --repo owner/repo --json number,title --jq '.[] | "\(.number): \(.title)"'
```

Prefer read-only inspection first, then perform write operations only when the user has asked for them.
