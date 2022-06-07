local u = require('utils')

vim.defer_fn(function()
  require("copilot").setup({
    -- Path is all off.
    plugin_manager_path = u.split(vim.o.packpath, ',')[1]..'/pack/'..vim.g.flakePackages..'/'
  })
end, 100)
