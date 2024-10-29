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

# Uninstall fish
info "Uninstalling fish..."
brew uninstall fisher
brew uninstall fish
rm -rf "/home/linuxbrew/.linuxbrew/etc/fish"
# Remove fish from /etc/shells
sudo sed -i '/fish/d' /etc/shells
info "Fish uninstalled successfully"

# Uninstall mise
info "Uninstalling mise..."
$HOME/.local/bin/mise uninstall --all
rm -f "$HOME/.local/bin/mise"
info "Mise uninstalled successfully"

#  Uninstall Homebrew
info "Uninstalling Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
rm -rf "/home/linuxbrew/.linuxbrew/etc"
rm -rf "/home/linuxbrew/.linuxbrew/lib"
rm -rf "/home/linuxbrew/.linuxbrew/share"
info "Homebrew uninstalled successfully"

# Config
info "Removing configuration files..."

## bashrc
info "Removing bashrc files..."
rm -f "$HOME/.bashrc"

## git
info "Removing git files..."
rm -f "$HOME/.gitconfig"
rm -rf "$HOME/.config/git"

## ssh
info "Removing ssh files..."
rm -f "$HOME/.ssh/config"
rm -rf "$HOME/.ssh/conf.d"

## homebrew
info "Removing homebrew files..."
rm -f "$HOME/.Brewfile"

info "Configuration files removed successfully"

#
success "Uninstallation completed successfully"
