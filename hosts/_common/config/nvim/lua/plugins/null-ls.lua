local null_ls = require("null-ls")

null_ls.setup {
  on_attach = require("plugins.lsp.on_attach"),
  sources = {
    null_ls.builtins.code_actions.gitsigns,
    null_ls.builtins.code_actions.statix,
    null_ls.builtins.diagnostics.credo,
    null_ls.builtins.diagnostics.statix,
    null_ls.builtins.formatting.json_tool,
    null_ls.builtins.formatting.mix,
    null_ls.builtins.formatting.prettier,
  }
}
