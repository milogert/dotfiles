--[[
Utils functions for vim.
]]
local Utils = {}

---@alias mode ""|"n"|"nnoremap"|"i"|"inoremap"|"x"|"v"

--[[
Generic mapping function.
]]
---@param mode mode The mode of the map. Empty string means all modes.
---@param lhs string The mapping
---@param rhs string|function The command to run
---@param options? table Any options to pass along. Defaults to `{}`.
Utils._map = function(mode, lhs, rhs, options)
  local defaults = { noremap = true, silent = true }
  local opts = vim.tbl_extend("force", defaults, options or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

Utils.map = function(lhs, rhs, options)
  Utils._map("", lhs, rhs, options)
end

--[[
Normal mode maps.
]]
---@param lhs string Keymap
---@param rhs string|function String or function
---@param options? table Table of options
Utils.nmap = function(lhs, rhs, options)
  Utils._map("n", lhs, rhs, options)
end

--[[
Insert mode maps.
]]
-- Insert mode maps.
---@param lhs string Keymap
---@param rhs string|function String or function
---@param options? table Table of options
Utils.imap = function(lhs, rhs, options)
  Utils._map("i", lhs, rhs, options)
end

--[[
Visual mode maps.
]]
-- Visual mode maps.
---@param lhs string Keymap
---@param rhs string|function String or function
---@param options? table Table of options
Utils.xmap = function(lhs, rhs, options)
  Utils._map("x", lhs, rhs, options)
end

--[[
Visual mode maps.
]]
---@param lhs string Keymap
---@param rhs string|function String or function
---@param options? table Table of options
Utils.vmap = function(lhs, rhs, options)
  Utils._map("v", lhs, rhs, options)
end

--[[
Arpeggio maps.
]]
---@param mode mode The mode where the mapping is available.
---@param lhs string The mapping
---@param rhs string|function The command to run
Utils.arpeggio = function(mode, lhs, rhs)
  vim.cmd.Arpeggio(mode .. " <silent> " .. lhs .. " " .. rhs)
end

-- TODO: this doesn't work.
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
  if f then
    f:close()
  end
  return f ~= nil
end

Utils.lines_from = function(file)
  if not Utils.file_exists(file) then
    return {}
  end

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
  local t = {}
  for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

Utils.join = function(tab, sep)
  local table_length = #tab
  if table_length == 0 then
    return ""
  end
  if table_length == 1 then
    return tab[1]
  end
  if sep == nil then
    sep = ""
  end
  local str = tab[1]
  for i = 2, table_length do
    str = str .. sep .. tab[i]
  end
  return str
end

Utils.table_to_string = function(o)
  if type(o) == "table" then
    local s = "{ "
    for k, v in pairs(o) do
      if type(k) ~= "number" then
        k = '"' .. k .. '"'
      end
      s = s .. "[" .. k .. "] = " .. Utils.table_to_string(v) .. ","
    end
    return s .. "} "
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
    from = s:match("^%s*()")
  end
  return from > #s and "" or s:match(".*%S", from)
end

-- From https://stackoverflow.com/questions/29072601/lua-string-gsub-with-a-hyphen
Utils.replace = function(str, what, with)
  what = string.gsub(what, "[%(%)%.%+%-%*%?%[%]%^%$%%]", "%%%1")
  with = string.gsub(with, "[%%]", "%%%%")
  return string.gsub(str, what, with)
end

-- From https://gist.github.com/Zbizu/43df621b3cd0dc460a76f7fe5aa87f30
Utils.getOS = function()
  -- ask LuaJIT first
  if jit then
    return jit.os
  end

  -- Unix, Linux variants
  local fh, err = assert(io.popen("uname -o 2>/dev/null", "r"))
  local osname
  if fh then
    osname = fh:read()
  end

  return osname or "Windows"
end

return Utils
