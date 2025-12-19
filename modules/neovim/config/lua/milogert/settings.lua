-- Set the leader key. This should be first.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Misc.
vim.opt.viminfo = [['1000,f1]]
vim.opt.exrc = false -- This option can be unsafe.

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
vim.cmd.filetype('on')
vim.cmd.filetype({ 'plugin', 'on' })
vim.cmd.filetype({ 'indent', 'on' })
vim.opt.modeline = true

-- Enable syntax highlighting.
-- True colors.
vim.opt.termguicolors = true
--set background=dark
vim.cmd('set t_Co=256')
vim.g.srcery_italic = true
-- let g:srcery_inverse_match_paren = 1
vim.cmd.colorscheme('srcery')
-- highlight StatusLine ctermfg=15 ctermbg=236 guifg=#FCE8C3 guibg=#FBB829

-- Encoding.
vim.opt.encoding = 'utf-8'

-- milo-sensible (from neovim-sensible, but even more sensible)
-- Absolute numbers for your cursor line and relative for the surrounding ones.
vim.opt.number = true
vim.opt.relativenumber = false

-- Special characters for spacing.
vim.opt.list = true
vim.opt.listchars = {
  tab = '-->',
  trail = '~',
  extends = '>',
  precedes = '<',
}

-- Tab does two spaces.
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = -1

-- Use a 80-character color column.
vim.opt.colorcolumn = '80'

-- Use the system clipboard (in addition to other things?), y/p uses it.
vim.opt.clipboard = vim.opt.clipboard + 'unnamedplus'

-- Mouse doesn't belong in terminal.
vim.opt.mouse = ''

-- Searching.
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Other settings.
vim.opt.hidden = true
vim.opt.cmdheight = 2
vim.opt.previewheight = 32
vim.opt.showmode = false
vim.opt.updatetime = 10
vim.opt.shortmess = vim.opt.shortmess + 'c'
vim.opt.scrolloff = 16
-- vim.opt.swapfile = false
vim.opt.signcolumn = 'yes'

-- Spellcheck
vim.opt.spelllang = {'en'}
vim.opt.spellsuggest = {'best', 9}

-- Folding.
vim.opt.foldnestmax = 3
vim.opt.foldenable = false
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

-- Backspace.
vim.opt.backspace = { 'indent', 'eol', 'start' }

-- Undo file to maintain undo's between runs.
vim.opt.undodir = os.getenv('HOME') .. '/.config/nvim/undodir'
vim.opt.undofile = true

-- Custom commands.
vim.cmd [[
" `vert help command-complete` for completion
"fun TmuxinatorProfiles(A,L,P)
"    return system("ls ~/.config/tmuxinator/")
"endfun
"command! -nargs=* -complete=custom,TmuxinatorProfiles mux !tmuxinator <args>
command! -nargs=* Mux !tmuxinator <args>

command! ThankYouNext lua require('milogert.functions').thankYouNext()<CR>
]]

vim.opt.lazyredraw = false

-- fzf.vim config
vim.g.fzf_buffers_jump = true

-- Vimux.
-- vim.g.VimuxHeight = "25"
vim.g.VimuxOrientation = "h"
vim.g.VimuxUseNearest = 0

-- Filetype.lua
-- vim.g.do_filetype_lua = 1 -- Enables filetype.lua
-- vim.g.did_load_filetypes = 0 -- Disables filetype.vim

vim.g.db_ui_use_nerd_fonts = 1

-- vim.o.tabline = "%!TabLine()"
--
-- 	function MyTabLine()
-- 	  let s = ''
-- 	  for i in range(tabpagenr('$'))
-- 	    " select the highlighting
-- 	    if i + 1 == tabpagenr()
-- 	      let s ..= '%#TabLineSel#'
-- 	    else
-- 	      let s ..= '%#TabLine#'
-- 	    endif
--
-- 	    " set the tab page number (for mouse clicks)
-- 	    let s ..= '%' .. (i + 1) .. 'T'
--
-- 	    " the label is made by MyTabLabel()
-- 	    let s ..= ' %{MyTabLabel(' .. (i + 1) .. ')} '
-- 	  endfor
--
-- 	  " after the last tab fill with TabLineFill and reset tab page nr
-- 	  let s ..= '%#TabLineFill#%T'
--
-- 	  " right-align the label to close the current tab page
-- 	  if tabpagenr('$') > 1
-- 	    let s ..= '%=%#TabLine#%999Xclose'
-- 	  endif
--
-- 	  return s
-- 	endfunction
