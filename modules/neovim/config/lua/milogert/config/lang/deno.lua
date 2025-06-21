local variables = require("milogert.variables")

vim.lsp.config("denols", {
  cmd = variables.get().ls_cmds.denols,
  root_markers = { "deno.json", "deno.jsonc" },
})

-- vim.lsp.enable({ "denols" })
