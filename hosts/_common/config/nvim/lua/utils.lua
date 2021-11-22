local utils = {}

-- Generic mapping function.
--   Provide '' (empty string) to `mode` for general maps.
function utils.map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

-- Normal mode maps.
function utils.nmap(shortcut, command)
  utils.map('n', shortcut, command)
end

-- Insert mode maps.
function utils.imap(shortcut, command)
  utils.map('i', shortcut, command)
end

-- Visual mode maps.
function utils.xmap(shortcut, command)
  utils.map('x', shortcut, command)
end

-- Arpeggio maps.
function utils.arpeggio(type, lhs, rhs)
  vim.cmd('Arpeggio ' .. type .. ' <silent> ' .. lhs .. ' ' .. rhs)
end

return utils
