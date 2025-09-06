local u = require("milogert.utils")
local variables = require("milogert.variables")

local conform = require("conform")

local javascript_like = {
  -- "prettierd",
  -- "prettier",
  "eslint_d",
  "eslint",
  -- stop_after_first = true,
}

conform.setup({
  default_format_opts = {
    lsp_format = "fallback",
  },
  formatters = {
    pg_format = {
      command = variables.get().formatters.sql[1],
    },
    stylua = {
      command = variables.get().formatters.lua[1],
      append_args = {
        "--indent-type",
        "Spaces",
        "--indent-width",
        "2",
        "--column-width",
        "80",
      },
    },
  },

  formatters_by_ft = {
    sql = { "pg_format" },
    lua = { "stylua" },
    -- Conform will run the first available formatter
    javascript = javascript_like,
    javascriptreact = javascript_like,
    typescript = javascript_like,
    typescriptreact = javascript_like,
  },
  -- log_level = vim.log.levels.DEBUG,
})

-- buf_set_keymap("n", "<leader>fi", lsp("format({ async = true })"), opts)
-- vim.api.nvim_buf_set_keymap(bufnr, ...)

local augroup_conform = vim.api.nvim_create_augroup("conform", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup_conform,
  desc = "Add keyboard shortcut for formatting",
  pattern = "*",
  callback = function()
    u.nmap("<leader>fi", function()
      conform.format()
    end)
  end,
})
