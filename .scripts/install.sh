#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

function error() {
  local red="\033[31m"
  local reset="\033[0m"
  local prefix="[ERROR] "
  local message=$1
  echo -e "${red}${prefix}${message}${reset}"
}

function success() {
  local green="\033[32m"
  local reset="\033[0m"
  local prefix="[SUCCESS] "
  local message=$1
  echo -e "${green}${prefix}${message}${reset}"
}

function warning() {
  local yellow="\033[33m"
  local reset="\033[0m"
  local prefix="[WARNING] "
  local message=$1
}

function info() {
  local cyan="\033[36m"
  local reset="\033[0m"
  local prefix="[INFO] "
  local message=$1
  echo -e "${cyan}${prefix}${message}${reset}"
}

function is_macos() {
  # Mac OS X
  if [[ "$(uname -s)" == "Darwin" ]]; then
    return 0
  else
    return 1
  fi
}

function is_linux() {
  # Linux
  if [[ "$(uname -s)" == "Linux" ]]; then
    return 0
  else
    return 1
  fi
}

function is_windows() {
  # Windows
  # Why would you run this script on Windows?
  return 1
}

function is_wsl() {
  # SEE: https://github.com/docker/docker-install/blob/6d51e2cd8c04b38e1c2237820245f4fc262aca6c/install.sh#L224-L230

  # WSL 1
  if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null; then
    warning "WSL 1 is not officially supported."
    return 0
  # WSL 2
  elif grep -qEi "microsoft" /proc/version &> /dev/null; then
    return 0
  else
    return 1
  fi
}

function check_os() {
  os=""

  # FIXME: This is not the best way to check the OS

  # macOS
  if is_macos; then
    os="macos"
  fi

  # Linux
  if is_linux; then
    os="linux"
  fi

  # Windows Subsystem for Linux
  if is_wsl; then
    os="wsl"
  fi

  # Windows
  if is_windows; then
    os="windows"
  fi

  # os is set
  if [ -n "$os" ]; then
    return 0
  fi

  # os is not set (unsupported OS)
  error "OS not supported."
  exit 1
}


info "Checking OS..."
check_os

# Environment variables
script=".scripts/$os/setup.sh"

# Debug information
info "OS: $os"
info "Script: $script"

# Check if the setup script exists
if [ ! -f "$script" ]; then
  error "Setup script not found."
  exit 1
fi

# Run the setup script
source "$script"

# Check if the setup script completed successfully
success "Setup script completed."
