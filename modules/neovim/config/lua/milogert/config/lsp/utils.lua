local on_attach = require("milogert.config.lsp.on_attach")

-- Default settings for all server.
vim.lsp.config("*", {
  root_markers = { ".git" },
  -- root_markers = { "package.json", "mix.exs" },
  capabilities = require('blink.cmp').get_lsp_capabilities({
    textDocument = {
      -- semanticTokens = {
      --   multilineTokenSupport = true,
      -- },
      completion = {
        completionItem = {
          snippetSupport = true,
        },
      },
      documentColor = true,
      hover = true,
    },
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
  }),
  handlers = {
    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded", width = 81 }),
    ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded", width = 81 }),
  },
  -- flags = { debounce_text_changes = 150 },
  on_attach = on_attach,
})

local default_capabilities = vim.lsp.protocol.make_client_capabilities()
default_capabilities.textDocument.completion.completionItem.snippetSupport = true
default_capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
default_capabilities.textDocument.documentColor = true

-- M.default_capabilities = require("cmp_nvim_lsp").default_capabilities(default_capabilities)

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
