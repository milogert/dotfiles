local on_attach = require("milogert.config.lsp.on_attach")

vim.lsp.config("phpactor", {
  cmd = { "phpactor", "language-server" },
  filetypes = { "php" },
  root_markers = { "composer.json", ".git" },
  on_attach = on_attach,
})

vim.lsp.enable({ "phpactor" })

local dap = require("dap")

dap.adapters.php = {
  type = "executable",
  command = "php-debug-adapter",
}

dap.configurations.php = {
  {
    type = "php",
    request = "launch",
    name = "Listen for Xdebug",
    port = 9003,
  },
  {
    type = "php",
    request = "launch",
    name = "Launch current file",
    program = "${file}",
    cwd = "${fileDirname}",
    port = 9003,
    runtimeExecutable = "php",
  },
}
