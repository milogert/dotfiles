local u = require "milogert.utils"

require("persistence").setup {
  -- Defaults are below:
  -- dir = vim.fn.expand(vim.fn.stdpath("config") .. "/sessions/"),
  -- options = { "buffers", "curdir", "tabpages", "winsize" },
}

u.nmap("<leader>sr", '<cmd>lua require("persistence").load()<cr>')
