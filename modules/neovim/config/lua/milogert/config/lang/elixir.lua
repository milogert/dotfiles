local on_attach = require("milogert.config.lsp.on_attach")

vim.lsp.config("expert", {
  cmd = { "expert", "--stdio" },
  root_markers = { "mix.exs", ".git" },
  filetypes = { "elixir", "eelixir", "heex" },
  on_attach = on_attach,
  -- settings = {
  --   elixirLS = {
  --     dialyzerEnabled = true,
  --     fetchDeps = true,
  --   };
  -- };
})

vim.lsp.enable({ "expert" })

local u = require("milogert.utils")

local dap = require("dap")
local dapui = require("dapui")

-- Elixir
-- if variables.get().debuggers.elixir_ls then
--   dap.adapters.mix_task = {
--     type = "executable",
--     -- debugger.bat for windows
--     command = variables.get().debuggers.elixir_ls,
--     args = {},
--   }
--
--   dap.configurations.elixir = {
--     {
--       type = "mix_task",
--       name = "mix test",
--       task = "test",
--       taskArgs = { "--trace" },
--       request = "launch",
--       startApps = true, -- for Phoenix projects
--       projectDir = "${workspaceFolder}",
--       requireFiles = {
--         "test/**/test_helper.exs",
--         "test/**/*_test.exs",
--       },
--     },
--     {
--       type = "mix_task",
--       name = "phx.server",
--       request = "launch",
--       task = "phx.server",
--       projectDir = "${workspaceFolder}",
--       exitAfterTaskReturns = false,
--       debugAutoInterpretAllModules = false,
--       debugInterpretModulesPatterns = { "Errw*" },
--     },
--   }
-- else
--   print("variables.get().debuggers.elixir_ls is not configured")
-- end
