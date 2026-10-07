#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/script/tools.sh"

main() {
  local action="${1:-install}"
  if [[ $# -gt 0 ]]; then shift; fi
  require_no_arguments './install.sh [install|reinstall|update|uninstall|remove]' "$@"
  case "$action" in
    install|reinstall|update)
      setup_tool_path
      tools_preflight
      bash "$DOTFILES_ROOT/script/copy.sh"
      tools_install "$action"
      ;;
    uninstall|remove)
      # Validate the entire batch before removing shell files that depend on it.
      files_apply config_terminal_files files_check_removal
      files_apply config_files files_check_removal
      files_apply config_terminal_files files_remove
      files_apply config_files files_remove
      ;;
    -h|--help)
      printf 'Usage: ./install.sh [install|reinstall|update|uninstall|remove]\n'
      return
      ;;
    *) log_error "Unknown action: $action"; return 2 ;;
  esac
  log_info "$action complete"
}

main "$@"
