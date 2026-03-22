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

@test "default_secrets_env_file uses HOME" {
  run env REPO_ROOT="$REPO_ROOT" bash -c '
    source "$REPO_ROOT/script/lib/load-secrets-env"
    default_secrets_env_file
  '

  [ "$status" -eq 0 ]
  [ "$output" = "$HOME/.config/secrets/runtime.env.secret" ]
}

@test "load_runtime_secrets_env ignores missing file" {
  run env REPO_ROOT="$REPO_ROOT" bash -c '
    source "$REPO_ROOT/script/lib/load-secrets-env"
    load_runtime_secrets_env "$HOME/does-not-exist.env"
    printf "ok"
  '

  [ "$status" -eq 0 ]
  [ "$output" = "ok" ]
}

@test "load_runtime_secrets_env loads valid lines" {
  secret_file="$TMPDIR_TEST/runtime.env.secret"
  cat > "$secret_file" <<'EOF'
# comment

FOO=bar
INVALID LINE
BAZ=qux
EOF

  run env SECRET_FILE="$secret_file" REPO_ROOT="$REPO_ROOT" bash -c '
    source "$REPO_ROOT/script/lib/load-secrets-env"
    load_runtime_secrets_env "$SECRET_FILE"
    printf "%s:%s" "${FOO:-}" "${BAZ:-}"
  '

  [ "$status" -eq 0 ]
  [ "$output" = "bar:qux" ]
}

@test "load_runtime_secrets_env respects SECRETS_ENV_FILE" {
  secret_file="$TMPDIR_TEST/runtime-from-env.secret"
  cat > "$secret_file" <<'EOF'
FROM_ENV_FILE=loaded
EOF

  run env SECRETS_ENV_FILE="$secret_file" REPO_ROOT="$REPO_ROOT" bash -c '
    source "$REPO_ROOT/script/lib/load-secrets-env"
    load_runtime_secrets_env
    printf "%s" "${FROM_ENV_FILE:-}"
  '

  [ "$status" -eq 0 ]
  [ "$output" = "loaded" ]
}

@test "load_runtime_secrets_env does not override existing env" {
  secret_file="$TMPDIR_TEST/runtime.env.secret"
  cat > "$secret_file" <<'EOF'
FOO=from-file
EOF

  run env FOO=from-env SECRET_FILE="$secret_file" REPO_ROOT="$REPO_ROOT" bash -c '
    source "$REPO_ROOT/script/lib/load-secrets-env"
    load_runtime_secrets_env "$SECRET_FILE"
    printf "%s" "${FOO}"
  '

  [ "$status" -eq 0 ]
  [ "$output" = "from-env" ]
}
