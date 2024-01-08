local variables = require('milogert.variables')
local lspconfig = require "lspconfig"
local lsp_utils = require "milogert.config.lsp.utils"
local on_attach = require "milogert.config.lsp.on_attach"

lspconfig.jsonls.setup(lsp_utils.default_with_cmd(variables.get().ls_cmds.jsonls))

lspconfig.eslint.setup(vim.tbl_extend("keep", {
  cmd = variables.get().ls_cmds.eslint,
  on_attach = function (client, bufnr)
    -- Force eslint to accept formatting requests.
    client.server_capabilities.document_formatting = true
    client.server_capabilities.document_range_formatting = false

    on_attach(client, bufnr)
  end,
  settings = {
    codeActionOnSave = {
      enable = true,
      mode = "all",
    },
  },
}, lsp_utils.server_defaults))

lspconfig.tsserver.setup(vim.tbl_extend("keep", {
  cmd = variables.get().ls_cmds.tsserver,
  on_attach = function (client, bufnr)
    -- Disable tsserver formatting requsts.
    client.server_capabilities.document_formatting = false
    client.server_capabilities.document_range_formatting = false

    on_attach(client, bufnr)
  end
}, lsp_utils.server_defaults))
