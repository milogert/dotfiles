local elixir = require("elixir")
local elixirls = require("elixir.elixirls")
local on_attach = require("milogert.config.lsp.on_attach")

elixir.setup {
  nextls = {enable = true},
  credo = {},
  elixirls = {
    enable = true,
    -- settings = elixirls.settings {
    --   dialyzerEnabled = false,
    --   enableTestLenses = false,
    -- },
    cmd = vim.g.ls_cmds.elixirls,
    on_attach = function(client, bufnr)
      vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
      vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
      vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })

      on_attach(client, bufnr)
    end,
  }
}

-- lspconfig.elixirls.setup(vim.tbl_extend("keep", {
--   cmd = vim.g.ls_cmds.elixirls,
-- }, server_defaults))

