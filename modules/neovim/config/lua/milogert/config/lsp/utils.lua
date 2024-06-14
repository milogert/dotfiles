local on_attach = require("milogert.config.lsp.on_attach")

local M = {}

local default_capabilities = vim.lsp.protocol.make_client_capabilities()
default_capabilities.textDocument.completion.completionItem.snippetSupport = true
default_capabilities.textDocument.documentColor = true

M.default_capabilities = require("cmp_nvim_lsp").default_capabilities(default_capabilities)

-- local border = {
--   {"╭", "FloatBorder"},
--   {"─", "FloatBorder"},
--   {"╮", "FloatBorder"},
--   {"│", "FloatBorder"},
--   {"╯", "FloatBorder"},
--   {"─", "FloatBorder"},
--   {"╰", "FloatBorder"},
--   {"│", "FloatBorder"},
-- }

-- LSP settings (for overriding per client)
local handlers = {
  ["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover,
    { border = "rounded", width = 81 }
  ),
  ["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    { border = "rounded", width = 81 }
  ),
}

M.server_defaults = {
  handlers = handlers,
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
