local null_ls = require("null-ls")
local variables = require("milogert.variables")

local h = require("null-ls.helpers")

-- local fzf_lua_lsp = h.make_builtin({
--   name = "fzf-lua-lsp",
--   meta = {
--     url = "",
--     description = "",
--     config = {
--       {
--         key = "filter_actions",
--         type = "function",
--         description = "Callback to filter out unwanted actions.",
--         usage = [[
-- function(title)
--     return title:lower():match("workspace") == nil -- filter out workspace actions
-- end,]],
--       },
--     },
--   },
--   method = require('null-ls.methods').internal.CODE_ACTION,
--   filetypes = {},
--   can_run = function()
--     local status, _ = pcall(require, "fzf-lua")
--
--     return status
--   end,
--   generator = {
--     fn = function(params)
--       local fzf = require("fzf-lua")
--       local fzf_actions = {
--         { fn = 'lsp_references', title = 'References' },
--         { fn = 'lsp_definitions', title = 'Definitions' },
--         { fn = 'lsp_declarations', title = 'Declarations' },
--         { fn = 'lsp_typedefs', title = 'Type Definitions' },
--         { fn = 'lsp_implementations', title = 'Implementations' },
--         { fn = 'lsp_document_symbols', title = 'Document Symbols' },
--         { fn = 'lsp_workspace_symbols', title = 'Workspace Symbols' },
--         { fn = 'lsp_live_workspace_symbols', title = 'Workspace Symbols (live query)' },
--         { fn = 'lsp_code_actions', title = 'Code Actions' },
--         { fn = 'lsp_incoming_calls', title = 'Incoming Calls' },
--         { fn = 'lsp_outgoing_calls', title = 'Outgoing Calls' },
--         { fn = 'lsp_finder', title = 'All LSP locations, combined view' },
--         { fn = 'diagnostics_document', title = 'Document Diagnostics' },
--         { fn = 'diagnostics_workspace', title = 'Workspace Diagnostics' },
--         -- { fn = 'lsp_document_diagnostics', title = 'alias to diagnostics_document' },
--         -- { fn = 'lsp_workspace_diagnostics', title = 'alias to diagnostics_workspace' },
--       }
--
--       local filter_actions = params:get_config().filter_actions
--
--       local actions = {}
--       for _, action in ipairs(fzf_actions) do
--         if not filter_actions or filter_actions(action.title) then
--           local cb = fzf[action.fn]
--           table.insert(actions, {
--             title = '[lsp] '..action.title,
--             action = cb,
--           })
--         end
--       end
--       return actions
--     end,
--   },
-- })

local prefer_local_config = {
  prefer_local = "node_modules/.bin",
}

null_ls.setup({
  on_attach = require("milogert.config.lsp.on_attach"),

  sources = {
    -- require("none-ls.code_actions.eslint_d").with(prefer_local_config),
    -- null_ls.builtins.code_actions.gitsigns,
    -- null_ls.builtins.code_actions.statix,
    -- fzf_lua_lsp.with({
    --   config = {
    --     -- filter_actions = function(title)
    --     --   logger.plenary.info('filter', title)
    --     --   return title:lower():match("workspace") == nil
    --     -- end,
    --   },
    -- }),

    null_ls.builtins.diagnostics.credo,
    -- require("none-ls.diagnostics.eslint_d").with(prefer_local_config),
    -- null_ls.builtins.diagnostics.statix,

    -- require("none-ls.formatting.eslint_d").with(prefer_local_config),
    null_ls.builtins.formatting.mix,
    -- null_ls.builtins.formatting.prettier.with(prefer_local_config),
    -- null_ls.builtins.formatting.stylua.with({
    --   command = variables.get().ls_cmds.stylua[1],
    -- }),
  },
})
