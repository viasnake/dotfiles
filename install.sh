#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ $# -ne 0 ]]; then
  printf 'Usage: ./install.sh\n' >&2
  exit 2
fi
if [[ ! -t 0 || ! -t 1 ]]; then
  printf 'dotfiles: setup requires an interactive terminal for the recording smoke test.\n' >&2
  exit 1
fi
command -v python3 >/dev/null

bash "$ROOT/script/copy.sh"
bash "$ROOT/script/tools.sh"
bash "$ROOT/script/termlog.sh"
printf 'dotfiles: setup complete\n'
