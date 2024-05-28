local fzf = require("fzf-lua")

local u = require("milogert.utils")

local fzf_files = function()
  local gitStatus = vim.g.gitsigns_head

  local cmd = u.tern(gitStatus == nil, "files", "git_files")

  return require("fzf-lua")[cmd]({ git_icons = true, file_icons = true })
end

u.nmap("<C-p>", "", {
  callback = fzf_files,
})
u.nmap("<leader>b", "", {
  callback = fzf.buffers,
})
u.nmap("<leader>/", "", {
  callback = function()
    fzf.live_grep({ search = "" })
  end,
})
u.nmap("<leader>?", "", {
  callback = function()
    fzf.live_grep_resume()
  end,
})
u.nmap("<leader>fg", "", {
  callback = fzf.git_branches,
})
u.nmap("<leader>fb", "", {
  callback = fzf.builtin,
})

fzf.setup({
  winopts = {
    preview = {
      default = "bat",
    },
  },
})
fzf.register_ui_select()
