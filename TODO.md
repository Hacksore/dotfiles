# Fix these for nvim
- make buffer change hotkey respect order in UI
- git gutter should always auto reload and not get cached

### Notes
- files the have strange amounts of JSX will break prettier formatting and cause weird angle brace indents
  - I think this is fixed now 😳
- big json files still halt the editor
  - tweaked this by tuning the buffer and line size
- control+o/i should reopen a closed buffer [tracked via this issue](https://github.com/neovim/neovim/issues/28968)
  - This seems to be working in NVIM v0.11.0-dev-608+g9d74dc3ac-Homebrew
- format on save in typescript files (caused by pack?)
  - pack: https://github.com/AstroNvim/astrocommunity/tree/main/lua/astrocommunity/pack/typescript
