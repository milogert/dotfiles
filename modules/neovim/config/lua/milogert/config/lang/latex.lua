local variables = require('milogert.variables')

vim.lsp.config('texlab', {
  cmd = variables.get().ls_cmds.texlab,
})

vim.lsp.enable({ 'texlab' })
