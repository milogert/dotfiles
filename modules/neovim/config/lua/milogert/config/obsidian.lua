require("obsidian").setup({
  workspaces = {
    {
      name = "Personal",
      path = "~/Obsidian/Personal",
    },
  },

  -- Remove this eventually.
  legacy_commands = false,
})

local obsidian_augroup = vim.api.nvim_create_augroup("obsidian", { clear = true })

vim.api.nvim_create_autocmd("User", {
  group = obsidian_augroup,
  pattern = "ObsidianNoteEnter";
  callback = function(ev)
    vim.opt_local.conceallevel = 1
    -- local note = require("obsidian.note").from_buffer(ev.buf)
    --- anything you want to do
  end,
})
