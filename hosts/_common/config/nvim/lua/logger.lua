local M = {}

local levels = vim.log.levels

M.log = function(msg, level, opts, fn)
  if opts == nil then
    opts = {}
  end

  if fn == nil then
    fn = vim.api.nvim_notify
  end

  fn(msg, level, opts)

  return msg
end

M.error = function(msg)
  return M.log(msg, levels.ERROR)
end

M.warn = function(msg)
  return M.log(msg, levels.WARN)
end

M.info = function(msg)
  return M.log(msg, levels.INFO)
end

M.debug = function(msg)
  return M.log(msg, levels.DEBUG)
end

M.trace = function(msg)
  return M.log(msg, levels.TRACE)
end

return M
