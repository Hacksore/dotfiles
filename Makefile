.PHONY: install uninstall

install:
	stow .
uninstall:
	stow -D .