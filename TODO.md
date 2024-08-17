# Fix these for nvim
- format on save in typescript files (caused by pack?)
  - pack: https://github.com/AstroNvim/astrocommunity/tree/main/lua/astrocommunity/pack/typescript
- files the have strange amounts of JSX will break prettier formatting and cause weird angle brace indents
    - strangely when auto format happens it's fine it's just when using <Leader>lf
- control+o/i should reopen a closed buffer
  - tracked via https://github.com/neovim/neovim/issues:set jumpoptions-=unload/28968
- big json files still halt the editor
  - astro seems to have some optimizations that suck cause it still makes the edit crawl

