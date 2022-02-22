--[[
Utils functions for vim.
]]

local Utils = {}

--[[
Generic mapping function.
  @param `mode` The mode of the map. Empty string means all modes.
  @param `shortcut` The actual mapping.
  @param `command` The command to produce.
  @param `options` Any options to pass along. Defaults to `{}`.
]]
Utils._map = function(mode, shortcut, command, options)
  local defaults = { noremap = true, silent = true }
  local opts = vim.tbl_extend("force", defaults, options or {})
  vim.api.nvim_set_keymap(mode, shortcut, command, opts)
end

Utils.map = function(shortcut, command, options)
  Utils._map('', shortcut, command, options)
end

-- Normal mode maps.
Utils.nmap = function(shortcut, command, options)
  Utils._map('n', shortcut, command, options)
end

-- Insert mode maps.
Utils.imap = function(shortcut, command, options)
  Utils._map('i', shortcut, command, options)
end

-- Visual mode maps.
Utils.xmap = function(shortcut, command, options)
  Utils._map('x', shortcut, command, options)
end

--[[
Arpeggio maps.
  @param `type` Where the map is available, such as `innoremap`
  @param `lhs` The chord to be detected
  @param `rhs` The result to be produced
]]
Utils.arpeggio = function(type, lhs, rhs)
  vim.cmd('Arpeggio ' .. type .. ' <silent> ' .. lhs .. ' ' .. rhs)
end

return Utils
