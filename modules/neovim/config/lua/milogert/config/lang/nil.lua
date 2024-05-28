local variables = require("milogert.variables")
local lspconfig = require("lspconfig")
local lsp_utils = require("milogert.config.lsp.utils")

lspconfig.nil_ls.setup(vim.tbl_extend("keep", {
  cmd = variables.get().ls_cmds.nil_ls,
}, lsp_utils.server_defaults))
