# shellcheck shell=bash
# Apply an explicit mapping function as one batch. Bash dynamic scope keeps the
# pending count local to this invocation while file operations accumulate conflicts.
# Call directly under strict mode, not inside an if/! condition.
files_apply() {
  local FILES_PENDING=0
  "$@"
  if [[ "$FILES_PENDING" -gt 0 ]]; then
    log_error "$FILES_PENDING file(s) pending; resolve them before retrying."
    return 1
  fi
}

files_copy() {
  local source="$1" target="$2" status
  if ! files_regular_target "$target"; then
    FILES_PENDING=$((FILES_PENDING + 1))
    return
  fi

  if [[ -f "$target" ]] && cmp -s "$target" "$source"; then
    printf 'dotfiles: unchanged %s\n' "$target"
    return
  fi

  if [[ -f "$target" ]]; then
    printf '\ndotfiles: review %s\n' "$target"
    # Installed file first, repository version second; diff status 1 is expected.
    status=0
    diff -u "$target" "$source" || status=$?
    if [[ "$status" -gt 1 ]]; then return "$status"; fi

    if ! files_confirm_replacement; then
      printf 'dotfiles: pending %s (kept existing file)\n' "$target"
      FILES_PENDING=$((FILES_PENDING + 1))
      return
    fi

    files_backup "$target"
  fi

  files_replace "$source" "$target"
}

# Return success only for an explicit yes from a terminal. Quit aborts setup.
files_confirm_replacement() {
  local answer
  [[ -t 0 ]] || return 1
  while true; do
    read -r -p 'Back up and replace? [y/N/q] ' answer || answer=n
    case "$answer" in
      y|Y) return 0 ;;
      n|N|'') return 1 ;;
      q|Q) printf 'dotfiles: cancelled\n' >&2; exit 1 ;;
    esac
  done
}

files_backup() {
  local target="$1" backup
  backup="$(mktemp -d "${target}.backup.XXXXXX")"
  cp -p "$target" "$backup/original"
  printf 'dotfiles: backup %s/original\n' "$backup"
}

files_replace() {
  local source="$1" target="$2" temporary
  mkdir -p "$(dirname "$target")"
  temporary="$(mktemp "${target}.tmp.XXXXXX")"
  # Rename a complete copy into place instead of truncating the installed file.
  if ! { cp -p "$source" "$temporary" && mv -f "$temporary" "$target"; }; then
    rm -f "$temporary"
    return 1
  fi
  printf 'dotfiles: copied %s\n' "$target"
}

# Shared boundary for both replacement and removal, including ancestors of HOME.
files_regular_target() {
  local target="$1" parent
  if [[ "$target" != /* ]]; then
    log_error "Expected an absolute target path: $target"
    return 1
  fi
  parent="$(dirname "$target")"

  # Never write through a symlinked parent directory.
  while [[ "$parent" != / ]]; do
    if [[ -L "$parent" ]]; then
      printf 'dotfiles: pending %s (parent is a symlink: %s; replace it manually)\n' "$target" "$parent" >&2
      return 1
    fi
    parent="$(dirname "$parent")"
  done

  if [[ -L "$target" || ( -e "$target" && ! -f "$target" ) ]]; then
    printf 'dotfiles: pending %s (not an independent regular file; move it manually)\n' "$target" >&2
    return 1
  fi

  return 0
}

# Modified files are retained; uninstall never guesses which backup to restore.
files_check_removal() {
  local source="$1" target="$2" status=0
  if ! files_regular_target "$target"; then
    FILES_PENDING=$((FILES_PENDING + 1))
    return
  fi
  [[ -e "$target" ]] || return 0
  cmp -s "$source" "$target" || status=$?
  case "$status" in
    0) ;;
    1)
      log_error "pending $target (modified; back up and move it manually before uninstall)"
      FILES_PENDING=$((FILES_PENDING + 1))
      ;;
    *) log_error "Cannot compare $target"; return "$status" ;;
  esac
}

files_remove() {
  local source="$1" target="$2"
  local FILES_PENDING=0
  files_check_removal "$source" "$target"
  [[ "$FILES_PENDING" -eq 0 ]] || return 1
  if [[ -f "$target" ]]; then
    files_backup "$target"
    rm -- "$target"
    log_info "removed $target"
  fi
}
