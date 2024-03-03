local u = require "milogert.utils"

vim.cmd.packadd('vimplugin-vim-arpeggio')

u.arpeggio('inoremap', 'jk', '<Esc>')
