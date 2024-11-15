#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# Path to download
download_path="misc/mozc_dict"

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

function download() {
  local url=$1
  local output=$(basename $url)
  if [ -e $output ]; then
    info "Skip downloading $output"
  else
    info "Downloading $output"
    curl -L -o $output $url
  fi

  info "Moving $output to $download_path"
  mv $output $download_path
}

function download_and_extract() {
  local url=$1
  local output=$(basename $url)
  if [ -e $output ]; then
    info "Skip downloading $output"
  else
    info "Downloading $output"
    curl -L -o $output $url
  fi

  info "Extracting $output"
  unzip -o $output -d $download_path

  info "Removing $output"
  rm $output
}

# Download
{
  download https://raw.githubusercontent.com/anilogia/animedb/refs/heads/master/dict/google-ime-dict.txt
  download_and_extract https://github.com/peaceiris/emoji-ime-dictionary/releases/latest/download/emoji.zip
  download_and_extract https://github.com/peaceiris/google-ime-dictionary/releases/latest/download/abbreviation.zip
  download_and_extract https://github.com/peaceiris/google-ime-dictionary/releases/latest/download/day_month.zip
  download_and_extract https://github.com/peaceiris/google-ime-dictionary/releases/latest/download/edict-googleime.zip
}
