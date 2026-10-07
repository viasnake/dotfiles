# shellcheck shell=bash
# WSL uses its distribution's package manager, just like other Linux systems.
linux_distribution_family() (
  # A subshell keeps os-release variables out of the installer's environment.
  local ID='' ID_LIKE=''
  if [[ -r /etc/os-release ]]; then
    source /etc/os-release
  fi
  case " $ID $ID_LIKE " in
    *' debian '*|*' ubuntu '*) printf 'debian\n' ;;
    *) printf 'unsupported\n' ;;
  esac
)

platform_require_package_manager() {
  if [[ "$(linux_distribution_family)" != debian ]]; then
    log_error 'No package installer for this Linux distribution; install required commands with your package manager first.'
    return 1
  fi
  require_command apt-get
  if [[ "$(id -u)" -ne 0 ]]; then
    require_command sudo
  fi
}

platform_install_packages() {
  run_as_root apt-get update
  run_as_root env DEBIAN_FRONTEND=noninteractive apt-get install -y "$@"
}
