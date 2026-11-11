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
    ["yf"] = { "actions.yank_entry", opts = { modify = ":p" }, mode = "n" },
    ["gi"] = {
      mode = "n",
      callback = function()
        local oil = require("oil")
        local entry = oil.get_cursor_entry()
        if not entry then
          return
        end
        local dir = oil.get_current_dir()
        if not dir then
          vim.notify("File info is only available for local directories", vim.log.levels.WARN)
          return
        end
        local output = vim.fn.system({ "stat", dir .. entry.name })
        if vim.v.shell_error ~= 0 then
          vim.notify(output, vim.log.levels.ERROR)
          return
        end
        vim.lsp.util.open_floating_preview(vim.split(vim.trim(output), "\n", { plain = true }), "text", {
          border = "rounded",
          focus = true,
        })
      end,
      desc = "Show file stat",
    },
    ["~"] = "actions.tcd",
  },
})

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
