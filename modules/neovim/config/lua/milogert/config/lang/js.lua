local variables = require("milogert.variables")
local on_attach = require("milogert.config.lsp.on_attach")

-- vim.lsp.set_log_level(vim.log.levels.DEBUG)
vim.lsp.set_log_level("off")

vim.lsp.config("jsonls", { cmd = variables.get().ls_cmds.jsonls })

vim.lsp.config('eslint', {
  cmd = variables.get().ls_cmds.eslint,
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    "vue",
    "svelte",
    "astro",
    "json",
    "jsonc",
    "json5",
  },
  on_attach = function(client, bufnr)
    -- Force eslint to accept formatting requests.
    client.server_capabilities.document_formatting = true
    client.server_capabilities.document_range_formatting = false

    on_attach(client, bufnr)
  end,
  settings = {
    codeAction = {
      disableRuleComment = {
        enable = true,
        location = "separateLine",
      },
      showDocumentation = {
        enable = true,
      },
    },
    codeActionOnSave = {
      enable = false,
      mode = "all",
    },
  },
})
--
-- vim.lsp.config('ts_ls', {
--   cmd = variables.get().ls_cmds.ts_ls,
--   on_attach = function(client, bufnr)
--     -- Disable tsserver formatting requsts.
--     client.server_capabilities.document_formatting = false
--     client.server_capabilities.document_range_formatting = false
--
--     on_attach(client, bufnr)
--   end,
--   root_markers = { "package.json" },
--   single_file_support = false,
--   init_options = {
--     -- preferences = {
--     --   includeInlayParameterNameHints = 'all',
--     --   includeInlayParameterNameHintsWhenArgumentMatchesName = true,
--     --   includeInlayFunctionParameterTypeHints = true,
--     --   includeInlayVariableTypeHints = true,
--     --   includeInlayPropertyDeclarationTypeHints = true,
--     --   includeInlayFunctionLikeReturnTypeHints = true,
--     --   includeInlayEnumMemberValueHints = true,
--     --   importModuleSpecifierPreference = 'non-relative',
--     -- },
--   },
-- })

vim.lsp.enable({
  "jsonls",
  "eslint",
  -- "ts_ls",
})

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

require("typescript-tools").setup({
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
  end,
})
