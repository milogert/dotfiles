local u = require("milogert.utils")

local dap = require("dap")
local dapui = require("dapui")

u.nmap("<M-k>", "", { callback = dapui.eval })
u.vmap("<M-k>", "", { callback = dapui.eval })
u.nmap("<Leader>db", "", { callback = dap.toggle_breakpoint })
u.nmap("<Leader>dB", "", {
  callback = function()
    dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
  end,
})
-- u.nmap("<Leader>ds", "", { callback = dap.run })
u.nmap("<Leader>dr", "", { callback = dap.repl.toggle })
u.nmap("<Leader>dl", "", { callback = dap.run_last })
u.nmap("<Leader>dl", "", { callback = dapui.toggle })
u.nmap("<F4>", "", { callback = dap.terminate })
u.nmap("<F5>", "", { callback = dap.continue })
u.nmap("<F9>", "", { callback = dapui.toggle })
u.nmap("<F10>", "", { callback = dap.step_over })
u.nmap("<F11>", "", { callback = dap.step_into })
u.nmap("<F12>", "", { callback = dap.step_out })

vim.fn.sign_define("DapBreakpoint", {
  text = "🛑",
  texthl = "",
  linehl = "",
  numhl = "",
})
vim.fn.sign_define("DapLogpoint", {
  text = "🪵",
  texthl = "",
  linehl = "",
  numhl = "",
})
vim.fn.sign_define("DapStopped", {
  text = "👉",
  texthl = "",
  linehl = "",
  numhl = "",
})

local repl = require("dap.repl")
repl.commands = vim.tbl_extend("force", repl.commands, {
  -- Add a new alias for the existing .exit command
  exit = { "exit", ".exit", ".bye", ".goobye" },
  -- Add your own commands; run `.echo hello world` to invoke
  -- this function with the text "hello world"
  custom_commands = {
    [".echo"] = function(text)
      dap.repl.append(text)
    end,
    -- Hook up a new command to an existing dap function
    [".restart"] = dap.restart,
  },
})

dapui.setup({
  controls = {
    icons = {
      pause = " (F5)",
      play = " (F5)",
      step_into = " (F11)",
      step_over = " (F10)",
      step_out = " (F12)",
      step_back = "",
      run_last = "",
      terminate = " (F4)",
      disconnect = "",
    },
  },
})

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open({})
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close({})
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close({})
end
