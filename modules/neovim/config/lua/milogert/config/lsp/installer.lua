local mason = require("mason")

-- Provide settings first!
mason.setup {
  ui = {
    icons = {
      server_installed = "✓",
      server_pending = "➜",
      server_uninstalled = "✗",
    },
  },

  -- Limit for the maximum amount of servers to be installed at the same time.
  -- Once this limit is reached, any further servers that are requested to be
  -- installed will be put in a queue.
  max_concurrent_installers = 4,
}

require("mason-lspconfig").setup {
  ensure_installed = {
    "cssls",
    "eslint",
    "html",
    "jsonls",
    "stylelint_lsp",
    "tailwindcss",
    "cssmodules_ls",
  },
}


local on_attach = require "milogert.config.lsp.on_attach"
local lspconfig = require "lspconfig"

local default_capabilities = vim.lsp.protocol.make_client_capabilities()
default_capabilities.textDocument.completion.completionItem.snippetSupport = true
default_capabilities = require("cmp_nvim_lsp").default_capabilities(default_capabilities)

local server_defaults = {
  capabilities = default_capabilities,
  flags = { debounce_text_changes = 150 },
  on_attach = on_attach,
}

-- These servers are easy, they don't need any special config
lspconfig.cssls.setup(server_defaults)
lspconfig.cssmodules_ls.setup(server_defaults)
lspconfig.html.setup(server_defaults)
lspconfig.jsonls.setup(server_defaults)

--
-- lspconfig.denols.setup(vim.tbl_extend("keep", {
--   cmd = vim.g.ls_locations.denols,
--   on_attach = function (client, bufnr)
--     vim.g.markdown_fenced_languages = {
--       "ts=typescript"
--     }
--
--     on_attach(client, bufnr)
--   end
-- }, server_defaults))

lspconfig.terraformls.setup(vim.tbl_extend("keep", {
  cmd = vim.g.ls_locations.terraformls,
}, server_defaults))

lspconfig.elixirls.setup(vim.tbl_extend("keep", {
  cmd = vim.g.ls_locations.elixirls,
}, server_defaults))

lspconfig.eslint.setup(vim.tbl_extend("keep", {
  on_attach = function (client, bufnr)
    -- Force eslint to accept formatting requests.
    client.server_capabilities.document_formatting = true
    client.server_capabilities.document_range_formatting = false

    on_attach(client, bufnr)
  end,
  settings = {
    codeActionOnSave = {
      enable = true,
      mode = "all",
    },
  },
}, server_defaults))

lspconfig.nil_ls.setup(vim.tbl_extend("keep", {
  cmd = vim.g.ls_locations.nil_ls,
}, server_defaults))

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
}, server_defaults))

lspconfig.lua_ls.setup(vim.tbl_extend("keep", {
  cmd = vim.g.ls_locations.lua_ls,
  settings = { Lua = { diagnostics = { globals = {
    'vim',
    'love',
    'hs',
  } } } },
}, server_defaults))

lspconfig.tailwindcss.setup(vim.tbl_extend("keep", {
  init_options = {
    userLanguages = {
      heex = "html-eex",
    },
  },
}, server_defaults))

lspconfig.tsserver.setup(vim.tbl_extend("keep", {
  cmd = vim.g.ls_locations.tsserver,
  on_attach = function (client, bufnr)
    -- Disable tsserver formatting requsts.
    client.server_capabilities.document_formatting = false
    client.server_capabilities.document_range_formatting = false

    on_attach(client, bufnr)
  end
}, server_defaults))
