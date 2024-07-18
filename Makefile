.PHONY: export apps docs 

apps:
	brew bundle --file ${HOME}/dotfiles/Brewfile
export:
	brew bundle dump --file ${HOME}/dotfiles/Brewfile --force
docs:
	docker buildx build --platform=linux/amd64 . -t dotfiles-docs
test:
	echo this is a test
