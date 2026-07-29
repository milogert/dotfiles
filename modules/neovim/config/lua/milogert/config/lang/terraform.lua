local variables = require("milogert.variables")

vim.lsp.config("terraformls", {
  cmd = variables.get().ls_cmds.terraformls,
})

vim.lsp.enable({ "terraformls" })
