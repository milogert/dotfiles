local u = require("milogert.utils")

local dap = require("dap")
local dapui = require("dapui")

u.nmap("<M-k>", dapui.eval)
u.vmap("<M-k>", dapui.eval)
u.nmap("<F7>", dap.toggle_breakpoint)
local breakpoint = function()
  dap.set_breakpoint(vim.fn.input("Condition: "), vim.fn.input("Hit condition: "), vim.fn.input("Log message: "))
end
u.nmap("<F8>", breakpoint)
-- u.nmap("<Leader>ds", "", { callback = dap.run })
u.nmap("<Leader>dr", dap.repl.toggle)
u.nmap("<Leader>dl", dap.run_last)
u.nmap("<Leader>dl", dapui.toggle)
u.nmap("<F4>", dap.terminate)
u.nmap("<S-F4>", dap.disconnect)
u.nmap("<F5>", dap.continue)
u.nmap("<F9>", dapui.toggle)
u.nmap("<F10>", dap.step_over)
u.nmap("<S-F10>", dap.step_back)
u.nmap("<F11>", dap.step_into)
u.nmap("<F12>", dap.step_out)

vim.fn.sign_define("DapBreakpoint", {
  text = "🛑",
  texthl = "",
  linehl = "",
  numhl = "",
})
vim.fn.sign_define("DapLogPoint", {
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
vim.fn.sign_define("DapBreakpointRejected", {
  text = "🙅‍♂️",
  texthl = "",
  linehl = "",
  numhl = "",
})
vim.fn.sign_define("DapBreakpointCondition", {
  text = "🤔",
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
      pause = " <F5>",
      play = " <F5>",
      step_into = " <F11>",
      step_over = " <F10>",
      step_back = " <S-F10>",
      step_out = " <F12>",
      run_last = "",
      terminate = " <F4>",
      disconnect = " <S-F4>",
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
