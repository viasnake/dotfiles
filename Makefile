BOOTSTRAP = script/bootstrap

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
