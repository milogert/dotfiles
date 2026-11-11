local Hydra = require("hydra")

local dap = require("dap")

Hydra({
  -- string? only used in auto-generated hint
  name = "dap",

  -- string | string[] modes where the hydra exists, same as `vim.keymap.set()` accepts
  mode = "n",

  -- string? key required to activate the hydra, when excluded, you can use
  -- Hydra:activate()
  -- body = "<F5>",
  body = "<leader>o",

  -- these are explained below
  hint = "debug mode",
  -- config = { ... },
  heads = {
    { "h", dap.step_out, {}, },
    { "j", dap.step_over, {}, },
    { "k", dap.step_back, {}, },
    { "l", dap.step_into, {}, },
    { "Z", dap.terminate, {}, },
    { "<space>", dap.continue, {}, },
  },
})
