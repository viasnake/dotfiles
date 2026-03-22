BOOTSTRAP = script/bootstrap
DOT = ./script/dot

.PHONY: all setup clean install uninstall link unlink install_fonts uninstall_fonts \
	opencode_validate \
	dot-bootstrap \
	test test-smoke test-unit

all: setup
setup: link install dot-bootstrap
clean: uninstall unlink

install:
	$(BOOTSTRAP) install
uninstall:
	$(BOOTSTRAP) uninstall
link:
	$(BOOTSTRAP) link
unlink:
	$(BOOTSTRAP) unlink
install_fonts:
	$(BOOTSTRAP) install_fonts
uninstall_fonts:
	$(BOOTSTRAP) uninstall_fonts

opencode_validate:
	script/opencode/validate

dot-bootstrap:
	$(DOT) bootstrap

test: test-smoke test-unit

test-smoke:
	$(DOT) help
	$(MAKE) opencode_validate
	$(MAKE) -n dot-bootstrap

test-unit:
	@if command -v bats >/dev/null 2>&1; then \
	  bats test; \
	elif command -v mise >/dev/null 2>&1; then \
	  MISE_WARN_MISSING_TOOLS=0 mise x bats -- bats test; \
	elif [ -n "${CI:-}" ]; then \
	  printf '[ERROR] bats is required in CI but was not found\n' >&2; \
	  exit 1; \
	else \
	  printf '[INFO] bats/mise not found, skipping unit tests\n'; \
	fi
