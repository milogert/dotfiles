local u = require("milogert.utils")

local javascript_like = {
  -- "prettierd",
  -- "prettier",
  "eslint_d",
  "eslint",
  -- stop_after_first = true,
}

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },

    -- Conform will run the first available formatter
    javascript = javascript_like,
    javascriptreact = javascript_like,
    typescript = javascript_like,
    typescriptreact = javascript_like,
  },

   default_format_opts = {
    lsp_format = "fallback",
  },
  -- log_level = vim.log.levels.DEBUG,
})

-- buf_set_keymap("n", "<leader>fi", lsp("format({ async = true })"), opts)
-- vim.api.nvim_buf_set_keymap(bufnr, ...)
