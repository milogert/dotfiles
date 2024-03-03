local variables = require('milogert.variables')
local lsp_utils = require('milogert.config.lsp.utils')

require("mason-lspconfig").setup {
  ensure_installed = {
    "stylelint_lsp",
    "tailwindcss",
    "cssmodules_ls",
  },
}

local lspconfig = require "lspconfig"

lspconfig.cssls.setup(lsp_utils.default_with_cmd(variables.get().ls_cmds.cssls))
lspconfig.cssmodules_ls.setup(lsp_utils.server_defaults)

lspconfig.stylelint_lsp.setup(vim.tbl_extend("keep", {
  filetypes = {
    "css",
    "less",
    "scss",
    "sugarss",
    "vue",
    "wxss",
    -- "javascript",
    -- "javascriptreact",
    -- "typescript",
    -- "typescriptreact",
  },
  settings = {
    stylelintplus = {
      autoFixOnFormat = true,
      autoFixOnSave = true,
    },
  },
}, lsp_utils.server_defaults))

lspconfig.tailwindcss.setup(vim.tbl_extend("keep", {
  init_options = {
    userLanguages = {
      heex = "html-eex",
    },
  },
}, lsp_utils.server_defaults))
