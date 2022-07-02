local dap = require('dap')

-- Elixir
dap.adapters.mix_task = {
  type = 'executable',
  -- debugger.bat for windows
  command = vim.g.elixir_ls_server_path .. '/debugger.sh',
  args = {}
}
dap.configurations.elixir = {
  {
    type = "mix_task",
    name = "mix test",
    task = 'test',
    taskArgs = {"--trace"},
    request = "launch",
    startApps = true, -- for Phoenix projects
    projectDir = "${workspaceFolder}",
    requireFiles = {
      "test/**/test_helper.exs",
      "test/**/*_test.exs"
    }
  },
}

