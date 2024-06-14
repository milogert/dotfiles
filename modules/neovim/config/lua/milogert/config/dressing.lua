require("dressing").setup({
  input = {
    backend = { "fzf_lua" },
  },
  select = {
    -- Set to false to disable the vim.ui.select implementation
    enabled = false,

    -- -- Priority list of preferred vim.select implementations
    -- backend = {"fzf_lua"},
    --
    -- -- Trim trailing `:` from prompt
    -- trim_prompt = true,
    --
    -- -- Options for telescope selector
    -- -- These are passed into the telescope picker directly. Can be used like:
    -- -- telescope = require('telescope.themes').get_ivy({...})
    -- -- telescope = nil,
    --
    -- -- -- Options for fzf selector
    -- -- fzf = {
    -- --   window = {
    -- --     width = 0.5,
    -- --     height = 0.4,
    -- --   },
    -- -- },
    --
    -- -- Options for fzf-lua
    -- fzf_lua = {
    --   winopts = {
    --     height = 20,
    --     width = 70
    --   },
    -- },
  },
})
