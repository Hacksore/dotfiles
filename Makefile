.PHONY: link unlink pkg apps ansible

link:
	stow .
unlink:
	stow -D .
apps:
	brew bundle --file ${HOME}/dotfiles/Brewfile
ansible:
	${HOME}/dotfiles/ansible/run.sh
export:
	brew bundle dump --file ${HOME}/dotfiles/Brewfile --force