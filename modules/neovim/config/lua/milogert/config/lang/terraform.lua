local variables = require("milogert.variables")
local lspconfig = require("lspconfig")
local lsp_utils = require("milogert.config.lsp.utils")

lspconfig.terraformls.setup(vim.tbl_extend("keep", {
  cmd = variables.get().ls_cmds.terraformls,
}, lsp_utils.server_defaults))
