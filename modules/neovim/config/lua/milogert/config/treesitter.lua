require'nvim-treesitter.configs'.setup {
  auto_install = true,

  -- Either "all" or a list of languages. List below is from
  -- https://github.com/nvim-treesitter/nvim-treesitter/tree/b4ab9daed1f144200e826a656bd25b013f0949eb
  ensure_installed = {
    -- "astro", -- (maintained)
    "bash", -- (maintained)
    -- "beancount", -- (maintained)
    -- "bibtex", -- (maintained)
    -- "c", -- (maintained)
    -- "c_sharp", -- (maintained)
    -- "clojure", -- (maintained)
    -- "cmake", -- (maintained)
    "comment", -- (maintained)
    -- "commonlisp", -- (maintained)
    -- "cooklang", -- (maintained)
    -- "cpp", -- (maintained)
    "css", -- (maintained)
    -- "cuda", -- (maintained)
    -- "d", -- (experimental, maintained)
    -- "dart", -- (maintained)
    -- "devicetree", -- (maintained)
    "dockerfile", -- (maintained)
    -- "dot", -- (maintained)
    "eex", -- (maintained)
    "elixir", -- (maintained)
    "elm", -- (NOT maintained, 2022-04-28)
    -- "elvish", -- (maintained)
    "erlang", -- (maintained)
    "fennel", -- (maintained)
    -- "fish", -- (maintained)
    -- "foam", -- (experimental, maintained)
    -- "fortran", -- (NOT maintained, 2022-04-28)
    -- "fusion", -- (maintained)
    -- "godot_resources", -- Godot Resources (gdscript) (maintained)
    -- "gleam", -- (maintained)
    -- "glimmer", -- Glimmer and Ember (maintained)
    -- "glsl", -- (maintained)
    "go", -- (maintained)
    -- "Godot", -- Resources (gdresource) (maintained)
    -- "gomod", -- (maintained)
    -- "gowork", -- (maintained)
    "graphql", -- (maintained)
    -- "hack", -- (NOT maintained, 2022-04-28)
    "haskell", -- (NOT maintained, 2022-04-28)
    "hcl", -- (maintained)
    "heex", -- (maintained)
    "help", -- (experimental, maintained)
    "hjson", -- (maintained)
    -- "hocon", -- (maintained)
    "html", -- (maintained)
    "http", -- (maintained)
    "java", -- (maintained)
    "javascript", -- (maintained)
    "jsdoc", -- (maintained)
    -- "json", -- (maintained)
    -- "json5", -- (maintained)
    "jsonc", -- (maintained)
    -- "julia", -- (maintained)
    "kotlin", -- (maintained)
    -- "lalrpop", -- (maintained)
    "latex", -- (maintained)
    -- "ledger", -- (maintained)
    "llvm", -- (maintained)
    "lua", -- (maintained)
    -- "m68k", -- (maintained)
    "make", -- (maintained)
    "markdown", -- (NOT maintained, 2022-04-28)
    -- "ninja", -- (maintained)
    "nix", -- (maintained)
    -- "norg", -- (maintained)
    -- "ocaml", -- (maintained)
    -- "ocaml_interface", -- (maintained)
    -- "ocamllex", -- (maintained)
    -- "org", -- (NOT maintained, 2022-04-28)
    -- "pascal", -- (maintained)
    "perl", -- (maintained)
    "php", -- (maintained)
    -- "phpdoc", -- (experimental, maintained), NOTE: causes problems 2022-04-28.
    -- "pioasm", -- (maintained)
    -- "prisma", -- (maintained)
    -- "proto", -- (maintained)
    "pug", -- (maintained)
    "python", -- (maintained)
    "ql", -- (maintained)
    "query", -- Tree-sitter query language (maintained)
    "r", -- (maintained)
    -- "rasi", -- (maintained)
    "regex", -- (maintained)
    -- "rego", -- (maintained)
    -- "rst", -- (maintained)
    -- "ruby", -- (maintained)
    "rust", -- (maintained)
    -- "scala", -- (maintained)
    -- "scheme", -- (maintained)
    "scss", -- (maintained)
    -- "slint", -- (experimental, maintained)
    -- "solidity", -- (maintained)
    -- "sparql", -- (maintained)
    -- "supercollider", -- (maintained)
    -- "surface", -- (maintained)
    -- "svelte", -- (maintained)
    -- "swift", -- (NOT maintained, 2022-04-28)
    -- "teal", -- (maintained)
    -- "tlaplus", -- (maintained)
    "todotxt", -- (experimental, maintained)
    "toml", -- (maintained)
    "tsx", -- (maintained)
    -- "turtle", -- (maintained)
    "typescript", -- (maintained)
    -- "vala", -- (maintained)
    -- "verilog", -- (experimental, maintained)
    "vim", -- (maintained)
    "vue", -- (maintained)
    -- "wgsl", -- (maintained)
    "yaml", -- (maintained)
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
