# shellcheck shell=bash
# Each adapter implements platform_require_package_manager and platform_install_packages.
# Selection is explicit: never execute an arbitrary path derived from OS metadata.
platform_load() {
  local kernel
  kernel="$(uname -s)"
  case "$kernel" in
    Darwin) source "$DOTFILES_ROOT/script/platform/macos.sh" ;;
    Linux) source "$DOTFILES_ROOT/script/platform/linux.sh" ;;
    *)
      log_error "Unsupported operating system: $kernel"
      return 1
      ;;
  esac
}
