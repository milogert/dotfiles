local on_attach = require "milogert.config.lsp.on_attach"

local M = {}

local default_capabilities = vim.lsp.protocol.make_client_capabilities()
default_capabilities.textDocument.completion.completionItem.snippetSupport = true

M.default_capabilities = require("cmp_nvim_lsp").default_capabilities(default_capabilities)

M.server_defaults = {
  capabilities = M.default_capabilities,
  flags = { debounce_text_changes = 150 },
  on_attach = on_attach,
}

M.default_with_cmd = function(cmd)
  return vim.tbl_extend("keep", {
    cmd = cmd,
  }, M.server_defaults)
end

return M
