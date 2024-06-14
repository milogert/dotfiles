local variables = require("milogert.variables")
local lspconfig = require("lspconfig")
local lsp_utils = require("milogert.config.lsp.utils")
-- local elixir = require("elixir")
-- local elixirls = require("elixir.elixirls")
-- local on_attach = require("milogert.config.lsp.on_attach")

lspconfig.elixirls.setup(vim.tbl_extend("keep", {
  cmd = variables.get().ls_cmds.elixirls,
}, lsp_utils.server_defaults))

-- elixir.setup {
--   nextls = {enable = true},
--   credo = {},
--   elixirls = {
--     enable = true,
--     -- settings = elixirls.settings {
--     --   dialyzerEnabled = false,
--     --   enableTestLenses = false,
--     -- },
--     cmd = variables.get().ls_cmds.elixirls,
--     on_attach = function(client, bufnr)
--       vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
--       vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
--       vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
--
--       on_attach(client, bufnr)
--     end,
--   }
-- }

local u = require("milogert.utils")

local dap = require("dap")
local dapui = require("dapui")

-- Elixir
if variables.get().debuggers.elixir_ls then
  dap.adapters.mix_task = {
    type = "executable",
    -- debugger.bat for windows
    command = variables.get().debuggers.elixir_ls,
    args = {},
  }

  dap.configurations.elixir = {
    {
      type = "mix_task",
      name = "mix test",
      task = "test",
      taskArgs = { "--trace" },
      request = "launch",
      startApps = true, -- for Phoenix projects
      projectDir = "${workspaceFolder}",
      requireFiles = {
        "test/**/test_helper.exs",
        "test/**/*_test.exs",
      },
    },
    {
      type = "mix_task",
      name = "phx.server",
      request = "launch",
      task = "phx.server",
      projectDir = "${workspaceFolder}",
      exitAfterTaskReturns = false,
      debugAutoInterpretAllModules = false,
      debugInterpretModulesPatterns = { "Errw*" },
    },
  }
else
  print("variables.get().debuggers.elixir_ls is not configured")
end
