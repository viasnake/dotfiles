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

function symlink() {
  ln -nfs "$1" "$2"
  success "Symlink created: $2 -> $1"

  # 本当は既存のファイルがある場合の処理も書くべき
  # if [[ -e "$2" ]]; then
  #   warning "File $2 already exists"
  # else
  #   ln -fs "$1" "$2"
  #   success "Symlink created: $2 -> $1"
  # fi
}

# Install Homebrew
info "Checking Homebrew..."
if ! which brew > /dev/null 2>&1; then
  warning "Homebrew is not installed"
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  success "Homebrew installed successfully"
else
  info "Homebrew is already installed"
fi

# Install brew packages
info "Installing brew packages..."
symlink "$PWD/homebrew/.Brewfile" "$HOME/.Brewfile"
brew bundle --global
success "Brew packages installed successfully"

# Install mise
info "Checking mise..."
if [[ ! -e "$HOME/.local/bin/mise" ]]; then
  warning "mise is not installed"
  info "Installing mise..."
  curl https://mise.run | sh
  success "mise installed successfully"
else
  info "mise is already installed"
fi

# Install python
info "Checking Python..."
if ! which python > /dev/null 2>&1; then
  warning "Python is not installed"
  info "Installing Python..."
  $HOME/.local/bin/mise use --global python
  success "Python installed successfully"
else
  info "Python is already installed"
fi

# Install node
info "Checking Node.js..."
if ! which node > /dev/null 2>&1; then
  warning "Node.js is not installed"
  info "Installing Node.js..."
  $HOME/.local/bin/mise use --global node
  success "Node.js installed successfully"
else
  info "Node.js is already installed"
fi

# Install go
info "Checking Go..."
if ! which go > /dev/null 2>&1; then
  warning "Go is not installed"
  info "Installing Go..."
  $HOME/.local/bin/mise use --global go
  success "Go installed successfully"
else
  info "Go is already installed"
fi

# Install ruby
info "Checking Ruby..."
if ! which ruby > /dev/null 2>&1; then
  warning "Ruby is not installed"
  info "Installing Ruby..."
  $HOME/.local/bin/mise use --global ruby
  success "Ruby installed successfully"
else
  info "Ruby is already installed"
fi

# Install Rust
info "Checking Rust..."
if ! which rustc > /dev/null 2>&1; then
  warning "Rust is not installed"
  info "Installing Rust..."
  $HOME/.local/bin/mise use --global rust
  success "Rust installed successfully"
else
  info "Rust is already installed"
fi

# Install Java
info "Checking Java..."
if ! which java > /dev/null 2>&1; then
  warning "Java is not installed"
  info "Installing Java..."
  $HOME/.local/bin/mise use --global java
  success "Java installed successfully"
else
  info "Java is already installed"
fi

# Install git
info "Checking Git..."
if ! which git > /dev/null 2>&1; then
  warning "Git is not installed"
  info "Installing Git..."
  brew install git
  success "Git installed successfully"
else
  info "Git is already installed"
fi

# Install fish
info "Checking Fish..."
if ! which fish > /dev/null 2>&1; then
  warning "Fish is not installed"
  info "Installing Fish..."
  brew install fish
  # Add fish to /etc/shells
  # If already added, it will not be added again
  if ! grep -q "/usr/local/bin/fish" /etc/shells; then
    echo "/usr/local/bin/fish" | sudo tee -a /etc/shells > /dev/null
  fi
  success "Fish installed successfully"
else
  info "Fish is already installed"
fi

# Config
info "Setting up configuration files..."

## bashrc
info "Setting up bashrc..."
symlink "$PWD/bash/$os/.bashrc" "$HOME/.bashrc"

## git
info "Setting up git..."
symlink "$PWD/git/$os/.gitconfig" "$HOME/.gitconfig"
symlink "$PWD/git/$os/.config" "$HOME/.config/git"

## ssh
info "Setting up ssh..."
symlink "$PWD/ssh/$os/config" "$HOME/.ssh/config"
symlink "$PWD/ssh/$os/conf.d" "$HOME/.ssh/conf.d"

#
info "Configuration files setup successfully"

#
info "Setup completed successfully"
info "Please restart your terminal to see the changes"
