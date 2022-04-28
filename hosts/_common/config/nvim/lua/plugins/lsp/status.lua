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

return lsp_status
