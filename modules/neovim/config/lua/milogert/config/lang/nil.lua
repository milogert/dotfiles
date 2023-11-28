local lspconfig = require "lspconfig"
local lsp_utils = require "milogert.config.lsp.utils"

lspconfig.nil_ls.setup(vim.tbl_extend("keep", {
  cmd = vim.g.ls_cmds.nil_ls,
}, lsp_utils.server_defaults))
