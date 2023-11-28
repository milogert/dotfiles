local u = require "milogert.utils"

local dap = require('dap')
local dapui = require('dapui')

-- Elixir
if vim.g.debuggers.elixir_ls then
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
else
  print('vim.g.debuggers.elixir_ls is not configured')
end

if vim.g.debuggers.vscode_js then
  require("dap-vscode-js").setup({
    -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
    -- debugger_path = "(runtimedir)/site/pack/packer/opt/vscode-js-debug", -- Path to vscode-js-debug installation.
    debugger_path = vim.g.debuggers.vscode_js.debugger,
    -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
    adapters = {
      'pwa-node',
      'pwa-chrome',
      'pwa-msedge',
      'node-terminal',
      'pwa-extensionHost',
      'node',
      'chrome'
    }, -- which adapters to register in nvim-dap
    -- log_file_path = "/Users/milo/.cache/nvim/dap_vscode_js.log", -- Path for file logging
    log_file_level = false, -- Logging level for output to file. Set to false to disable file logging.
    log_console_level = vim.log.levels.ERROR, -- Logging level for output to console. Set to false to disable console output.
  })

  local js_languages = { "typescript", "javascript", "javascriptreact", "typescriptreact" }

  for _, language in ipairs(js_languages) do
    dap.configurations[language] = {
      -- Single node files
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch file (neovim)",
        program = "${file}",
        cwd = "${workspaceFolder}",
      },
      -- Processes
      {
        type = "pwa-node",
        request = "attach",
        name = "Attach (neovim)",
        processId = require 'dap.utils'.pick_process,
        cwd = "${workspaceFolder}",
      },
      -- Web apps
      {
        type = "pwa-chrome",
        request = "launch",
        name = "Start Chrome with \"localhost\"",
        url = "http://localhost:3000",
        webRoot = "${workspaceFolder}",
        userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir"
      }
    }
  end
else
  print('vim.g.debuggers.vscode_js is not configured')
end

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

dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open({})
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close({})
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close({})
end

u.nmap("<F9>", "", { callback = dapui.toggle })

require('dap.ext.vscode').load_launchjs(nil,
  {
    ['pwa-node'] = js_languages,
    ['node'] = js_languages,
    ['chrome'] = js_languages,
    ['pwa-chrome'] = js_languages,
  }
)
