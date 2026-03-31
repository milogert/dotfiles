-- This is just for non-nix-installed parsers.
local parser_path = vim.fn.stdpath("data") .. "/site/parser"
vim.opt.runtimepath:prepend(parser_path)

require("nvim-treesitter").setup({
  -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
  install_dir = vim.fn.stdpath("data") .. "/site",
  highlight = { enabled = true, },
})

-- Either "all" or a list of languages. List below is from
-- https://github.com/nvim-treesitter/nvim-treesitter/tree/b4ab9daed1f144200e826a656bd25b013f0949eb
require("nvim-treesitter").install({
  -- Non-nix users: list parsers here.
})
