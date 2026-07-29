local neotest = require("neotest")

neotest.setup({
  adapters = {
    require("neotest-vitest")({
      -- Filter directories when searching for test files. Useful in large projects (see Filter directories notes).
      filter_dir = function(name, _rel_path, _root)
        return name ~= "node_modules"
      end,
    }),
  },
})
