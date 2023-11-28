local lspconfig = require "lspconfig"
local lsp_utils = require "milogert.config.lsp.utils"

lspconfig.terraformls.setup(vim.tbl_extend("keep", {
  cmd = vim.g.ls_cmds.terraformls,
}, lsp_utils.server_defaults))
