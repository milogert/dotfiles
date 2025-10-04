local fzf = require("fzf-lua")

local u = require("milogert.utils")

-- require('fzf-lua-frecency').setup()

-- local fzf_files = function()
--   local gitStatus = vim.g.gitsigns_head
--
--   -- local cmd = u.tern(gitStatus == nil, "files", "global")
--   local cmd = u.tern(gitStatus == nil, "files", "git_files")
--
--   return require("fzf-lua")[cmd]({ git_icons = false, file_icons = true })
-- end

-- u.nmap("<C-m>", "", {
--   callback = function()
--     return require('fzf-lua-frecency').frecency({ cwd_only = true, git_icons = false, file_icons = false })
--   end,
-- })
u.nmap("<C-p>", function()
  require("fzf-lua-frecency").frecency({
    cwd_only = true,
    git_icons = false,
    file_icons = false,
  })
end)
u.nmap("<leader>b", fzf.buffers)
u.nmap("<leader>/", function()
  fzf.live_grep({ search = "" })
end)
u.nmap("<leader>?", function()
  fzf.live_grep_resume()
end)
u.nmap("<leader>fg", fzf.git_branches)
u.nmap("<leader>fb", fzf.builtin)

fzf.setup({
  winopts = {
    preview = {
      default = "bat",
    },
  },
})

fzf.register_ui_select({
  winopts = {
    height = 30,
    width = 140,
  },
})

-- local fzf_overlay = require("fzf-lua-overlay")
-- fzf_overlay.setup({
-- })
-- require("fzf-lua-overlay.providers.recentfiles").init()

-- local fl = setmetatable({}, {
--   __index = function(_, k)
--     return ([[<cmd>lua require('fzf-lua-overlay').%s()<cr>]]):format(k)
--   end,
-- })

-- u.nmap("<c-b>", "", { callback = fzf_overlay.buffers })
-- u.xmap("<c-b>", "", { callback = fzf_overlay.buffers })

-- u.nmap("+fs", "", { callback = fl.scriptnames })
-- u.xmap("+fs", "", { callback = fl.scriptnames })
