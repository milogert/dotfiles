-- vim.lsp.set_log_level("debug")
-- require('vim.lsp.log').set_format_func(vim.inspect)

-- lsp-status -----------------------------------------------------------------
local lsp_status = require('lsp-status')
lsp_status.register_progress()
lsp_status.config({
  indicator_errors = '✗',
  indicator_warnings = '⚠',
  indicator_info = '',
  indicator_hint = '',
  indicator_ok = '✔',
  current_function = false,
  diagnostics = false,
  select_symbol = nil,
  update_interval = 100,
  status_symbol = ' 🔍',
})


-- lsp-config -----------------------------------------------------------------
-- options for lsp diagnostic
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  update_in_insert = true,
  underline = true,
  float = {
    border = 'rounded',
    focusable = false,
    prefix = ' ',
  },
})

-- see LSP diagnostic symbols/signs
vim.fn.sign_define("DiagnosticSignError", {text = "✗", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "⚠", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

-- Use an on_attach function to only map the following keys
-- after the language server attachs to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap = true, silent = true }

  local function diag(cmd) return '<cmd>lua vim.diagnostic.' .. cmd .. '<CR>' end
  local function lsp(cmd) return '<cmd>lua vim.lsp.buf.' .. cmd .. '()<CR>' end

  -- vim.cmd("command! LspDef lua vim.lsp.buf.definition()")
  -- vim.cmd("command! LspFormatting lua vim.lsp.buf.formatting()")
  -- vim.cmd("command! LspCodeAction lua vim.lsp.buf.code_action()")
  -- vim.cmd("command! LspHover lua vim.lsp.buf.hover()")
  -- vim.cmd("command! LspRename lua vim.lsp.buf.rename()")
  -- vim.cmd("command! LspRefs lua vim.lsp.buf.references()")
  -- vim.cmd("command! LspTypeDef lua vim.lsp.buf.type_definition()")
  -- vim.cmd("command! LspImplementation lua vim.lsp.buf.implementation()")
  -- vim.cmd("command! LspDiagPrev lua vim.lsp.diagnostic.goto_prev()")
  -- vim.cmd("command! LspDiagNext lua vim.lsp.diagnostic.goto_next()")
  -- vim.cmd("command! LspDiagLine lua vim.lsp.diagnostic.show_line_diagnostics()")
  -- vim.cmd("command! LspSignatureHelp lua vim.lsp.buf.signature_help()")

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', '<space>e',
    diag("open_float("..bufnr..", { scope = 'line' })"),  opts)
  buf_set_keymap('n', '[d',       diag('goto_prev()'),    opts)
  buf_set_keymap('n', ']d',       diag('goto_next()'),    opts)
  buf_set_keymap('n', '<space>q', diag('setloclist()'),   opts)
  -- buf_set_keymap('n', '<space>c',  diag('setqflist()'),    opts)

  buf_set_keymap('n', 'gD',       lsp('declaration'),     opts)
  buf_set_keymap('n', 'gd',       lsp('definition'),      opts)
  buf_set_keymap('n', 'K',        lsp('hover'),           opts)
  buf_set_keymap('n', 'gi',       lsp('implementation'),  opts)
  buf_set_keymap('n', '[ls',      lsp('signature_help'),  opts)
  buf_set_keymap('n', '<space>D', lsp('type_definition'), opts)
  buf_set_keymap('n', '<space>rn',lsp('rename'),          opts)
  buf_set_keymap('n', 'gr',       lsp('references'),      opts)
  buf_set_keymap('n', '<space>ca',lsp('code_action'),     opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap('n', '<space>fi', lsp('formatting'),      opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap('n', '<space>fi', lsp('formatting'),      opts)
  end

  -- Add lsp status to config.
  lsp_status.on_attach(client)

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

local servers = {
  "cssls",
  "elixirls",
  "eslint",
  "jsonls",
  "rnix",
  "sumneko_lua",
  "tailwindcss",
  "terraformls",
  "tsserver",
  "html",
}

local server_configs = {
  elixirls = function(server)
    return { cmd = { server.root_dir .. "/elixir-ls/language_server.sh" } }
  end,
  eslint = {
    on_attach = function (client, bufnr)
      -- Force eslint to accept formatting requests.
      client.resolved_capabilities.document_formatting = true
      client.resolved_capabilities.document_range_formatting = false

      on_attach(client, bufnr)
    end,
    settings = {
      codeActionOnSave = {
        enable = true,
        mode = "all",
      },
    },
  },
  sumneko_lua = {
    settings = { Lua = { diagnostics = { globals = {
      'vim',
      'love',
      'hs',
    } } } },
  },
  tsserver = {
    on_attach = function (client, bufnr)
      -- Disable tsserver formatting requsts.
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false

      on_attach(client, bufnr)
    end
  },
}

local server_defaults = {
  capabilities = require("cmp_nvim_lsp").update_capabilities(
    vim.lsp.protocol.make_client_capabilities()
  ),
  flags = { debounce_text_changes = 150 },
  on_attach = on_attach,
}

local on_server_ready = function(server)
  local opts_data = server_configs[server.name]
  local opts_data_type = type(opts_data)

  local opts = {}
  if opts_data_type == 'function' then
    opts = opts_data(server)
  elseif opts_data_type == 'table' then
    opts = opts_data
  end

  opts = vim.tbl_extend("keep", opts, server_defaults)--, lsp_status.capabilities)

  -- This setup() function is exactly the same as lspconfig's setup function
  -- (:help lspconfig-quickstart)
  server:setup(opts)
end

lsp_installer.on_server_ready(on_server_ready)

local function install_server(server)
  local lsp_installer_servers = require'nvim-lsp-installer.servers'
  local ok, server_analyzer = lsp_installer_servers.get_server(server)
  if ok then
    if not server_analyzer:is_installed() then
      server_analyzer:install(server)
    end
  end
end

-- setup the LS
require "lspconfig"

-- install the LS
for _, server in ipairs(servers) do
  install_server(server)
end
