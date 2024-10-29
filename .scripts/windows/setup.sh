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
  # WSL does not support symlinking
  error "Symlinking is not supported on WSL"
}

error "This script is not supported on WSL"
exit 1
