BOOTSTRAP = script/bootstrap
DOT = ./bin/dot

all: link install
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
