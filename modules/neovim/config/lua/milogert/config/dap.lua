local u = require "milogert.utils"

local dap = require('dap')

-- Elixir
dap.adapters.mix_task = {
  type = 'executable',
  -- debugger.bat for windows
  command = vim.g.debuggers.elixir_ls .. '/lib/debugger.sh',
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

u.nmap("<Leader>db", "", { callback = dap.toggle_breakpoint })
u.nmap("<Leader>dB", "", {
  callback = function ()
    dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
  end
})
-- u.nmap("<Leader>ds", "", { callback = dap.run })
u.nmap("<Leader>dr", "", { callback = dap.repl.toggle })
u.nmap("<Leader>dl", "", { callback = dap.run_last })
u.nmap("<F5>", "", { callback = dap.continue })
u.nmap("<F10>", "", { callback = dap.step_over })
u.nmap("<F11>", "", { callback = dap.step_into })
u.nmap("<F12>", "", { callback = dap.step_out })


local repl = require 'dap.repl'
repl.commands = vim.tbl_extend('force', repl.commands, {
  -- Add a new alias for the existing .exit command
  exit = {'exit', '.exit', '.bye'},
  -- Add your own commands; run `.echo hello world` to invoke
  -- this function with the text "hello world"
  custom_commands = {
    ['.echo'] = function(text)
      dap.repl.append(text)
    end,
    -- Hook up a new command to an existing dap function
    ['.restart'] = dap.restart,
  },
})

