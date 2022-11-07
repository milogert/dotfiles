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

-- Lsp servers enabled. `true` indicates they are managed by nix.
local servers = {
  elixirls = true,
  rnix = true,
  sumneko_lua = true,
  terraformls = true,
  tsserver = true,

  cssls = false,
  eslint = false,
  html = false,
  jsonls = false,
  stylelint_lsp = false,
  tailwindcss = false,
}

local on_attach = require("milogert.config.lsp.on_attach")

local server_configs = {
  elixirls = { cmd = vim.g.ls_locations.elixirls },

  eslint = {
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
  },

  rnix = { cmd = vim.g.ls_locations.rnix },

  stylelint_lsp = {
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
  },

  sumneko_lua = {
    cmd = vim.g.ls_locations.sumneko_lua,
    settings = { Lua = { diagnostics = { globals = {
      'vim',
      'love',
      'hs',
    } } } },
  },

  tailwindcss = {
    init_options = {
      userLanguages = {
        heex = "html-eex",
      },
    },
  },

  tsserver = {
    cmd = vim.g.ls_locations.tsserver,
    on_attach = function (client, bufnr)
      -- Disable tsserver formatting requsts.
      client.server_capabilities.document_formatting = false
      client.server_capabilities.document_range_formatting = false

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

local function install_server(server, nix_managed)
  local lsp_installer_servers = require'nvim-lsp-installer.servers'
  local ok, server_analyzer = lsp_installer_servers.get_server(server)
  if ok then
    -- Skip rnix. It's installed already. TODO I could probably do this with
    -- elixir ls as well.
    if nix_managed then
      on_server_ready(server_analyzer)
    elseif not server_analyzer:is_installed() then
      server_analyzer:install(server)
    end
  end
end

-- setup the LS
require "lspconfig"

-- install the LS
for server, nix_managed in pairs(servers) do
  install_server(server, nix_managed)
end
