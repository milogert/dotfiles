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

-- From http://lua-users.org/wiki/FileInputOutput
Utils.file_exists = function(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

Utils.lines_from = function(file)
  if not Utils.file_exists(file) then return {} end

  local lines = {}
  for line in io.lines(file) do 
    lines[#lines + 1] = line
  end
  return lines
end

return Utils
