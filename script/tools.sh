#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/common/runtime.sh"
source "$DOTFILES_ROOT/script/common/platform.sh"
source "$DOTFILES_ROOT/script/common/packages.sh"
source "$DOTFILES_ROOT/script/common/files.sh"
source "$DOTFILES_ROOT/script/config/tools.sh"
source "$DOTFILES_ROOT/script/config/files.sh"

tools_preflight() {
  require_terminal "Tool installation and verification"
  require_command curl git cc
  platform_load
  packages_require_installer_for fish
}

tools_install_mise() {
  local action="${1:-install}"
  if ! command -v mise >/dev/null 2>&1; then
    mkdir -p "$HOME/.local/bin"
    curl -fsSL https://mise.run | env MISE_INSTALL_PATH="$HOME/.local/bin/mise" sh
  elif [[ "$action" != install ]]; then
    if [[ "$(command -v mise)" == "$HOME/.local/bin/mise" && ! -L "$HOME/.local/bin/mise" ]]; then
      mise self-update --yes
    else
      log_info 'Update mise itself with its original package manager.'
    fi
  fi
  # Run after copying configuration, outside the caller's project configuration.
  (
    cd "$HOME"
    case "$action" in
      reinstall) mise install --force --yes ;;
      update)
        mise install --yes
        mise upgrade --yes --no-prune
        ;;
      install) mise install --yes ;;
    esac
  )
}

tools_install_codex() {
  local action="${1:-install}" binary="$HOME/.local/bin/codex"
  if [[ -x "$binary" && "$action" == install ]]; then
    return
  fi
  if [[ ( -e "$binary" || -L "$binary" ) && ! -x "$binary" ]]; then
    log_error "Codex install path exists but is not executable: $binary"
    return 1
  fi

  mkdir -p "$HOME/.local/bin"
  curl -fsSL https://chatgpt.com/codex/install.sh | env \
    PATH="$HOME/.local/bin:$PATH" \
    CODEX_INSTALL_DIR="$HOME/.local/bin" CODEX_NON_INTERACTIVE=true sh
  if [[ ! -x "$binary" ]]; then
    log_error "Codex installation failed: $binary was not created."
    return 1
  fi
}

tools_install_pi() {
  local action="${1:-install}"
  if [[ "$action" == install ]] && command -v pi >/dev/null 2>&1; then
    return
  fi
  # npm is provided by mise-managed Node.js.
  if ! command -v npm >/dev/null 2>&1; then
    log_error 'npm is required to install Pi.'
    return 1
  fi
  npm install --global @mariozechner/pi-coding-agent
  if ! command -v pi >/dev/null 2>&1; then
    log_error 'Pi installation failed: pi is not on PATH.'
    return 1
  fi
}

tools_install_fisher() {
  if ! fish -c 'functions -q fisher'; then
    curl -fsSL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish \
      | fish -c 'source; fisher install jorgebucaran/fisher'
  fi
  fish -c 'fisher update'
}

tools_install_termlog() {
  # Rust must be installed through mise before this step.
  packages_install_cargo_git termlog "$TERMLOG_REPOSITORY" "$TERMLOG_REVISION" "$HOME/.local"
}

tools_verify_termlog() {
  local binary="$1"
  "$binary" --version
  env -u TERMLOG_ACTIVE -u TERMLOG_SESSION_ID "$binary" run -- /bin/sh -c \
    '"$1" status && printf "termlog: recording check succeeded\n"' sh "$binary"
}

# Entry points run tools_preflight before making any configuration changes.
tools_install() {
  local action="${1:-install}"
  packages_ensure_command fish fish
  tools_install_mise "$action"
  tools_install_codex "$action"
  tools_install_pi "$action"
  tools_install_fisher
  tools_install_termlog
  tools_verify_termlog "$HOME/.local/bin/termlog"

  # Activate tool-dependent configuration only after installation and verification.
  files_apply config_terminal_files
}

# This workaround depends on Codex internals, so require the database explicitly.
# It suppresses diagnostic inserts, including diagnostics used by /feedback.
tools_disable_codex_logging() {
  local database="$1" table_count
  require_command sqlite3
  if [[ ! -f "$database" || -L "$database" ]]; then
    log_error "Expected an existing regular Codex log database: $database"
    return 1
  fi
  table_count="$(sqlite3 -readonly -noheader "$database" \
    "SELECT COUNT(*) FROM sqlite_master WHERE type = 'table' AND name = 'logs';")"
  if [[ "$table_count" != 1 ]]; then
    log_error "Expected logs table is missing: $database"
    return 1
  fi
  sqlite3 -batch -cmd '.timeout 10000' "$database" \
    'CREATE TRIGGER IF NOT EXISTS block_log_inserts
     BEFORE INSERT ON logs BEGIN SELECT RAISE(IGNORE); END;'
  log_info "Codex SQLite diagnostic logging disabled: $database"
}

tools_main() {
  local action="${1:-install}"
  if [[ $# -gt 0 ]]; then shift; fi
  setup_tool_path
  case "$action" in
    install|reinstall|update)
      require_no_arguments 'bash script/tools.sh [install|reinstall|update]' "$@"
      tools_preflight
      tools_install "$action"
      ;;
    codex-disable-logging)
      if [[ $# -ne 1 ]]; then
        log_error 'Usage: bash script/tools.sh codex-disable-logging <database>'
        return 2
      fi
      tools_disable_codex_logging "$1"
      ;;
    *)
      log_error "Unknown tool action: $action"
      return 2
      ;;
  esac
}

# install.sh sources this file for the same prerequisite checks before copying.
# Only direct execution runs installation or changes shell options.
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  set -euo pipefail
  tools_main "$@"
fi
