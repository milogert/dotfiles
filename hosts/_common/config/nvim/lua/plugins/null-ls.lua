local null_ls = require("null-ls")

null_ls.setup {
  sources = {
    null_ls.builtins.code_actions.gitsigns,
    -- null_ls.builtins.diagnostics.deadnix,
    null_ls.builtins.formatting.json_tool,
    null_ls.builtins.formatting.mix,
    null_ls.builtins.formatting.prettier,
  }
}
