#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

function error() {
  echo -e "\033[31m$1\033[0m"
}

function success() {
  echo -e "\033[32m$1\033[0m"
}

function warning() {
  echo -e "\033[33m$1\033[0m"
}

function info() {
  echo -e "\033[36m$1\033[0m"
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
  if is_macos; then
    # Mac OS X
    os="macos"
  elif is_linux; then
    # Linux
    os="linux"
  elif is_wsl; then
    # WSL1 or WSL2
    os="wsl"
  elif is_windows; then
    # Windows
    os="windows"
  else
    # Unsupported OS
    error "Unsupported OS."
    return 1
  fi
  
  # Return the OS
  return 0
}


info "Checking OS..."
check_os

# Environment variables
script=".scripts/$os/setup.sh"

# Debug information
info "OS: $os"
info "Script: $script"

# Check if the OS is set
if [ -z "$os" ]; then
  error "OS is not set."
  exit 1
fi

# Check if the setup script exists
if [ ! -f "$script" ]; then
  error "Setup script not found."
  exit 1
fi

# Run the setup script
source "$script"

# Check if the setup script completed successfully
success "Setup script completed."
