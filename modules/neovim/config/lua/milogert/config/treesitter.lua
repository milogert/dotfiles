-- This is just for non-nix-installed parsers.
local parser_path = vim.fn.stdpath("data") .. "/site/parser"
vim.opt.runtimepath:prepend(parser_path)

require'nvim-treesitter.configs'.setup {
  auto_install = true,
  parser_install_dir = parser_path,

  -- Either "all" or a list of languages. List below is from
  -- https://github.com/nvim-treesitter/nvim-treesitter/tree/b4ab9daed1f144200e826a656bd25b013f0949eb
  ensure_installed = {
    -- Non-nix users: list parsers here.
  },

  -- List of parsers to ignore installing
  -- ignore_install = { "ocamllex", "gdscript", "swift" },

  highlight = {
    -- false will disable the whole extension
    enable = true,
    -- list of language that will be disabled
    disable = {},

    -- Setting this to true will run `:h syntax` and tree-sitter at the same
    -- time. Set this to `true` if you depend on 'syntax' being enabled (like
    -- for indentation). Using this option may slow down your editor, and you
    -- may see some duplicate highlights. Instead of true it can also be a list
    -- of languages
    additional_vim_regex_highlighting = false,
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },

  textobjects = {
    enable = true,
  },

  indent = {
    enable = true,
  },
}
