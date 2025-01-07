local typescript = require("hacksore.test.typescript")

-- do a typescript test
typescript.run()

-- local home = vim.fn.getenv("HOME")
-- local ts_dir = home .. "/.config/nvim/lua/hacksore/test/__mock__"
--
-- vim.cmd("e " .. ts_dir .. "/typescript.broken.ts")
--
-- -- NOTE: how do we do this in a function like we have with typescript.run()?
-- vim.api.nvim_create_autocmd("LspAttach", {
--   callback = function(args)
--     local client = vim.lsp.get_client_by_id(args.data.client_id)
--
--     if not client then
--       return
--     end
--
--     if client.name == "ts_ls" then
--       print("Loaded ts_ls")
--       local test = vim.diagnostic.get(0)
--       -- check that it has somethign in the table
--       if test then
--         print("Got diagnostics")
--         print(vim.inspect(test))
--       end
--
--     end
--   end,
-- })
