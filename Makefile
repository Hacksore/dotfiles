# TODO: move these to the tasks script
.PHONY: export apps docs 

apps:
	brew bundle --file ${HOME}/dotfiles/Brewfile
export:
	brew bundle dump --file ${HOME}/dotfiles/Brewfile --force
test:
	@pnpm test
