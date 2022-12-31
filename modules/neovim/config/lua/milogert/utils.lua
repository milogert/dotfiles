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

Utils.vmap = function(shortcut, command, options)
  Utils._map('v', shortcut, command, options)
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

--[[
TODO: this doesn't work.
]]
Utils.create_file = function(file, data)
  local f = io.open(file, "w")
  if f ~= nil then
    f:write(data or "")
    f:close()
  end
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

-- From https://stackoverflow.com/questions/1426954/split-string-in-lua
Utils.split = function(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t={}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end

Utils.join = function(tab, sep)
  local table_length = #tab
  if table_length == 0 then
    return ''
  end
  if table_length == 1 then
    return tab[1]
  end
  if sep == nil then
    sep = ''
  end
  local str = tab[1]
  for i = 2, table_length do
    str = str..sep..tab[i]
  end
  return str
end

Utils.table_to_string = function (o)
  if type(o) == 'table' then
    local s = '{ '
    for k,v in pairs(o) do
      if type(k) ~= 'number' then k = '"'..k..'"' end
      s = s .. '['..k..'] = ' .. Utils.table_to_string(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end


Utils.tern = function(pred, t, f)
  if pred then
    return t
  else
    return f
  end
end

Utils.trim = function(s, only_end)
  local from
  if only_end then
    from = 0
  else
    from = s:match"^%s*()"
  end
  return from > #s and "" or s:match(".*%S", from)
end

return Utils
