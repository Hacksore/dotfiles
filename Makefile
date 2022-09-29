.PHONY: install uninstall

install:
	stow .
uninstall:
	stow -D .
pkg:
	${HOME}/ansible/run.sh