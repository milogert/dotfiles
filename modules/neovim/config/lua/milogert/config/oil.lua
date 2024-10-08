require("oil").setup({
  win_options = {
    -- wrap = false,
    signcolumn = "yes",
    -- cursorcolumn = false,
    -- foldcolumn = "0",
    -- spell = false,
    -- list = false,
    -- conceallevel = 3,
    -- concealcursor = "nvic",
  },
  view_options = {
    show_hidden = true,
  },
  skip_confirm_for_simple_edits = false,

  keymaps = {
    ["-"] = "actions.parent",
    ["<C-c>"] = "actions.close",
    ["<C-h>"] = false,
    ["<C-l>"] = false,
    ["<C-o>"] = "actions.preview",
    ["<C-p>"] = false,
    ["<C-r>"] = "actions.refresh",
    ["<C-s>"] = "actions.select_split",
    ["<C-t>"] = "actions.select_tab",
    ["<C-v>"] = "actions.select_vsplit",
    ["<CR>"] = "actions.select",
    ["_"] = "actions.open_cwd",
    ["`"] = "actions.cd",
    ["g."] = "actions.toggle_hidden",
    ["g?"] = "actions.show_help",
    ["g\\"] = "actions.toggle_trash",
    ["gs"] = "actions.change_sort",
    ["gx"] = "actions.open_external",
    ["~"] = "actions.tcd",
  },
})

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
