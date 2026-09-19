# Fish is the human interface. Child processes should see Bash / zsh as SHELL.
switch "$SHELL"
  case '*/bash' '*/zsh' '*/sh'
    # Keep the inherited system shell.
  case '*'
    if test (uname -s) = Darwin
      set -gx SHELL /bin/zsh
    else
      set -gx SHELL /bin/bash
    end
end

for bin in /home/linuxbrew/.linuxbrew/bin /usr/local/bin /opt/homebrew/bin "$HOME/.local/bin"
  fish_add_path --global --path "$bin"
end
set -l mise_data "$HOME/.local/share/mise"
if set -q MISE_DATA_DIR
  set mise_data "$MISE_DATA_DIR"
end
fish_add_path --global --path "$mise_data/shims"

if test -f "$HOME/.config/env.local.fish"
  source "$HOME/.config/env.local.fish"
end

if status is-interactive
  if command -q mise
    mise activate fish | source
  end
  if command -q zoxide
    zoxide init fish --cmd cd | source
  end
  if command -q fzf
    fzf --fish | source
  end
  set -g pure_show_system_time true
end
