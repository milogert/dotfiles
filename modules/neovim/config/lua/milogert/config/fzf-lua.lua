local fzf = require 'fzf-lua'

fzf.setup {
  winopts = {
    preview = {
      default = 'bat',
    },
  },
}
