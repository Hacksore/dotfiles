# Fix these for nvim
- files the have strange amounts of JSX will break prettier formatting and cause weird angle brace indents
  - strangely when auto format happens it's fine it's just when using <Leader>lf
- big json files still halt the editor
  - astro seems to have some optimizations that suck cause it still makes the edit crawl

### Notes

- control+o/i should reopen a closed buffer [tracked via this issue](https://github.com/neovim/neovim/issues/28968)
  - This seems to be working in NVIM v0.11.0-dev-608+g9d74dc3ac-Homebrew
- format on save in typescript files (caused by pack?)
  - pack: https://github.com/AstroNvim/astrocommunity/tree/main/lua/astrocommunity/pack/typescript
