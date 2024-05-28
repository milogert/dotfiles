local u = require("milogert.utils")

local persistence = require("persistence")

persistence.setup({
  -- Defaults are below:
  -- dir = vim.fn.expand(vim.fn.stdpath("config") .. "/sessions/"),
  -- options = { "buffers", "curdir", "tabpages", "winsize" },
})

u.nmap("<leader>sr", "", { callback = persistence.load })
