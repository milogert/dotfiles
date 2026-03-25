local u = require("milogert.utils")

local persistence = require("persistence")

persistence.setup({
  -- Defaults are below:
  -- dir = vim.fn.expand(vim.fn.stdpath("config") .. "/sessions/"),
  -- options = { "buffers", "curdir", "tabpages", "winsize" },
  need = 1,
  branch = true, -- use git branch to save session
})

u.nmap("<leader>sr", "", { callback = persistence.load })
