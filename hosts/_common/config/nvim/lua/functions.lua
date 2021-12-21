local M = {}

local tern = function(pred, t, f)
  if pred then
    return t
  else
    return f
  end
end

M.addFunctionalLogger = function(isConditional)
  local fileName = vim.fn.expand('%:t')
  local functionName = tern(isConditional, 'cfl', 'fl')

  local tail = ': ${tag}`, logData), logData )'

  local template = "const %s = tag => %slogData => ( console.log(`" .. fileName .. "%s" .. tail
  local predicateArg = tern(isConditional, 'predicate => ', '')
  local predicateLog = tern(isConditional, ": CONDITION ${predicate(logData) ? '' : 'NOT '}MET", '')

  local line = string.format(template, functionName, predicateArg, predicateLog)
  -- local line = "const fl = tag => logData => ( console.log(`" .. fileName .. ": ${tag}`, logData), logData )"
  -- local line2 = "const cfl = tag => predicate => logData => ( console.log(`CONDITION ${predicate(logData) ? '' : 'NOT '}MET: ${tag}`, logData) , logData )")
  vim.fn.append(0, line)
end

M.thankYouNext = function()
  vim.cmd [[
  update
  argdelete %
  bdelete
  ]]
  if !vim.fn.empty(vim.fn.argv()) then
    vim.cmd 'argument'
  end
end

return M
