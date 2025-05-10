return {
  "mbbill/undotree",
  lazy = false,
  config = function()
    vim.cmd [[
        let g:undotree_WindowLayout=2
            let g:undotree_DiffpanelHeight=8

            if has("persistent_undo")
                let target_path = expand('~/.undodir')

                " create the directory and any parent directories
                " if the location does not exist.
                if !isdirectory(target_path)
                    call mkdir(target_path, "p", 0700)
                endif

                let &undodir=target_path
                set undofile
            endif
        ]]

    vim.keymap.set('n', '<leader>tu', vim.cmd.UndotreeToggle, {})
  end,
}
