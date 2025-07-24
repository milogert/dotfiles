local variables = require("milogert.variables")

vim.lsp.config("lua_ls", {
  cmd = variables.get().ls_cmds.lua_ls,
  settings = {
    Lua = {
      hint = {
        enable = true,
      },
      diagnostics = {
        globals = {
          "vim",
          "love",
          "hs",
        },
      },
    },
  },
})

vim.lsp.enable({ 'lua_ls' })
