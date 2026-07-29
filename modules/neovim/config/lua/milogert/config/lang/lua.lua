local variables = require("milogert.variables")
local on_attach = require("milogert.config.lsp.on_attach")

vim.lsp.config("lua_ls", {
  cmd = variables.get().ls_cmds.lua_ls,
  on_attach = function(client, bufnr)
    client.server_capabilities.document_formatting = true
    on_attach(client, bufnr)
  end,
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
