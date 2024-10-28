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
if ! which brew > /dev/null 2>&1; then
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
if ! which python > /dev/null 2>&1; then
  info "Installing Python..."
  $HOME/.local/bin/mise use --global python
  success "Python installed successfully"
else
  info "Python is already installed"
fi

# Install node
if ! which node > /dev/null 2>&1; then
  info "Installing Node.js..."
  $HOME/.local/bin/mise use --global node
  success "Node.js installed successfully"
else
  info "Node.js is already installed"
fi


# Install git
if ! which git > /dev/null 2>&1; then
  info "Installing Git..."
  brew install git
  success "Git installed successfully"
else
  info "Git is already installed"
fi

# Config
## bashrc
symlink "$PWD/bash/$os/.bashrc" "$HOME/.bashrc"
## git
symlink "$PWD/git/$os/.gitconfig" "$HOME/.gitconfig"
symlink "$PWD/git/$os/.config" "$HOME/.config/git"
## ssh
symlink "$PWD/ssh/$os/config" "$HOME/.ssh/config"
symlink "$PWD/ssh/$os/conf.d" "$HOME/.ssh/conf.d"
