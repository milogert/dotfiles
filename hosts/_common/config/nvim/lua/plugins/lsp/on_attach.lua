local M = {}

-- Use an on_attach function to only map the following keys
-- after the language server attachs to the current buffer
M.on_attach = function(registrees)
  return function(client, bufnr)
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
    require('plugins.lsp.status').on_attach(client)
  end
end

return M

