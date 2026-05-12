CHEZMOI = chezmoi --source "$(CURDIR)"

.PHONY: help all apply apply-scripts dry-run status diff verify managed remove-managed

help:
	@printf "Available targets:\n"
	@printf "  apply          Apply all managed files and scripts\n"
	@printf "  apply-scripts  Apply only chezmoi scripts\n"
	@printf "  dry-run        Show verbose apply plan without mutating target files\n"
	@printf "  status         Show what would change\n"
	@printf "  diff           Show detailed diff of pending changes\n"
	@printf "  verify         Verify target state matches rendered source state\n"
	@printf "  managed        List managed target paths\n"
	@printf "  remove-managed Remove all currently managed files and symlinks from target\n"

all: apply

apply:
	$(CHEZMOI) apply

apply-scripts:
	$(CHEZMOI) apply --include=scripts

dry-run:
	$(CHEZMOI) apply --dry-run --verbose

status:
	$(CHEZMOI) status

diff:
	$(CHEZMOI) diff

verify:
	$(CHEZMOI) verify

managed:
	$(CHEZMOI) managed --include=files,symlinks --path-style=absolute

remove-managed:
	@set -eu; \
	$(CHEZMOI) managed --include=files,symlinks --path-style=absolute | while IFS= read -r path; do \
	  if [ -n "$$path" ] && [ "$$path" != "/" ]; then \
	    rm -rf "$$path"; \
	  fi; \
	done
