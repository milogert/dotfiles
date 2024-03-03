local logger = require('milogert.logger')

local gen_default_opts = function (opts)
  return {}
end

_G.milogert_variables = nil

local M = {}

--[[
Setup variables
  @param `opts` Table of options. Keys are:
    `config_path` The config path where all the configuration lives. Managed
      by nix but on ordinary systems it's ~/.config/nvim/
    `debuggers` The debugger install locations.
    `ls_installs` The language server install locations.
]]
M.setup = function (opts)
  if _G.milogert_variables ~= nil then
    logger.info('_G.milogert_variables have already been set up')
    return _G.milogert_variables
  end

  local default_opts = gen_default_opts(opts or {})
  _G.milogert_variables = vim.tbl_extend("force", default_opts, opts or {})
  return _G.milogert_variables
end

M.get = function()
  return _G.milogert_variables
end

return M
