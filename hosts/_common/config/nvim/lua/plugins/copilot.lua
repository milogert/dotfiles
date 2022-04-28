function split(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t={}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end

vim.defer_fn(function()
  require("copilot").setup({
    -- Path is all off.
    plugin_manager_path = split(vim.o.packpath, ',')[1] .. '/pack/home-manager/'
  })
end, 100)
