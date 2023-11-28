local lspconfig = require "lspconfig"
local lsp_utils = require "milogert.config.lsp.utils"

lspconfig.html.setup(lsp_utils.default_with_cmd(vim.g.ls_cmds.html))
