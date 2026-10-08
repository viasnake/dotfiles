# shellcheck shell=bash
# One source/destination mapping for copying and removal; paths may contain spaces.
config_files() {
  local operation="${1:-files_copy}"
  "$operation" "$DOTFILES_ROOT/config/shell/env.sh" "$HOME/.config/shell/env.sh"
  "$operation" "$DOTFILES_ROOT/config/bash/.bash_profile" "$HOME/.bash_profile"
  "$operation" "$DOTFILES_ROOT/config/bash/.bashrc" "$HOME/.bashrc"
  "$operation" "$DOTFILES_ROOT/config/zsh/.zshenv" "$HOME/.zshenv"
  "$operation" "$DOTFILES_ROOT/config/zsh/.zprofile" "$HOME/.zprofile"
  "$operation" "$DOTFILES_ROOT/config/zsh/.zshrc" "$HOME/.zshrc"
  "$operation" "$DOTFILES_ROOT/config/git/.gitconfig" "$HOME/.gitconfig"
  "$operation" "$DOTFILES_ROOT/config/ssh/config" "$HOME/.ssh/config"
  "$operation" "$DOTFILES_ROOT/config/ssh/config.d/00-base.conf" "$HOME/.ssh/config.d/00-base.conf"
  "$operation" "$DOTFILES_ROOT/config/fish/config.fish" "$HOME/.config/fish/config.fish"
  "$operation" "$DOTFILES_ROOT/config/fish/fish_plugins" "$HOME/.config/fish/fish_plugins"
  "$operation" "$DOTFILES_ROOT/config/fish/functions/fish_greeting.fish" "$HOME/.config/fish/functions/fish_greeting.fish"
  "$operation" "$DOTFILES_ROOT/config/termlog/config.toml" "$HOME/.config/termlog/config.toml"
  "$operation" "$DOTFILES_ROOT/config/mise/config.toml" "$HOME/.config/mise/config.toml"
  config_agent_files "$operation"
}

# Apply only after termlog has passed its recording check.
config_terminal_files() {
  local operation="${1:-files_copy}"
  "$operation" "$DOTFILES_ROOT/config/alacritty/rose-pine.toml" \
    "${XDG_CONFIG_HOME:-$HOME/.config}/alacritty/rose-pine.toml"
  "$operation" "$DOTFILES_ROOT/config/alacritty/alacritty.toml" \
    "${XDG_CONFIG_HOME:-$HOME/.config}/alacritty/alacritty.toml"
}

config_agent_files() {
  local operation="${1:-files_copy}"
  local codex_home="${CODEX_HOME:-$HOME/.codex}"
  local pi_home="${PI_CODING_AGENT_DIR:-$HOME/.pi/agent}"
  local opencode_home="${XDG_CONFIG_HOME:-$HOME/.config}/opencode"
  local skill_file

  "$operation" "$DOTFILES_ROOT/config/codex/AGENTS.md" "$codex_home/AGENTS.md"
  "$operation" "$DOTFILES_ROOT/config/codex/config.toml" "$codex_home/config.toml"
  "$operation" "$DOTFILES_ROOT/config/pi/AGENTS.md" "$pi_home/AGENTS.md"
  "$operation" "$DOTFILES_ROOT/config/opencode/AGENTS.md" "$opencode_home/AGENTS.md"
  "$operation" "$DOTFILES_ROOT/config/opencode/agents/architect.md" "$opencode_home/agents/architect.md"
  "$operation" "$DOTFILES_ROOT/config/opencode/agents/build.md" "$opencode_home/agents/build.md"
  "$operation" "$DOTFILES_ROOT/config/opencode/agents/docs-researcher.md" "$opencode_home/agents/docs-researcher.md"
  "$operation" "$DOTFILES_ROOT/config/opencode/agents/implementer.md" "$opencode_home/agents/implementer.md"
  "$operation" "$DOTFILES_ROOT/config/opencode/agents/orchestrator.md" "$opencode_home/agents/orchestrator.md"
  "$operation" "$DOTFILES_ROOT/config/opencode/agents/pattern-guardian.md" "$opencode_home/agents/pattern-guardian.md"
  "$operation" "$DOTFILES_ROOT/config/opencode/agents/plan-reviewer.md" "$opencode_home/agents/plan-reviewer.md"
  "$operation" "$DOTFILES_ROOT/config/opencode/agents/plan.md" "$opencode_home/agents/plan.md"
  "$operation" "$DOTFILES_ROOT/config/opencode/agents/planner.md" "$opencode_home/agents/planner.md"
  "$operation" "$DOTFILES_ROOT/config/opencode/agents/repo-explorer.md" "$opencode_home/agents/repo-explorer.md"
  "$operation" "$DOTFILES_ROOT/config/opencode/agents/security-auditor.md" "$opencode_home/agents/security-auditor.md"
  "$operation" "$DOTFILES_ROOT/config/opencode/agents/work-orchestrator.md" "$opencode_home/agents/work-orchestrator.md"
  "$operation" "$DOTFILES_ROOT/config/opencode/instructions/coding-style.md" "$opencode_home/instructions/coding-style.md"
  "$operation" "$DOTFILES_ROOT/config/opencode/instructions/documentation.md" "$opencode_home/instructions/documentation.md"
  "$operation" "$DOTFILES_ROOT/config/opencode/opencode.jsonc" "$opencode_home/opencode.jsonc"

  for skill_file in SKILL.md agents/openai.yaml \
    references/cases.md references/japanese-style.md \
    references/language-foundations.md references/patterns.md; do
    "$operation" "$DOTFILES_ROOT/config/skills/ja-writing-humanizer/$skill_file" \
      "$codex_home/skills/ja-writing-humanizer/$skill_file"
    "$operation" "$DOTFILES_ROOT/config/skills/ja-writing-humanizer/$skill_file" \
      "$opencode_home/skills/ja-writing-humanizer/$skill_file"
  done
}
