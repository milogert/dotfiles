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

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', '<leader>e',
    diag("open_float("..bufnr..", { scope = 'line' })"),  opts)
  buf_set_keymap('n', '[d',        diag('goto_prev()'),    opts)
  buf_set_keymap('n', ']d',        diag('goto_next()'),    opts)
  buf_set_keymap('n', '<leader>q', diag('setloclist()'),   opts)
  buf_set_keymap('n', '<leader>c', diag('setqflist()'),    opts)

  buf_set_keymap('n', 'gD',        lsp('declaration'),     opts)
  buf_set_keymap('n', 'gd',        lsp('definition'),      opts)
  buf_set_keymap('n', 'K',         lsp('hover'),           opts)
  buf_set_keymap('n', 'gi',        lsp('implementation'),  opts)
  buf_set_keymap('n', '[ls',       lsp('signature_help'),  opts)
  buf_set_keymap('n', '<leader>D', lsp('type_definition'), opts)
  buf_set_keymap('n', '<leader>rn',lsp('rename'),          opts)
  buf_set_keymap('n', 'gr',        lsp('references'),      opts)
  buf_set_keymap('n', '<leader>ca',lsp('code_action'),     opts)

  -- Set some keybinds conditional on server capabilities
  if client.server_capabilities.document_formatting then
    buf_set_keymap('n', '<leader>fi', lsp('formatting'),      opts)
  elseif client.server_capabilities.document_range_formatting then
    buf_set_keymap('n', '<leader>fi', lsp('formatting'),      opts)
  end

  -- Attach navic to the LSP if it supports the documentSymbols capability.
  -- if client.server_capabilities.documentSymbolProvider then
  --   require"nvim-navic".attach(client, bufnr)
  -- end
end

return on_attach
