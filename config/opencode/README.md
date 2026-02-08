# opencode profile and provider management

This directory supports profile-based MCP configuration with fail-closed behavior.

## Profiles

- `personal`: Uses the allowlist in `providers/profiles/personal.json` and can inject secrets from Bitwarden (`bw`).
- `work`: Uses the allowlist in `providers/profiles/work.json` (starts empty).
- `restricted`: Uses the allowlist in `providers/profiles/restricted.json` (empty by default).

Unknown providers are always denied.

## Files

- `providers/catalog.json`: Source of truth for MCP provider definitions.
- `providers/profiles/*.json`: Manual allowlists per profile.
- `opencode.jsonc`: Runtime config synchronized from catalog/profile.

## Commands

Run from repository root.

```bash
script/opencode/validate personal
script/opencode/sync personal
OPENCODE_PROFILE=personal script/opencode/run-with-bw
```

## Bitwarden (`bw`) integration

For each secret provider entry in `catalog.json`:

- `env`: Environment variable expected by MCP command.
- `bw_item_id_env`: Environment variable that stores the Bitwarden item id.

Example:

```bash
export BW_CONTEXT7_ITEM_ID="<bitwarden-item-id>"
OPENCODE_PROFILE=personal script/opencode/run-with-bw
```

If secret loading fails, the corresponding MCP is disabled and startup continues.

## Update workflow

1. Edit `providers/catalog.json`.
2. Edit `providers/profiles/<profile>.json`.
3. Run `script/opencode/validate <profile>`.
4. Run `script/opencode/sync <profile>`.
5. Start opencode.
