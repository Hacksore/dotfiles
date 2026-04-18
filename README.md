# dotfiles

my setup for neovim, tmux, zsh, wezterm, and moar!

> [!WARNING]  
> This is not a neovim distro, it's my personal configs for a lot tools so use at your own risk!

<img width="4096" height="2304" alt="image" src="https://github.com/user-attachments/assets/c9a9d332-472c-4566-b203-c875233548f4" />

## Testing Neovim Configs
Probably one of the only degens to setup testing for their neovim config in CI 😂.

As of now you can take a look at the following code snippets on how this works.

- [Dockerfile](/Dockerfile) that uses `node:trixie-slim` as the base image; [setup-nvim.sh](/setup-nvim.sh) installs stable and nightly Neovim during the image build, and the image `ENTRYPOINT` runs `npx hack test`
- [`hack`](/packages/hack/src/cli.ts) CLI for building the docker image and testing it
- [Container test runner](/packages/hack/src/commands/test.ts) (`hack test`): Mason LSP install, headless Neovim, and optional lazy lock diff
- [`TestLSPTypescript` user command](/.config/nvim/lua/hacksore/test/typescript.lua) for asserting TypeScript diagnostics from the LSP
- How you can [avoid pagers in neovim](/.config/nvim/lua/hacksore/lazy.lua#L1-L3)
- [Running this in github action CI](/.github/workflows/nvim-ci.yaml)

Testing locally is as easy as `pnpm test` and it will build the docker image and run the test command to validate the following.

In CI here are some of the things these tests are for.
- Neovim Lua config does not have any errors
- Typescript LSP will attach to [simple.ts](/test/typescript/simple.ts) and validate diagnostics are emitted
- Mason installs my plugins at their latest version on both nightly and stable
- Mason also installs my current plugins at their frozen version ([`lazy-lock.json`](/.config/nvim/lazy-lock.json)) on both nightly and stable

Demo
[![asciicast](https://asciinema.org/a/748382.svg)](https://asciinema.org/a/748382?autoplay=1)
