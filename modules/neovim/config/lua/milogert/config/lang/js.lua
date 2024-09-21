local variables = require('milogert.variables')
local lspconfig = require "lspconfig"
local lsp_utils = require "milogert.config.lsp.utils"
local on_attach = require "milogert.config.lsp.on_attach"

lspconfig.jsonls.setup(
  lsp_utils.default_with_cmd(variables.get().ls_cmds.jsonls)
)

lspconfig.eslint.setup(vim.tbl_extend("keep", {
  cmd = variables.get().ls_cmds.eslint,
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
}, lsp_utils.server_defaults))

lspconfig.tsserver.setup(vim.tbl_extend("keep", {
  cmd = variables.get().ls_cmds.tsserver,
  on_attach = function (client, bufnr)
    -- Disable tsserver formatting requsts.
    client.server_capabilities.document_formatting = false
    client.server_capabilities.document_range_formatting = false

    on_attach(client, bufnr)
  end,
  root_dir = lspconfig.util.root_pattern("package.json"),
  single_file_support = false,
  init_options = {
    preferences = {
      -- includeInlayParameterNameHints = 'all',
      -- includeInlayParameterNameHintsWhenArgumentMatchesName = true,
      -- includeInlayFunctionParameterTypeHints = true,
      -- includeInlayVariableTypeHints = true,
      -- includeInlayPropertyDeclarationTypeHints = true,
      -- includeInlayFunctionLikeReturnTypeHints = true,
      -- includeInlayEnumMemberValueHints = true,
      -- importModuleSpecifierPreference = 'non-relative',
    },
  },
}, lsp_utils.server_defaults))

if variables.get().debuggers.vscode_js then
  local dap = require("dap")

  require("dap-vscode-js").setup({
    -- Path of node executable. Defaults to $NODE_PATH, and then "node"
    -- node_path = "node",
    -- Path to vscode-js-debug installation.
    debugger_path = variables.get().debuggers.vscode_js.debugger,
    -- Command to use to launch the debug server. Takes precedence over
    -- `node_path` and `debugger_path`.
    -- debugger_cmd = { "js-debug-adapter" },
    -- Which adapters to register in nvim-dap
    adapters = {
      "pwa-node",
      "pwa-chrome",
      "pwa-msedge",
      "node-terminal",
      "pwa-extensionHost",
    },
    -- Path for file logging
    -- log_file_path = "/Users/milo/.cache/nvim/dap_vscode_js.log",
    -- Logging level for output to file. Set to false to disable file logging.
    log_file_level = false,
    -- Logging level for output to console. Set to false to disable console
    -- output.
    log_console_level = vim.log.levels.ERROR,
  })

  local js_languages = {
    "typescript",
    "javascript",
    "javascriptreact",
    "typescriptreact",
  }

  for _, language in ipairs(js_languages) do
    dap.configurations[language] = {
      -- Single node files
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch file (neovim)",
        program = "${file}",
        cwd = "${workspaceFolder}",
      },
      -- Processes
      {
        type = "pwa-node",
        request = "attach",
        name = "Attach (neovim)",
        processId = require("dap.utils").pick_process,
        cwd = "${workspaceFolder}",
      },
      -- Web apps
      {
        type = "pwa-chrome",
        request = "launch",
        name = 'Start Chrome with "localhost"',
        url = "http://localhost:3000",
        webRoot = "${workspaceFolder}",
        userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir",
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Attach Next.js",
        url = "ws://localhost:9232",
        webRoot = "${workspaceFolder}",
        userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir",
      },
      -- Jest
      {
        type = "pwa-node",
        request = "launch",
        name = "Debug Jest Tests",
        -- trace = true, -- include debugger info
        runtimeExecutable = "node",
        runtimeArgs = {
          "./node_modules/jest/bin/jest.js",
          "--runInBand",
        },
        rootPath = "${workspaceFolder}",
        cwd = "${workspaceFolder}",
        console = "integratedTerminal",
        internalConsoleOptions = "neverOpen",
      },
    }
  end

  require("dap.ext.vscode").load_launchjs(nil, {
    ["pwa-node"] = js_languages,
    ["node"] = js_languages,
    ["chrome"] = js_languages,
    ["pwa-chrome"] = js_languages,
  })
else
  print("variables.get().debuggers.vscode_js is not configured")
end
