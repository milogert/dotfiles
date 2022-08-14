local Functions = {}

local tern = function(pred, t, f)
  if pred then
    return t
  else
    return f
  end
end

Functions.addFunctionalLogger = function(isConditional)
  local fileName = vim.fn.expand("%:t")
  local functionName = tern(isConditional, "cfl", "fl")

  local tail = ": ${tag}`, logData), logData )"

  local template = "const %s = tag => %slogData => ( console.log(`" .. fileName .. "%s" .. tail
  local predicateArg = tern(isConditional, "predicate => ", "")
  local predicateLog = tern(isConditional, ": CONDITION ${predicate(logData) ? '' : 'NOT '}MET", "")

  local line = string.format(template, functionName, predicateArg, predicateLog)
  vim.fn.append(0, line)
end

Functions.addNonConditionalLogger = function () Functions.addFunctionalLogger(false) end
Functions.addConditionalLogger = function () Functions.addFunctionalLogger(true) end

-- M.thankYouNext = function()
--   vim.cmd [[
--   update
--   argdelete %
--   bdelete
--   ]]
--   if !vim.fn.empty(vim.fn.argv()) then
--     vim.cmd 'argument'
--   end
-- end

Functions.prettyPrintJson = function(wholeFile)
  local area = tern(wholeFile, "%", "'<,'>")
  vim.cmd(area .. "!python -m json.tool")
end

Functions.prettyPrintJsonFile = function () Functions.prettyPrintJson(true) end
Functions.prettyPrintJsonVisual = function () Functions.prettyPrintJson(false) end

Functions.fzfFiles = function()
  local gitStatus = vim.g.gitsigns_head

  local cmd = tern(gitStatus == nil, 'files', 'git_files')

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

return Functions
