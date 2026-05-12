---
name: playwright-cli
description: Automate browsers with Playwright CLI for navigation, form input, screenshots, snapshots, storage inspection, and session-aware web workflows.
---

# Browser Automation with Playwright CLI

Use this skill when the task needs browser interaction through the local `playwright-cli` command rather than the Playwright MCP server.

## When to use

- Navigate websites and inspect page state
- Fill forms and submit flows
- Capture screenshots, PDFs, traces, or snapshots
- Reuse browser sessions, cookies, or local storage
- Run workflows that are easier to express as CLI commands

## Prerequisites

- `playwright-cli` is available on `PATH`
- Use `npx playwright-cli ...` only for explicit troubleshooting when the installed binary is unavailable

## Core workflow

```bash
playwright-cli open https://example.com
playwright-cli snapshot
playwright-cli click e3
playwright-cli fill e5 "user@example.com"
playwright-cli press Enter
playwright-cli close
```

## Common commands

```bash
playwright-cli open
playwright-cli goto https://playwright.dev
playwright-cli snapshot
playwright-cli click e3
playwright-cli dblclick e7
playwright-cli fill e5 "value"
playwright-cli type "search query"
playwright-cli hover e4
playwright-cli select e9 "option-value"
playwright-cli upload ./document.pdf
playwright-cli screenshot
playwright-cli pdf --filename=page.pdf
playwright-cli console
playwright-cli network
playwright-cli close
```

## Sessions

```bash
playwright-cli -s=workbench open https://example.com --persistent
playwright-cli -s=workbench snapshot
playwright-cli -s=workbench close
playwright-cli list
playwright-cli close-all
```

## Troubleshooting fallback

```bash
npx playwright-cli open https://example.com
```

Prefer automatic snapshot filenames unless the task needs a stable artifact path.
