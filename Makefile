.PHONY: export apps docs 

apps:
	brew bundle --file ${HOME}/dotfiles/Brewfile
export:
	brew bundle dump --file ${HOME}/dotfiles/Brewfile --force
build:
	@docker build --platform linux/amd64 --progress=plain . -t hacksore/nvim
test: build
	docker run --platform linux/amd64 -e LOCAL=1 --rm -it hacksore/nvim "nightly"
