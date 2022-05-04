vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  update_in_insert = true,
  underline = true,
  float = {
    border = 'rounded',
    focusable = false,
    prefix = ' ',
  },
})

-- see LSP diagnostic symbols/signs
vim.fn.sign_define(
  "DiagnosticSignError", {text = "✗", texthl = "DiagnosticSignError" }
)
vim.fn.sign_define(
  "DiagnosticSignWarn", { text = "⚠", texthl = "DiagnosticSignWarn" }
)
vim.fn.sign_define(
  "DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" }
)
vim.fn.sign_define(
  "DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" }
)
