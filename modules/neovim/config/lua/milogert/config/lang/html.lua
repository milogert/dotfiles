local variables = require('milogert.variables')

vim.lsp.config('html', {
  cmd = variables.get().ls_cmds.html,
})

vim.lsp.enable({ 'html' })
