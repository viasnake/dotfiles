CHEZMOI_BIN = $(HOME)/.local/bin/chezmoi
CHEZMOI_CMD = $(shell command -v chezmoi 2>/dev/null || echo "$(CHEZMOI_BIN)")
CHEZMOI = $(CHEZMOI_CMD) --source "$(CURDIR)"
CHEZMOI_INSTALL_URL = https://get.chezmoi.io

.PHONY: help all init ensure-chezmoi apply apply-scripts dry-run status diff verify managed test-ubuntu24-container test-ubuntu24-container-full remove-managed

help:
	@printf "Available targets:\n"
	@printf "  init           Install chezmoi if missing and apply this source state\n"
	@printf "  ensure-chezmoi Install chezmoi to ~/.local/bin when missing\n"
	@printf "  apply          Apply all managed files and scripts\n"
	@printf "  apply-scripts  Apply only chezmoi scripts\n"
	@printf "  dry-run        Show verbose apply plan without mutating target files\n"
	@printf "  status         Show what would change\n"
	@printf "  diff           Show detailed diff of pending changes\n"
	@printf "  verify         Verify target state matches rendered source state\n"
	@printf "  managed        List managed target paths\n"
	@printf "  test-ubuntu24-container Run Ubuntu 24.04 container bootstrap smoke test\n"
	@printf "  test-ubuntu24-container-full Run full Ubuntu 24.04 first-time setup in a container\n"
	@printf "  remove-managed Remove all currently managed files and symlinks from target\n"

all: apply

init: ensure-chezmoi apply

ensure-chezmoi:
	@if command -v chezmoi >/dev/null 2>&1; then \
	  echo "chezmoi is already installed: $$(chezmoi --version | head -n1)"; \
	else \
	  if ! command -v curl >/dev/null 2>&1; then \
	    echo "curl is required to install chezmoi. Please install curl and re-run make init." >&2; \
	    exit 1; \
	  fi; \
	  mkdir -p "$(HOME)/.local/bin"; \
	  sh -c "$$(curl -fsLS $(CHEZMOI_INSTALL_URL))" -- -b "$(HOME)/.local/bin"; \
	  if [ ! -x "$(CHEZMOI_BIN)" ]; then \
	    echo "chezmoi installation failed: $(CHEZMOI_BIN) was not created." >&2; \
	    exit 1; \
	  fi; \
	  echo "chezmoi installed at $(CHEZMOI_BIN)"; \
	  echo "If needed, add ~/.local/bin to PATH and re-open your shell."; \
	fi

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

test-ubuntu24-container:
	docker build -f test/ubuntu24/Dockerfile -t dotfiles-ubuntu24-test .
	docker run --rm dotfiles-ubuntu24-test

test-ubuntu24-container-full:
	docker build -f test/ubuntu24/Dockerfile -t dotfiles-ubuntu24-test .
	docker run --rm --env GITHUB_TOKEN --env DOTFILES_CONTAINER_TEST_MODE=full dotfiles-ubuntu24-test

remove-managed:
	@set -eu; \
	$(CHEZMOI) managed --include=files,symlinks --path-style=absolute | while IFS= read -r path; do \
	  if [ -n "$$path" ] && [ "$$path" != "/" ]; then \
	    rm -rf "$$path"; \
	  fi; \
	done
