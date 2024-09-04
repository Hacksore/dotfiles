# NEW CONFIG CAN MABYE FIX ALL OF THESE THINGS

action items

- get toggle term working
- fix all keybinds

---

# Fix these for nvim

- treesitter typescript and tsx are bugged with `type`

  - https://github.com/tree-sitter/tree-sitter-typescript/issues/276
  - https://github.com/AstroNvim/AstroNvim/issues/1316
  - ![image](https://github.com/user-attachments/assets/028da36b-7151-4147-9046-57132cfb4c8d)

- make buffer change hotkey respect order in UI
  - currency the UI lays them out as FIFO but when navigating via the hotkey they are out of order?
- git gutter should always auto reload and not get cached
- files should just update if the buffer changes on the filesystem
- learn how to use undo tree 😂

### Notes

- files the have strange amounts of JSX will break prettier formatting and cause weird angle brace indents
  - I think this is fixed now 😳
- big json files still halt the editor
  - tweaked this by tuning the buffer and line size
- control+o/i should reopen a closed buffer [tracked via this issue](https://github.com/neovim/neovim/issues/28968)
  - This seems to be working in NVIM v0.11.0-dev-608+g9d74dc3ac-Homebrew
- format on save in typescript files (caused by pack?)
  - pack: https://github.com/AstroNvim/astrocommunity/tree/main/lua/astrocommunity/pack/typescript
