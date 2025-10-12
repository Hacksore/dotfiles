# dotfiles

my setup for neovim, tmux, zsh, wezterm, and moar!

> [!WARNING]  
> This is not a neovim distro, it's my personal configs for a lot tools so use at your own risk!

<img width="4096" height="2304" alt="image" src="https://github.com/user-attachments/assets/c9a9d332-472c-4566-b203-c875233548f4" />

## Testing Neovim Configs
Probably one of the only degens to setup testing for their neovim config in CI 😂.

As of now you can take a look at the following code snippets on how this works.

- [Dockerfile](/Dockerfile) that uses `node:trixie-slim` as the base image
- [`hack cli`](/packages/hack/src/cli.ts) for building the docker image and testing it
- [main docker entry script](/test-nvim.sh) with a lot of the sauce
- [`TestTypescriptLSP` nvim command](/.config/nvim/lua/hacksore/core/lsp-validation.lua) for testing that the LSP does what it should
- How you can [avoid pagers in neovim](https://github.com/Hacksore/dotfiles/blob/a808133b4d34f1b26097398612b1fe881829152c/.config/nvim/lua/hacksore/lazy.lua#L1-L3)
- [Running this in github action CI](/.github/workflows/nvim-ci.yaml)

Testing locally is as easy as `pnpm test` and it will build the docker image and run the test command to validate the following.

- Neovim config does not have any errors
- Typescript LSP will attach to [simple.ts](/__test__/typescript/simple.ts] and emit diagnostics

Demo
[![asciicast](https://asciinema.org/a/748382.svg)](https://asciinema.org/a/748382?autoplay=1)
