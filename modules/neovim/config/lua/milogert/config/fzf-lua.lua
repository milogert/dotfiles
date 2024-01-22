local fzf = require 'fzf-lua'
local u = require "milogert.utils"

fzf.register_ui_select()

u.nmap('<C-p>', '', {
  -- Command for calling files or git_files based on the current repo status.
  callback = require('milogert.functions').fzfFiles
})
u.nmap('<leader>b', '', {
  callback = fzf.buffers
})
u.nmap('<leader>/', '', {
  callback = function() fzf.live_grep_native({ search = "" }) end
})
u.nmap('<leader>fg', '', {
  callback = fzf.git_branches
})
u.nmap('<leader>fb', '', {
  callback = fzf.builtin
})

fzf.setup {
  winopts = {
    preview = {
      default = 'bat',
    },
  },
}
