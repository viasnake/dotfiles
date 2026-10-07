#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common/runtime.sh"
source "$DOTFILES_ROOT/script/common/files.sh"
source "$DOTFILES_ROOT/script/config/files.sh"

main() {
  require_no_arguments 'bash script/copy.sh' "$@"
  files_apply config_files
  chmod 700 "$HOME/.ssh" "$HOME/.ssh/config.d"
}

main "$@"
