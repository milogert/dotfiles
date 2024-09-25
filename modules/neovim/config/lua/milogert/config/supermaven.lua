require("supermaven-nvim").setup({
  -- keymaps = {
  --   accept_suggestion = "<Tab>",
  --   clear_suggestion = "<C-]>",
  --   accept_word = "<C-j>",
  -- },
  -- ignore_filetypes = { cpp = true },
  -- color = {
    -- suggestion_color = "#ffffff",
    -- cterm = 244,
  -- },
  log_level = "info", -- set to "off" to disable logging completely
  disable_inline_completion = true, -- disables inline completion for use with cmp
  disable_keymaps = true -- disables built in keymaps for more manual control
})

vim.api.nvim_set_hl(0, "CmpItemKindSupermaven", {fg ="#519f50"})
