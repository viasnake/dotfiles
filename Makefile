CHEZMOI_BIN = $(HOME)/.local/bin/chezmoi
CHEZMOI_CMD = $(shell command -v chezmoi 2>/dev/null || echo "$(CHEZMOI_BIN)")
CHEZMOI = $(CHEZMOI_CMD) --source "$(CURDIR)"
CHEZMOI_INSTALL_URL = https://get.chezmoi.io
LOG_RUN ?= $(CURDIR)/script/log-run
SKILL_AGENTS ?= codex opencode
SKILL_AGENT ?=
SKILL_SCOPE ?= user
SKILL_INSTALL_FLAGS ?= --force
SKILL_MANIFEST = agent-skills.tsv
UBUNTU_TEST_VERSIONS ?= 20.04 26.04
UBUNTU_TEST_IMAGE_PREFIX ?= dotfiles-ubuntu-test
MAKEFLAGS += --no-print-directory

.PHONY: help all init ensure-chezmoi ensure-gh-skill apply apply-scripts dry-run status diff verify managed skills-install skills-update skills-update-dry-run test-ubuntu-container test-ubuntu-container-full test-ubuntu20-container test-ubuntu20-container-full test-ubuntu24-container test-ubuntu24-container-full test-ubuntu26-container test-ubuntu26-container-full test-macos-docker-osx-preflight test-macos-docker-osx-smoke remove-managed

help:
	@printf "Available targets:\n"
	@printf "  init           Install chezmoi if missing and apply this source state\n"
	@printf "  ensure-chezmoi Install chezmoi to ~/.local/bin when missing\n"
	@printf "  skills-install Install agent skills from agent-skills.tsv for SKILL_AGENTS\n"
	@printf "  skills-update  Update installed agent skills with gh skill\n"
	@printf "  skills-update-dry-run Check agent skill updates without mutating files\n"
	@printf "  apply          Apply all managed files and scripts\n"
	@printf "  apply-scripts  Apply only chezmoi scripts\n"
	@printf "  dry-run        Show verbose apply plan without mutating target files\n"
	@printf "  status         Show what would change\n"
	@printf "  diff           Show detailed diff of pending changes\n"
	@printf "  verify         Verify target state matches rendered source state\n"
	@printf "  managed        List managed target paths\n"
	@printf "  test-ubuntu-container Run Ubuntu container smoke tests for UBUNTU_TEST_VERSIONS\n"
	@printf "  test-ubuntu-container-full Run full Ubuntu first-time setup for UBUNTU_TEST_VERSIONS\n"
	@printf "  test-ubuntu20-container Run Ubuntu 20.04 container bootstrap smoke test\n"
	@printf "  test-ubuntu20-container-full Run full Ubuntu 20.04 first-time setup in a container\n"
	@printf "  test-ubuntu24-container Run Ubuntu 24.04 container bootstrap smoke test\n"
	@printf "  test-ubuntu24-container-full Run full Ubuntu 24.04 first-time setup in a container\n"
	@printf "  test-ubuntu26-container Run Ubuntu 26.04 container bootstrap smoke test\n"
	@printf "  test-ubuntu26-container-full Run full Ubuntu 26.04 first-time setup in a container\n"
	@printf "  test-macos-docker-osx-preflight Check host support for Docker-OSX macOS validation\n"
	@printf "  test-macos-docker-osx-smoke Start Docker-OSX and verify QEMU starts with KVM\n"
	@printf "  remove-managed Remove all currently managed files and symlinks from target\n"
	@printf "\n"
	@printf "Log display:\n"
	@printf "  Commands run through script/log-run. Set DOTFILES_LOG_COLOR=never to disable color.\n"

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

ensure-gh-skill:
	@if ! gh skill --help >/dev/null 2>&1; then \
	  printf "gh skill is unavailable. Install GitHub CLI 2.91.0 or newer, then re-run this target.\n" >&2; \
	  exit 1; \
	fi

apply:
	@$(LOG_RUN) "chezmoi apply" -- $(CHEZMOI) apply

apply-scripts:
	@$(LOG_RUN) "chezmoi apply scripts" -- $(CHEZMOI) apply --include=scripts

dry-run:
	@$(LOG_RUN) "chezmoi dry run" -- $(CHEZMOI) apply --dry-run --verbose

status:
	@$(LOG_RUN) "chezmoi status" -- $(CHEZMOI) status

diff:
	@$(LOG_RUN) "chezmoi diff" -- $(CHEZMOI) diff

verify:
	@$(LOG_RUN) "chezmoi verify" -- $(CHEZMOI) verify

managed:
	@$(LOG_RUN) "chezmoi managed files" -- $(CHEZMOI) managed --include=files,symlinks --path-style=absolute

skills-install: ensure-gh-skill
	@agents="$(if $(SKILL_AGENT),$(SKILL_AGENT),$(SKILL_AGENTS))"; \
	awk 'BEGIN { FS = "\t" } !/^#/ && NF >= 2 { print $$1, $$2 }' "$(SKILL_MANIFEST)" | while read -r repo skill; do \
	  for agent in $$agents; do \
	    printf "Installing %s from %s for %s/%s\n" "$$skill" "$$repo" "$$agent" "$(SKILL_SCOPE)"; \
	    "$(LOG_RUN)" "gh skill install $$skill ($$agent)" -- gh skill install "$$repo" "$$skill" --agent "$$agent" --scope "$(SKILL_SCOPE)" --allow-hidden-dirs $(SKILL_INSTALL_FLAGS); \
	  done; \
	done

skills-update: ensure-gh-skill
	@$(LOG_RUN) "gh skill update" -- gh skill update --all

skills-update-dry-run: ensure-gh-skill
	@$(LOG_RUN) "gh skill update dry run" -- gh skill update --dry-run

test-ubuntu-container:
	@set -eu; \
	for version in $(UBUNTU_TEST_VERSIONS); do \
	  image="$(UBUNTU_TEST_IMAGE_PREFIX):$$version"; \
	  printf 'Building Ubuntu %s test image: %s\n' "$$version" "$$image"; \
	  "$(LOG_RUN)" "docker build Ubuntu $$version" -- docker build --build-arg "UBUNTU_VERSION=$$version" -f test/ubuntu/Dockerfile -t "$$image" .; \
	  printf 'Running Ubuntu %s smoke test\n' "$$version"; \
	  "$(LOG_RUN)" "docker run Ubuntu $$version smoke" -- docker run --rm "$$image"; \
	done

test-ubuntu-container-full:
	@set -eu; \
	for version in $(UBUNTU_TEST_VERSIONS); do \
	  image="$(UBUNTU_TEST_IMAGE_PREFIX):$$version"; \
	  printf 'Building Ubuntu %s test image: %s\n' "$$version" "$$image"; \
	  "$(LOG_RUN)" "docker build Ubuntu $$version" -- docker build --build-arg "UBUNTU_VERSION=$$version" -f test/ubuntu/Dockerfile -t "$$image" .; \
	  printf 'Running Ubuntu %s full setup test\n' "$$version"; \
	  "$(LOG_RUN)" "docker run Ubuntu $$version full setup" -- docker run --rm --env GITHUB_TOKEN --env DOTFILES_CONTAINER_TEST_MODE=full "$$image"; \
	done

test-ubuntu20-container:
	@$(LOG_RUN) "make Ubuntu 20.04 smoke" -- $(MAKE) test-ubuntu-container UBUNTU_TEST_VERSIONS=20.04

test-ubuntu20-container-full:
	@$(LOG_RUN) "make Ubuntu 20.04 full setup" -- $(MAKE) test-ubuntu-container-full UBUNTU_TEST_VERSIONS=20.04

test-ubuntu24-container:
	@$(LOG_RUN) "make Ubuntu 24.04 smoke" -- $(MAKE) test-ubuntu-container UBUNTU_TEST_VERSIONS=24.04

test-ubuntu24-container-full:
	@$(LOG_RUN) "make Ubuntu 24.04 full setup" -- $(MAKE) test-ubuntu-container-full UBUNTU_TEST_VERSIONS=24.04

test-ubuntu26-container:
	@$(LOG_RUN) "make Ubuntu 26.04 smoke" -- $(MAKE) test-ubuntu-container UBUNTU_TEST_VERSIONS=26.04

test-ubuntu26-container-full:
	@$(LOG_RUN) "make Ubuntu 26.04 full setup" -- $(MAKE) test-ubuntu-container-full UBUNTU_TEST_VERSIONS=26.04

test-macos-docker-osx-preflight:
	@$(LOG_RUN) "Docker-OSX preflight" -- test/macos-docker-osx/preflight.sh

test-macos-docker-osx-smoke:
	@$(LOG_RUN) "Docker-OSX smoke" -- test/macos-docker-osx/smoke.sh

remove-managed:
	@set -eu; \
	"$(LOG_RUN)" "remove managed files" -- sh -eu -c '$(CHEZMOI) managed --include=files,symlinks --path-style=absolute | while IFS= read -r path; do \
	  if [ -n "$$path" ] && [ "$$path" != "/" ]; then \
	    rm -rf "$$path"; \
	  fi; \
	done'
