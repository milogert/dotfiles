local logger = require('milogert.logger')

local gen_default_opts = function (opts)
  return {}
end

---@class milogert.variables.Debuggers {
---@field elixir_ls string
---@field vscode_js { adapter: string, debugger: string }

---@class milogert.variables.Ls_Cmds
---@field biome string[]
---@field cssls string[]
---@field elixirls string[]
---@field html string[]
---@field jsonls string[]
---@field lua_ls string[]
---@field nil_ls string[]
---@field tailwindcss string[]
---@field terraformls string[]
---@field texlab string[]
---@field tsgo string[]

---@class milogert.variables.Formatters
---@field lua string[]
---@field sql string[]

---@class milogert.Variables {
---@field nix boolean
---@field config_path string
---@field debuggers milogert.variables.Debuggers
---@field ls_cmds milogert.variables.Ls_Cmds
---@field formatters milogert.variables.Formatters

---@type milogert.Variables
_G.milogert_variables = nil

local M = {}

--[[
Setup variables. Ultimately saves them globally so I can access them wherever.
]]
---@param opts milogert.Variables commonly used variables in my configuration
M.setup = function (opts)
  if _G.milogert_variables ~= nil then
    logger.info('_G.milogert_variables have already been set up')
    return _G.milogert_variables
  end

  local default_opts = gen_default_opts(opts or {})
  _G.milogert_variables = vim.tbl_extend("force", default_opts, opts or {})
  return _G.milogert_variables
end

--[[
Get the variables that were saved.
]]
M.get = function()
  return _G.milogert_variables
end

return M
