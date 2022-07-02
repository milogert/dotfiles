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

local on_attach = require("milogert.config.lsp.on_attach")

local server_configs = {
  elixirls = function(server)
    vim.g.elixir_ls_server_path = server.root_dir .. "/elixir-ls"
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

local default_capabilities = vim.lsp.protocol.make_client_capabilities()
default_capabilities.textDocument.completion.completionItem.snippetSupport = true
default_capabilities = require("cmp_nvim_lsp").update_capabilities(default_capabilities)

local server_defaults = {
  capabilities = default_capabilities,
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

  opts = vim.tbl_extend("keep", opts, server_defaults)

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
