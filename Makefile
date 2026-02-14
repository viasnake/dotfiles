BOOTSTRAP = script/bootstrap
DOT = ./script/dot

.PHONY: all setup clean install uninstall link unlink install_fonts uninstall_fonts \
	opencode_validate opencode_sync \
	dot-bootstrap dot-bootstrap-agent dot-work-enable dot-work-disable dot-work-status dot-work-sync \
	dot-ssh-sync dot-ssh-sync-agent dot-ssh-status dot-ssh-test

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

opencode_sync:
	script/opencode/sync

dot-bootstrap:
	$(DOT) bootstrap

dot-bootstrap-agent:
	$(DOT) bootstrap --agent

dot-work-enable:
	$(DOT) work enable

dot-work-disable:
	$(DOT) work disable

dot-work-status:
	$(DOT) work status

dot-work-sync:
	$(DOT) work sync

dot-ssh-sync:
	$(DOT) ssh sync

dot-ssh-sync-agent:
	$(DOT) ssh sync --agent

dot-ssh-status:
	$(DOT) ssh status

dot-ssh-test:
	$(DOT) ssh test
