#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export PATH="$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:/home/linuxbrew/.linuxbrew/bin:$PATH"

if [[ $# -ne 0 ]]; then
  printf 'Usage: bash script/termlog.sh\n' >&2
  exit 2
fi
if [[ ! -t 0 || ! -t 1 ]]; then
  printf 'termlog: setup requires an interactive terminal for the recording smoke test.\n' >&2
  exit 1
fi
command -v python3 >/dev/null
# Rust is installed by script/tools.sh through mise.
mise exec rust -- cargo install --locked --force \
  --git https://github.com/viasnake/termlog.git \
  --rev 99026c0cfd0e986c14813822922549e2d15107b0 --root "$HOME/.local" termlog
binary="$HOME/.local/bin/termlog"
"$binary" --version

# A recording must work before changing the terminal startup command.
env -u TERMLOG_ACTIVE -u TERMLOG_SESSION_ID "$binary" run -- /bin/sh -c '"$1" status && printf "termlog: recording smoke test succeeded\n"' sh "$binary"
python3 - "$binary" "$HOME/.config/ghostty/config" "$ROOT/config/ghostty/config" <<'PY'
import os
from pathlib import Path
import re
import shlex
import shutil
import sys
import tempfile

binary = Path(sys.argv[1]).absolute()
config = Path(sys.argv[2])
if '\n' in str(binary) or '\r' in str(binary):
    raise SystemExit('termlog: installation path contains a newline')
for p in [config, *config.parents]:
    if p.is_symlink():
        raise SystemExit(f'termlog: migrate symlink manually before enabling: {p}')
if config.exists() and not config.is_file():
    raise SystemExit(f'termlog: not a regular file: {config}')
original = config.read_text() if config.exists() else Path(sys.argv[3]).read_text()
command = f"command = {shlex.quote(str(binary))} run -- /bin/bash -lc 'exec fish'"
lines = original.splitlines()
result = []
replaced = False
for line in lines:
    if re.match(r'^\s*command\s*=', line):
        if not replaced:
            result.append(command)
            replaced = True
    else:
        result.append(line)
if not replaced:
    result.append(command)
updated = '\n'.join(result) + '\n'
if config.exists() and updated == original:
    print(f'termlog: unchanged {config}')
else:
    config.parent.mkdir(parents=True, exist_ok=True)
    backup = None
    if config.exists():
        backup = Path(tempfile.mkdtemp(prefix=config.name + '.backup.', dir=config.parent)) / 'original'
        shutil.copy2(config, backup)
    fd, tmp = tempfile.mkstemp(prefix=config.name + '.tmp.', dir=config.parent)
    try:
        with os.fdopen(fd, 'w') as f:
            f.write(updated)
        if config.exists():
            shutil.copymode(config, tmp)
        os.replace(tmp, config)
    finally:
        if os.path.exists(tmp):
            os.unlink(tmp)
    print(f'termlog: enabled recording in {config}; backup: {backup}')
PY
