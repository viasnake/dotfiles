# shellcheck shell=bash
# Sourcing libraries only defines functions and repository-local constants.
DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

log_info() {
  printf 'dotfiles: %s\n' "$*"
}

log_error() {
  printf 'dotfiles: %s\n' "$*" >&2
}

require_no_arguments() {
  local usage="$1"
  shift
  if [[ $# -ne 0 ]]; then
    printf 'Usage: %s\n' "$usage" >&2
    return 2
  fi
}

require_command() {
  local command_name
  for command_name in "$@"; do
    if ! command -v "$command_name" >/dev/null 2>&1; then
      log_error "Required command not found: $command_name"
      return 1
    fi
  done
}

require_terminal() {
  local purpose="$1"
  if [[ ! -t 0 || ! -t 1 ]]; then
    log_error "$purpose requires an interactive terminal."
    return 1
  fi
}

setup_tool_path() {
  # Do not source personal startup files or activate tools from the caller's project.
  # Preserve the caller's selected Homebrew; standard prefixes are fallbacks.
  local directory
  for directory in "$HOME/.local/bin" /opt/homebrew/bin /usr/local/bin /home/linuxbrew/.linuxbrew/bin; do
    case ":$PATH:" in
      *":$directory:"*) ;;
      *) PATH="$PATH:$directory" ;;
    esac
  done
  export PATH
}

run_as_root() {
  if [[ "$(id -u)" -eq 0 ]]; then
    "$@"
  else
    sudo "$@"
  fi
}
