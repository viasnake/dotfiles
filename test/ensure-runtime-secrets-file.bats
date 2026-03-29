#!/usr/bin/env bats

setup() {
  REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
  TMPDIR_TEST="$(mktemp -d)"
  export HOME="$TMPDIR_TEST/home"
  mkdir -p "$HOME"
}

teardown() {
  rm -rf "$TMPDIR_TEST"
}

@test "ensure_runtime_secrets_file creates template when missing" {
  run env REPO_ROOT="$REPO_ROOT" HOME="$HOME" bash -c '
    mode_of() {
      if stat -c "%a" "$1" >/dev/null 2>&1; then
        stat -c "%a" "$1"
        return 0
      fi

      stat -f "%Lp" "$1"
    }

    source "$REPO_ROOT/script/lib/ensure-runtime-secrets-file"
    ensure_runtime_secrets_file
    secrets_dir="$(default_runtime_secrets_dir)"
    secrets_file="$(default_runtime_secrets_file)"
    printf "%s\n---\n%s\n---\n%s\n---\n%s\n" \
      "$(mode_of "$secrets_dir")" \
      "$(mode_of "$secrets_file")" \
      "$(cat "$secrets_file")" \
      "$secrets_file"
  '

  [ "$status" -eq 0 ]
  [[ "$output" == *$'700\n---\n600\n---\n# Runtime environment secrets for local tools\n# Format: KEY=VALUE\n# Example:\n# CONTEXT7_API_KEY=<your-context7-api-key>\n---\n'"$HOME/.config/secrets/runtime.env.secret" ]]
}

@test "ensure_runtime_secrets_file does not modify existing file" {
  mkdir -p "$HOME/.config/secrets"
  cat > "$HOME/.config/secrets/runtime.env.secret" <<'EOF'
EXISTING=value
EOF
  chmod 644 "$HOME/.config/secrets/runtime.env.secret"

  run env REPO_ROOT="$REPO_ROOT" HOME="$HOME" bash -c '
    mode_of() {
      if stat -c "%a" "$1" >/dev/null 2>&1; then
        stat -c "%a" "$1"
        return 0
      fi

      stat -f "%Lp" "$1"
    }

    source "$REPO_ROOT/script/lib/ensure-runtime-secrets-file"
    ensure_runtime_secrets_file
    secrets_file="$(default_runtime_secrets_file)"
    printf "%s\n---\n%s\n" "$(cat "$secrets_file")" "$(mode_of "$secrets_file")"
  '

  [ "$status" -eq 0 ]
  [ "$output" = $'EXISTING=value\n---\n644' ]
}
