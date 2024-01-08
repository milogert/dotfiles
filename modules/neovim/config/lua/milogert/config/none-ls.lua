local null_ls = require("null-ls")

null_ls.setup({
  on_attach = require("milogert.config.lsp.on_attach"),

  sources = {
    null_ls.builtins.code_actions.eslint.with({
      prefer_local = "node_modules/.bin",
    }),
    null_ls.builtins.code_actions.gitsigns,
    null_ls.builtins.code_actions.statix,

    null_ls.builtins.diagnostics.credo,
    null_ls.builtins.diagnostics.eslint.with({
      prefer_local = "node_modules/.bin",
    }),
    null_ls.builtins.diagnostics.statix,

    null_ls.builtins.formatting.eslint.with({
      prefer_local = "node_modules/.bin",
    }),
    null_ls.builtins.formatting.json_tool,
    null_ls.builtins.formatting.mix,
    null_ls.builtins.formatting.prettier.with({
      prefer_local = "node_modules/.bin",
    }),
    null_ls.builtins.formatting.stylua.with({
      command = vim.g.ls_cmds.stylua[1],
    }),
  },
})
