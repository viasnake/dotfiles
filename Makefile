BOOTSTRAP = script/bootstrap
DOT = ./script/dot

.PHONY: all setup clean install uninstall link unlink install_fonts uninstall_fonts \
	opencode_validate \
	dot-bootstrap

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
