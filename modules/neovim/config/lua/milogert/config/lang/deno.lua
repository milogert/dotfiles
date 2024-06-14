local variables = require("milogert.variables")
local lspconfig = require("lspconfig")
local lsp_utils = require("milogert.config.lsp.utils")
local on_attach = require("milogert.config.lsp.on_attach")

lspconfig.denols.setup(vim.tbl_extend("keep", {
  cmd = variables.get().ls_cmds.denols,
  on_attach = on_attach,
  root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
}, lsp_utils.server_defaults))
