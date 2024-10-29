#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

#
PATH="$PATH:/home/linuxbrew/.linuxbrew/bin"
PATH="$PATH:$HOME/.local/bin"

function error() {
  local red="\033[31m"
  local reset="\033[0m"
  local prefix="[ERROR] "ee
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

function remove() {
  local file=$1
  if [[ -e "$file" ]]; then
    rm -rf "$file"
    success "Removed: $file"
  else
    warning "File not found: $file"
  fi
}

# Uninstall fish
info "Uninstalling fish..."
brew uninstall fisher
brew uninstall fish
# Remove fish configuration
remove "/home/linuxbrew/.linuxbrew/etc/fish"
# Remove fish from /etc/shells
sudo sed -i '/fish/d' /etc/shells
info "Fish uninstalled successfully"

# Uninstall mise
info "Uninstalling mise..."
$HOME/.local/bin/mise uninstall --all
remove "$HOME/.local/bin/mise"
info "Mise uninstalled successfully"

#  Uninstall Homebrew
info "Uninstalling Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
remove "/home/linuxbrew/.linuxbrew/etc"
remove "/home/linuxbrew/.linuxbrew/lib"
remove "/home/linuxbrew/.linuxbrew/share"
info "Homebrew uninstalled successfully"

# Config
info "Removing configuration files..."

## bashrc
info "Removing bashrc files..."
remove "$HOME/.bashrc"

## git
info "Removing git files..."
remove "$HOME/.gitconfig"
remove "$HOME/.config/git"

## ssh
info "Removing ssh files..."
remove "$HOME/.ssh/config"
remove "$HOME/.ssh/conf.d"

## homebrew
info "Removing homebrew files..."
remove "$HOME/.Brewfile"

#
success "Uninstallation completed successfully"
