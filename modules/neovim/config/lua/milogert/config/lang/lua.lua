local variables = require('milogert.variables')
local lspconfig = require "lspconfig"
local lsp_utils = require "milogert.config.lsp.utils"

lspconfig.lua_ls.setup(vim.tbl_extend("keep", {
  cmd = variables.get().ls_cmds.lua_ls,
  settings = { Lua = { diagnostics = { globals = {
    'vim',
    'love',
    'hs',
  } } } },
}, lsp_utils.server_defaults))
