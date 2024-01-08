-- Defines a read-write directory for treesitters in nvim's cache dir
local ts_parser_path = vim.fn.stdpath("data") .. "/site"
vim.opt.runtimepath:prepend(ts_parser_path .. "/parser")

require'nvim-treesitter.configs'.setup {
  auto_install = true,
  parser_install_dir = ts_parser_path,

  -- Either "all" or a list of languages. List below is from
  -- https://github.com/nvim-treesitter/nvim-treesitter/tree/b4ab9daed1f144200e826a656bd25b013f0949eb
  ensure_installed = {
    "bash", -- (maintained)
    "comment", -- (maintained)
    "css", -- (maintained)
    "dockerfile", -- (maintained)
    "eex", -- (maintained)
    "elixir", -- (maintained)
    "elm", -- (NOT maintained, 2022-04-28)
    "erlang", -- (maintained)
    "fennel", -- (maintained)
    "go", -- (maintained)
    "graphql", -- (maintained)
    "haskell", -- (NOT maintained, 2022-04-28)
    "hcl", -- (maintained)
    "heex", -- (maintained)
    "help", -- (experimental, maintained)
    "hjson", -- (maintained)
    "html", -- (maintained)
    "http", -- (maintained)
    "java", -- (maintained)
    "javascript", -- (maintained)
    "jsdoc", -- (maintained)
    "jsonc", -- (maintained)
    "kotlin", -- (maintained)
    "latex", -- (maintained)
    "llvm", -- (maintained)
    "lua", -- (maintained)
    "make", -- (maintained)
    "markdown", -- (NOT maintained, 2022-04-28)
    "nix", -- (maintained)
    "perl", -- (maintained)
    "php", -- (maintained)
    "pug", -- (maintained)
    "python", -- (maintained)
    "ql", -- (maintained)
    "query", -- Tree-sitter query language (maintained)
    "r", -- (maintained)
    "regex", -- (maintained)
    "rust", -- (maintained)
    "scss", -- (maintained)
    "todotxt", -- (experimental, maintained)
    "toml", -- (maintained)
    "tsx", -- (maintained)
    "typescript", -- (maintained)
    "vim", -- (maintained)
    "vue", -- (maintained)
    "yaml", -- (maintained)
    -- "Godot", -- Resources (gdresource) (maintained)
    -- "astro", -- (maintained)
    -- "beancount", -- (maintained)
    -- "bibtex", -- (maintained)
    -- "c", -- (maintained)
    -- "c_sharp", -- (maintained)
    -- "clojure", -- (maintained)
    -- "cmake", -- (maintained)
    -- "commonlisp", -- (maintained)
    -- "cooklang", -- (maintained)
    -- "cpp", -- (maintained)
    -- "cuda", -- (maintained)
    -- "d", -- (experimental, maintained)
    -- "dart", -- (maintained)
    -- "devicetree", -- (maintained)
    -- "dot", -- (maintained)
    -- "elvish", -- (maintained)
    -- "fish", -- (maintained)
    -- "foam", -- (experimental, maintained)
    -- "fortran", -- (NOT maintained, 2022-04-28)
    -- "fusion", -- (maintained)
    -- "gleam", -- (maintained)
    -- "glimmer", -- Glimmer and Ember (maintained)
    -- "glsl", -- (maintained)
    -- "godot_resources", -- Godot Resources (gdscript) (maintained)
    -- "gomod", -- (maintained)
    -- "gowork", -- (maintained)
    -- "hack", -- (NOT maintained, 2022-04-28)
    -- "hocon", -- (maintained)
    -- "json", -- (maintained)
    -- "json5", -- (maintained)
    -- "julia", -- (maintained)
    -- "lalrpop", -- (maintained)
    -- "ledger", -- (maintained)
    -- "m68k", -- (maintained)
    -- "ninja", -- (maintained)
    -- "norg", -- (maintained)
    -- "ocaml", -- (maintained)
    -- "ocaml_interface", -- (maintained)
    -- "ocamllex", -- (maintained)
    -- "org", -- (NOT maintained, 2022-04-28)
    -- "pascal", -- (maintained)
    -- "phpdoc", -- (experimental, maintained), NOTE: causes problems 2022-04-28.
    -- "pioasm", -- (maintained)
    -- "prisma", -- (maintained)
    -- "proto", -- (maintained)
    -- "rasi", -- (maintained)
    -- "rego", -- (maintained)
    -- "rst", -- (maintained)
    -- "ruby", -- (maintained)
    -- "scala", -- (maintained)
    -- "scheme", -- (maintained)
    -- "slint", -- (experimental, maintained)
    -- "solidity", -- (maintained)
    -- "sparql", -- (maintained)
    -- "supercollider", -- (maintained)
    -- "surface", -- (maintained)
    -- "svelte", -- (maintained)
    -- "swift", -- (NOT maintained, 2022-04-28)
    -- "teal", -- (maintained)
    -- "tlaplus", -- (maintained)
    -- "turtle", -- (maintained)
    -- "vala", -- (maintained)
    -- "verilog", -- (experimental, maintained)
    -- "wgsl", -- (maintained)
    -- "yang", -- (maintained)
    -- "zig", -- (maintained)
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
