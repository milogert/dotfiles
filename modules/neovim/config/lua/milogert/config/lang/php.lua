local on_attach = require("milogert.config.lsp.on_attach")

vim.lsp.config("phpactor", {
  cmd = { "phpactor", "language-server" },
  filetypes = { "php" },
  root_markers = { "composer.json", ".git" },
  on_attach = on_attach,
})

vim.lsp.enable({ "phpactor" })
