require("persistence").setup {
  -- Defaults are below:
  -- dir = vim.fn.expand(vim.fn.stdpath("config") .. "/sessions/"),
  -- options = { "buffers", "curdir", "tabpages", "winsize" },
} 

vim.api.nvim_set_keymap("n", "<leader>sr", [[<cmd>lua require("persistence").load()<cr>]], {noremap = true})
