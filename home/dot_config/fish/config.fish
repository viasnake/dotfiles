# nix
if test -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
  set -e __ETC_PROFILE_NIX_SOURCED
  source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
else if test -f "$HOME/.nix-profile/etc/profile.d/nix.fish"
  set -e __ETC_PROFILE_NIX_SOURCED
  source "$HOME/.nix-profile/etc/profile.d/nix.fish"
end

if test -d "$HOME/.local/state/nix/profiles/dotfiles-tools/bin"; and not contains -- "$HOME/.local/state/nix/profiles/dotfiles-tools/bin" $PATH
  set -gx PATH "$HOME/.local/state/nix/profiles/dotfiles-tools/bin" $PATH
end

if test -d "$HOME/.local/bin"; and not contains -- "$HOME/.local/bin" $PATH
  set -gx PATH "$HOME/.local/bin" $PATH
end

if test -f ~/.config/dotfiles/secrets.fish
  source ~/.config/dotfiles/secrets.fish
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

  #
  set --universal pure_show_system_time true

else
  if command -q mise
    mise activate fish --shims | source
  end
end
