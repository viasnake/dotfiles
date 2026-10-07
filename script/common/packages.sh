# shellcheck shell=bash
# Callers map executable names to native package names; adapters own OS commands.
packages_require_installer_for() {
  local executable="$1"
  if ! command -v "$executable" >/dev/null 2>&1; then
    platform_require_package_manager
  fi
}

packages_ensure_command() {
  local executable="$1"
  shift
  if ! command -v "$executable" >/dev/null 2>&1; then
    platform_install_packages "$@"
  fi
}

# Shared policy for pinned Rust CLI tools, independent of the caller's project.
packages_install_cargo_git() {
  local package="$1" repository="$2" revision="$3" destination="$4"
  (cd "$HOME" && mise exec rust -- cargo install --locked --force \
    --git "$repository" --rev "$revision" --root "$destination" "$package")
}
