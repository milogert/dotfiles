local Logger = {}

local levels = vim.log.levels

Logger.log = function(msg, level, opts, fn)
  if opts == nil then
    opts = {}
  end

  if fn == nil then
    vim.api.nvim_notify(msg, level, opts)
  else
    fn(msg, level, opts)
  end

  return msg
end

Logger.error = function(msg)
  return Logger.log(msg, levels.ERROR)
end

Logger.warn = function(msg)
  return Logger.log(msg, levels.WARN)
end
Logger.warning = Logger.warn

Logger.info = function(msg)
  return Logger.log(msg, levels.INFO)
end

Logger.debug = function(msg)
  return Logger.log(msg, levels.DEBUG)
end

Logger.trace = function(msg)
  return Logger.log(msg, levels.TRACE)
end

Logger.file = function(handle, msg)
  handle:write(os.date("%Y-%m-%dT%H:%M:%S")..'\t'..msg..'\n')
  return msg
end

Logger.plenary = require("plenary.log").new { plugin = "milogert.dotfiles" }

return Logger
