-- vim.lsp.set_log_level("debug")

-- lsp-config -----------------------------------------------------------------
-- options for lsp diagnostic
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    update_in_insert = true,
    underline = true,
    signs = true,
    virtual_text = {
      true,
      spacing = 6,
      -- severity_limit = 'Error',
    },
  }
)

-- see LSP diagnostic symbols/signs
vim.api.nvim_command [[ sign define LspDiagnosticsSignError         text=✗ texthl=LspDiagnosticsSignError       linehl= numhl= ]]
vim.api.nvim_command [[ sign define LspDiagnosticsSignWarning       text=⚠ texthl=LspDiagnosticsSignWarning     linehl= numhl= ]]
vim.api.nvim_command [[ sign define LspDiagnosticsSignInformation   text= texthl=LspDiagnosticsSignInformation linehl= numhl= ]]
vim.api.nvim_command [[ sign define LspDiagnosticsSignHint          text= texthl=LspDiagnosticsSignHint        linehl= numhl= ]]

-- Use an on_attach function to only map the following keys
-- after the language server attachs to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  local function diag(cmd) return '<cmd>lua vim.lsp.diagnostic.' .. cmd .. '()<CR>' end
  local function buf(cmd) return '<cmd>lua vim.lsp.buf.' .. cmd .. '()<CR>' end

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', '<space>e',  diag('show_line_diagnostics'), opts)
  buf_set_keymap('n', '[d',        diag('goto_prev'),             opts)
  buf_set_keymap('n', ']d',        diag('goto_next'),             opts)
  buf_set_keymap('n', '<space>q',  diag('set_loclist'),           opts)

  buf_set_keymap('n', 'gD',        buf('declaration'),            opts)
  buf_set_keymap('n', 'gd',        buf('definition'),             opts)
  buf_set_keymap('n', 'K',         buf('hover'),                  opts)
  buf_set_keymap('n', 'gi',        buf('implementation'),         opts)
  buf_set_keymap('n', '[ls',       buf('signature_help'),         opts)
  buf_set_keymap('n', '<space>D',  buf('type_definition'),        opts)
  buf_set_keymap('n', '<space>rn', buf('rename'),                 opts)
  buf_set_keymap('n', 'gr',        buf('references'),             opts)
  buf_set_keymap('n', '<space>f',  buf('formatting'),             opts)

end

-- lspkind --------------------------------------------------------------------
require('lspkind').init({
  -- enables text annotations (default: true)
  with_text = true,

  -- enables text annotations (default: 'default')
  -- default symbol map can be either 'default' or 'codicons' for codicon
  -- preset (requires vscode-codicons font installed)
  preset = 'codicons',

  -- override preset symbols (default: {})
  symbol_map = {
    Text = '',
    Method = 'ƒ',
    Function = '',
    Constructor = '',
    Variable = '',
    Class = '',
    Interface = 'ﰮ',
    Module = '',
    Property = '',
    Unit = '',
    Value = '',
    Enum = '了',
    Keyword = '',
    Snippet = '﬌',
    Color = '',
    File = '',
    Folder = '',
    EnumMember = '',
    Constant = '',
    Struct = ''
  },
})


-- lsp-status -----------------------------------------------------------------
require('lsp-status').status()
require('lsp-status').register_progress()
require('lsp-status').config({
  indicator_errors = '✗',
  indicator_warnings = '⚠',
  indicator_info = '',
  indicator_hint = '',
  indicator_ok = '✔',
  current_function = true,
  diagnostics = false,
  select_symbol = nil,
  update_interval = 100,
  status_symbol = ' 🇻',
})


-- nvim-lsp-installer ---------------------------------------------------------
local lsp_installer = require("nvim-lsp-installer")

-- Provide settings first!
lsp_installer.settings {
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

lsp_installer.on_server_ready(function(server)
  -- Add additional capabilities supported by nvim-cmp
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

  local opts = {
    capabilities = capabilities,
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
  }

  if server.name == "elixirls" then
    opts.cmd = { server.root_dir .. "/elixir-ls/language_server.sh" }
  end

  if server.name == 'sumneko_lua' then
    opts.settings = {
      Lua = {
        diagnostics = {
          globals = { 'vim' }
        }
      }
    }
  end

  -- This setup() function is exactly the same as lspconfig's setup function
  -- (:help lspconfig-quickstart)
  server:setup(opts)
end)

local function install_server(server)
  local lsp_installer_servers = require'nvim-lsp-installer.servers'
  local ok, server_analyzer = lsp_installer_servers.get_server(server)
  if ok then
    if not server_analyzer:is_installed() then
      server_analyzer:install(server)
    end
  end
end

local servers = {
  "elixirls",           -- for elixir
  "eslint",             -- for eslint
  "jsonls",             -- for json
  "sumneko_lua",        -- for lua
  "tailwindcss",        -- for tailwindcss
  "terraformls",        -- for terraform
  "tsserver",           -- for javascript
}


-- setup the LS
require "lspconfig"

-- install the LS
for _, server in ipairs(servers) do
  install_server(server)
end
