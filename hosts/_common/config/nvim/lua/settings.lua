local utils = require('utils')

-- Set the leader key. This should be first.
vim.g.mapleader = ' '

vim.opt.viminfo = [['1000,f1]]

-- vim.opt.rtp = vim.opt.rtp + '/usr/local/bin/fzf'

-- Highlight the current line.
vim.opt.cursorline = true

-- ShaDa
vim.opt.shada = "'50"

-- Splitting.
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Enable modelines.
vim.opt.compatible = false
vim.cmd [[
filetype on
filetype plugin on
filetype indent on
]]
vim.opt.modeline = true

-- Enable syntax highlighting.
-- True colors.
vim.opt.termguicolors = true
--set background=dark
vim.cmd('set t_Co=256')
vim.g.srcery_italic = true
-- let g:srcery_inverse_match_paren = 1
vim.cmd 'colorscheme srcery'
-- highlight StatusLine ctermfg=15 ctermbg=236 guifg=#FCE8C3 guibg=#FBB829

-- Encoding.
vim.opt.encoding = 'utf-8'

-- milo-sensible (from neovim-sensible, but even more sensible)
-- Absolute numbers for your cursor line and relative for the surrounding ones.
vim.opt.number = true
vim.opt.relativenumber = true

-- Special characters for spacing.
vim.opt.list = true
-- set listchars=eol:$,tab:-->,trail:~,extends:>,precedes:<,space:·
-- vim.opt.listchars = {
--   'tab:-->',
--   'trail:~',
--   'extends:>',
--   'precedes:<',
-- }
vim.cmd([[set listchars=tab:-->,trail:~,extends:>,precedes:<]])

-- Tab does two spaces.
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = -1

-- Use a 80-character color column.
vim.opt.colorcolumn = '80'

-- Use the system clipboard (in addition to other things?), y/p uses it.
vim.opt.clipboard = vim.opt.clipboard + 'unnamed'

-- Mouse doesn't belong in terminal.
vim.opt.mouse = ''

-- Searching.
vim.opt.exrc = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Other settings.
vim.opt.hidden = true
vim.opt.cmdheight = 2
vim.opt.updatetime = 10
vim.opt.shortmess = vim.opt.shortmess + 'c'
vim.opt.scrolloff = 16
vim.opt.swapfile = false

vim.opt.signcolumn = 'yes'

-- Folding.
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldnestmax = 10
vim.opt.foldenable = false

-- Backspace.
vim.opt.backspace = { 'indent', 'eol', 'start' }

-- Undo file to maintain undo's between runs.
vim.opt.undodir = os.getenv('HOME') .. '/.config/nvim/undodir'
vim.opt.undofile = true

-- Wild menu config
vim.opt.wildmenu = true
vim.opt.wildmode = { 'longest', 'list' , 'full' }
vim.opt.wildignore = vim.opt.wildignore + {
  '=*.o',
  '*~',
  '*/tmp/*',
  '*.so',
  '*.swp',
  '*.zip',
  '*.snap',
}

-- Abbreviations.
vim.cmd [[
cabbrev Mux !tmuxinator
" cnoreabbrev G vert<space>G
" cnoreabbrev Gstatus vert<space>Gstatus
]]

vim.opt.lazyredraw = false

-- fzf.vim config
vim.g.fzf_buffers_jump = true

-- augroups and autocmd
vim.api.nvim_create_augroup('formatting', { clear = true })
-- vim.api.nvim_create_autocmd('BufWritePost', {
--   group = 'formatting',
--   desc = 'Format Elixir files on save',
--   pattern = { '*.exs', '*.ex' },
--   command = 'silent !mix format %',
-- })

vim.api.nvim_create_augroup('skeletons', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = 'skeletons',
  desc = 'Insert a common git commit format, unless it\'s a merge commit',
  pattern = 'gitcommit',
  callback = function()
    local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
    local is_merge = string.sub(first_line, 1, 5) == 'Merge'
    if not is_merge then
      vim.api.nvim_command('0r ~/.config/nvim/skeletons/gitcommit.skeleton')
    end
  end
})
-- vim.api.nvim_create_autocmd('BufNew,BufRead', {
--   pattern = '*/pre-incidents/*',
-- })
-- autocmd BufNewFile,BufRead /specificPath/** imap <buffer> ....

-- Vimux.
vim.g.VimuxHeight = "25"
vim.g.VimuxOrientation = "h"
vim.g.VimuxUseNearest = 0
