local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/nvim/plugged')

-- completion stuff
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/cmp-cmdline')
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/cmp-path')
Plug('hrsh7th/cmp-vsnip')
Plug('hrsh7th/nvim-cmp')

-- telescope dep and install
Plug('nvim-lua/plenary.nvim')
Plug('nvim-telescope/telescope.nvim')

-- formating
Plug('neovim/nvim-lspconfig')
Plug('jose-elias-alvarez/null-ls.nvim')
Plug('MunifTanjim/prettier.nvim')

-- idk
Plug('hrsh7th/vim-vsnip')

-- fuzzy finding
Plug('junegunn/fzf', {['do'] = vim.fn['fzf#install']})
Plug('junegunn/fzf.vim')

-- icons and stuff?
Plug('kyazdani42/nvim-web-devicons')

-- lsp and stuff?
Plug('onsails/lspkind.nvim')
Plug('neovim/nvim-lspconfig')

-- idk
Plug('nvim-lualine/lualine.nvim')
Plug('nvim-treesitter/nvim-treesitter')
Plug('kyazdani42/nvim-tree.lua')

-- syntax jsx
Plug('MaxMEllon/vim-jsx-pretty')

-- themes
Plug('navarasu/onedark.nvim')

-- icons
Plug('kyazdani42/nvim-web-devicons')

-- Git diff
Plug('airblade/vim-gitgutter')

-- which key
Plug('liuchengxu/vim-which-key')

-- comments
Plug('tpope/vim-commentary')

-- jsdoc
Plug('heavenshell/vim-jsdoc')

-- copilot
-- Plug('github/copilot.vim')

vim.call('plug#end')
