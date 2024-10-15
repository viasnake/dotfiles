#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

PATH="$PATH:/home/linuxbrew/.linuxbrew/bin/brew"
PATH="$PATH:$HOME/.local/share/mise/installs/python/latest/bin"
PATH="$PATH:$HOME/.local/share/mise/installs/node/latest/bin"

function get_os() {
  # Get os name from script path
  os="$(basename "$(dirname "$(dirname "$0")")")"
}

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

function symlink() {
  if [[ -e "$2" ]]; then
    warning "File $2 already exists"
  else
    ln -s "$1" "$2"
    success "Symlink created: $2 -> $1"
  fi
}

# Get OS
get_os

# Install Homebrew
if ! which brew; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  success "Homebrew installed successfully"
else
  info "Homebrew is already installed"
fi

# Install mise
if [[ ! -e "$HOME/.local/bin/mise" ]]; then
  info "Installing mise..."
  curl https://mise.run | sh
  success "mise installed successfully"
else
  info "mise is already installed"
fi

# Install python
if ! which python; then
  info "Installing Python..."
  $HOME/.local/bin/mise use --global python
  success "Python installed successfully"
else
  info "Python is already installed"
fi

# Install node
if ! which node; then
  info "Installing Node.js..."
  $HOME/.local/bin/mise use --global node
  success "Node.js installed successfully"
else
  info "Node.js is already installed"
fi


# Install git
if ! which git; then
  info "Installing Git..."
  brew install git
  success "Git installed successfully"
else
  info "Git is already installed"
fi

## Config
symlink "$HOME/git/$os/.gitconfig" "$HOME/.gitconfig"
symlink "$HOME/git/$os/cond.d" "$HOME/.config/git"
