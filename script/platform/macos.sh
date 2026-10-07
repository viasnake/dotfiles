# shellcheck shell=bash
# Homebrew 7+ is a prerequisite; Homebrew owns OS and architecture support checks.
platform_require_package_manager() {
  if ! command -v brew >/dev/null 2>&1; then
    require_command curl
  fi
}

platform_install_packages() {
  local shell_environment
  if ! command -v brew >/dev/null 2>&1; then
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh \
      | NONINTERACTIVE=1 /bin/bash
  fi
  # Let the selected Homebrew describe its prefix, including bin and sbin.
  # Capture separately so a failed shellenv cannot be hidden by eval's status.
  shell_environment="$(brew shellenv bash)"
  eval "$shell_environment"
  brew install "$@"
}
