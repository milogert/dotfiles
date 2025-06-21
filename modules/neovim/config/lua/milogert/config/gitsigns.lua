local u = require("milogert.utils")

local gitsigns = require("gitsigns")

local gitsignsMaps = {
  {
    mode = "n",
    lhs = "]g",
    rhs = function()
      if vim.wo.diff then
        vim.cmd.normal({ "]g", bang = true })
      else
        gitsigns.nav_hunk("next")
      end
    end,
  },
  {
    mode = "n",
    lhs = "[g",
    rhs = function()
      if vim.wo.diff then
        vim.cmd.normal({ "[g", bang = true })
      else
        gitsigns.nav_hunk("prev")
      end
    end,
  },

  -- Popup what's changed in a hunk under cursor
  { mode = "n", lhs = "<Leader>gp", rhs = gitsigns.preview_hunk },

  -- Stage/reset individual hunks under cursor in a file
  { mode = "n", lhs = "<Leader>gs", rhs = gitsigns.stage_hunk },
  { mode = "n", lhs = "<Leader>gr", rhs = gitsigns.reset_hunk },
  {
    mode = "v",
    lhs = "<leader>hs",
    rhs = function()
      gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end,
  },
  {
    mode = "v",
    lhs = "<leader>hr",
    rhs = function()
      gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end,
  },
  { mode = "n", lhs = "<Leader>gu", rhs = gitsigns.undo_stage_hunk },

  -- Stage/reset all hunks in a file
  { mode = "n", lhs = "<Leader>gS", rhs = gitsigns.stage_buffer },
  { mode = "n", lhs = "<Leader>gU", rhs = gitsigns.reset_buffer_index },
  { mode = "n", lhs = "<Leader>gR", rhs = gitsigns.reset_buffer },

  -- Open git status in interative window (similar to lazygit)
  { mode = "n", lhs = "<Leader>gg", rhs = ":Git<cr>" },

  -- Show `git status output`
  -- { mode = 'n', lhs = '<Leader>gs', rhs = ':Git status<CR>' },

  -- Open commit window (creates commit after writing and saving commit msg)
  { mode = "n", lhs = "<Leader>gc", rhs = ":Git commit | startinsert<cr>" },

  -- Other tools from fugitive
  { mode = "n", lhs = "<Leader>gd", rhs = ":Git difftool<cr>" },
  { mode = "n", lhs = "<Leader>gm", rhs = ":Git mergetool<cr>" },
  { mode = "n", lhs = "<Leader>g|", rhs = ":G vdiffsplit<cr>" },
  { mode = "n", lhs = "<Leader>g_", rhs = ":G diffsplit<cr>" },
}

gitsigns.setup({
  preview_config = {
    -- Options passed to nvim_open_win
    border = "rounded",
    style = "minimal",
    relative = "cursor",
    row = 1,
    col = 0,
  },

  on_attach = function(bufnr)
    for _, mapping in ipairs(gitsignsMaps) do
      local opts = mapping.opts or {}
      opts.buffer = bufnr
      u._map(mapping.mode, mapping.lhs, mapping.rhs, opts)
    end
  end,
})
