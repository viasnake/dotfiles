#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

bash "$ROOT/script/copy.sh"
bash "$ROOT/script/tools.sh"
printf 'dotfiles: setup complete\n'
