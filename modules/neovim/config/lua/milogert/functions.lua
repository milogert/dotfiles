local log = require "milogert.logger"
local u = require "milogert.utils"

local Functions = {}

Functions.addFunctionalLogger = function(isConditional)
  local fileName = vim.fn.expand("%:t")
  local functionName = u.tern(isConditional, "cfl", "fl")

  local tail = ": ${tag}`, logData), logData )"

  local template = "const %s = tag => %slogData => ( console.log(`" .. fileName .. "%s" .. tail
  local predicateArg = u.tern(isConditional, "predicate => ", "")
  local predicateLog = u.tern(isConditional, ": CONDITION ${predicate(logData) ? '' : 'NOT '}MET", "")

  local line = string.format(template, functionName, predicateArg, predicateLog)
  vim.fn.append(0, line)
end

Functions.addNonConditionalLogger = function () Functions.addFunctionalLogger(false) end
Functions.addConditionalLogger = function () Functions.addFunctionalLogger(true) end

-- Thank you next please
-- https://ctoomey.com/writing/using-vims-arglist-as-a-todo-list/
Functions.thankYouNext = function()
  vim.cmd'update'
  vim.cmd'argdelete %'
  vim.cmd'bdelete'
  if not vim.fn.empty(vim.fn.argv()) then
    vim.cmd'argument'
  end
end

Functions.prettyPrintJson = function(wholeFile)
  local area = u.tern(wholeFile, "%", "'<,'>")
  vim.cmd(area .. "!python -m json.tool")
end

Functions.prettyPrintJsonFile = function () Functions.prettyPrintJson(true) end
Functions.prettyPrintJsonVisual = function () Functions.prettyPrintJson(false) end

Functions.fzfFiles = function()
  local gitStatus = vim.g.gitsigns_head

  local cmd = u.tern(gitStatus == nil, 'files', 'git_files')

  return require('fzf-lua')[cmd]()
end

Functions.twiddleCase = function (str)
  local is_upper = str == string.upper(str)
  local is_lower = str == string.lower(str)
  if is_upper then
    return string.lower(str)
  elseif is_lower then
    local match, _ = string.gsub(
      str,
      '(%a)(%a*)',
      function(head, rest) return string.upper(head)..rest end
    )
    return match
  else
    return string.upper(str)
  end
end

-- Smart dd, send empty lines to the black hole register.
-- https://www.reddit.com/r/neovim/comments/w0jzzv/smart_dd/
Functions.smart_dd = function ()
  local current_line = vim.api.nvim_get_current_line()
  local match = string.match(current_line, '^%s*$')
  if match ~= nil then
    -- Send to black hole.
    return '"_dd'
  else
    return 'dd'
  end
end

Functions.git_permalink = function ()
  local origin = vim.api.nvim_exec("G remote get-url --push origin", true)
  local origin_url, _ = string.gsub(origin, "git@(.+):(.+)/(.+).git", "https://%1/%2/%3")

  local sha = vim.api.nvim_exec("G rev-parse HEAD", true)

  local full_path = vim.api.nvim_buf_get_name(0)
  local pwd = vim.fn.getcwd()
  local repo_path = string.gsub(full_path, pwd, "")

  local line_number = vim.fn.line('.')

  local permalink = origin_url.."/blob/"..sha..repo_path.."#L"..line_number

  log.info("\nPERMALINK\n")

  -- send to clipboard/registry?
  vim.cmd"redir @+>"
  log.info(permalink)
  vim.cmd"redir END"

end

return Functions
