local variables = require("milogert.variables")

-- vim.lsp.config('rnix', {
--   cmd = variables.get().ls_cmds.rnix,
-- })

vim.lsp.config("nil_ls", {
  cmd = variables.get().ls_cmds.nil_ls,
})

vim.lsp.enable({ 'nil_ls' })
