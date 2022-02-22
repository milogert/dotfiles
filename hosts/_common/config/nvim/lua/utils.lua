local utils = {}

-- Generic mapping function.
--   Provide '' (empty string) to `mode` for general maps.
function utils.map(mode, shortcut, command, options)
  local defaults = { noremap = true, silent = true }
  local opts = vim.tbl_extend("force", defaults, options)
  print(shortcut, command, opts)
  vim.api.nvim_set_keymap(mode, shortcut, command, opts)
end

-- Normal mode maps.
function utils.nmap(shortcut, command, options)
  utils.map('n', shortcut, command, options or {})
end

-- Insert mode maps.
function utils.imap(shortcut, command, options)
  utils.map('i', shortcut, command, options or {})
end

-- Visual mode maps.
function utils.xmap(shortcut, command, options)
  utils.map('x', shortcut, command, options or {})
end

-- Arpeggio maps.
function utils.arpeggio(type, lhs, rhs)
  vim.cmd('Arpeggio ' .. type .. ' <silent> ' .. lhs .. ' ' .. rhs)
end

return utils
