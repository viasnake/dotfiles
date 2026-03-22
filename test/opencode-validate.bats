#!/usr/bin/env bats

setup() {
  REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
  TMPDIR_TEST="$(mktemp -d)"
  TEST_REPO="$TMPDIR_TEST/repo"
  mkdir -p "$TEST_REPO/script/opencode"
  cp "$REPO_ROOT/script/opencode/validate" "$TEST_REPO/script/opencode/validate"
  chmod +x "$TEST_REPO/script/opencode/validate"
}

teardown() {
  rm -rf "$TMPDIR_TEST"
}

create_valid_repo_layout() {
  mkdir -p "$TEST_REPO/config/opencode/skills/sample-skill"

  cat > "$TEST_REPO/config/opencode/opencode.jsonc" <<'EOF'
{
  "mcp": {
    "context7": {
      "command": ["npx", "-y", "@upstash/context7-mcp"]
    }
  }
}
EOF

  cat > "$TEST_REPO/config/opencode/skills/sample-skill/SKILL.md" <<'EOF'
---
name: sample-skill
description: sample description
---

# Sample Skill
EOF
}

@test "validate succeeds with valid config and skill" {
  create_valid_repo_layout

  run "$TEST_REPO/script/opencode/validate"

  [ "$status" -eq 0 ]
  [[ "$output" == *"Validation passed"* ]]
}

@test "validate fails when playwright MCP entry exists" {
  create_valid_repo_layout

  cat > "$TEST_REPO/config/opencode/opencode.jsonc" <<'EOF'
{
  "mcp": {
    "playwright": {
      "command": ["playwright"]
    }
  }
}
EOF

  run "$TEST_REPO/script/opencode/validate"

  [ "$status" -ne 0 ]
  [[ "$output" == *"config.mcp.playwright must be removed"* ]]
}

@test "validate fails when skill frontmatter name mismatches directory" {
  create_valid_repo_layout

  cat > "$TEST_REPO/config/opencode/skills/sample-skill/SKILL.md" <<'EOF'
---
name: wrong-name
description: sample description
---

# Sample Skill
EOF

  run "$TEST_REPO/script/opencode/validate"

  [ "$status" -ne 0 ]
  [[ "$output" == *"name must match directory name"* ]]
}
