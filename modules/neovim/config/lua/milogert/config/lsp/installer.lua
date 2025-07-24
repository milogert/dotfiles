vim.diagnostic.config({
  -- virtual_lines = true,
  virtual_text = false,
  signs = true,
  update_in_insert = true,
  underline = true,
  float = {
    border = "rounded",
    focusable = false,
    prefix = " ",
  },
})

-- see LSP diagnostic symbols/signs
vim.fn.sign_define("DiagnosticSignError", { text = "✗", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "⚠", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })
-- vim.fn.sign_define('DiagnosticSignError', { text = '❌', texthl = '', linehl = '', nulhl = '' })
-- vim.fn.sign_define('DiagnosticSignWarn', { text = '🚨', texthl = '', linehl = '', nulhl = '' })
-- vim.fn.sign_define('DiagnosticSignInfo', { text = '👀', texthl = '', linehl = '', nulhl = '' })
-- vim.fn.sign_define('DiagnosticSignHint', { text = '💡', texthl = '', linehl = '', nulhl = '' })

require("lspkind").init({
  mode = "symbol_text",

  -- enables text annotations (default: 'default')
  -- default symbol map can be either 'default' or 'codicons' for codicon
  -- preset (requires vscode-codicons font installed)
  preset = "codicons",

  -- override preset symbols (default: {})
  symbol_map = {
    Text = "",
    Method = "ƒ",
    Function = "",
    Constructor = "",
    Variable = "",
    Class = "",
    Interface = "ﰮ",
    Module = "",
    Property = "",
    Unit = "",
    Value = "",
    Enum = "了",
    Keyword = "",
    Snippet = "﬌",
    Color = "",
    File = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "",
    Supermaven = "",
    supermaven = "",
  },
})

local mason = require("mason")

-- Provide settings first!
mason.setup({
  ui = {
    icons = {
      server_installed = "✓",
      server_pending = "➜",
      server_uninstalled = "✗",
    },
  },

  -- Limit for the maximum amount of servers to be installed at the same time.
  -- Once this limit is reached, any further servers that are requested to be
  -- installed will be put in a queue.
  max_concurrent_installers = 4,
})

-- vim.api.nvim_create_autocmd("LspAttach", {
--   group = vim.api.nvim_create_augroup("UserLspConfig", {}),
--   callback = function(args)
--     local client = vim.lsp.get_client_by_id(args.data.client_id)
--     if client.server_capabilities.inlayHintProvider then
--       vim.lsp.inlay_hint.enable(false, { bufnr = args.buf })
--     end
--   end,
-- })
