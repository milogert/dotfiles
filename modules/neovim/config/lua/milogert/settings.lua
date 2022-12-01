local u = require('milogert.utils')
local log = require'milogert.logger'

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
vim.opt.clipboard = vim.opt.clipboard + 'unnamed'

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
vim.opt.updatetime = 10
vim.opt.shortmess = vim.opt.shortmess + 'c'
vim.opt.scrolloff = 16
-- vim.opt.swapfile = false
vim.opt.signcolumn = 'yes'

-- Spellcheck
vim.opt.spelllang = {'en'}
vim.opt.spellsuggest = {'best', 9}

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
    local is_template = string.match(first_line, "Feel free") ~= nil
    if not (is_merge or is_template) then
      vim.api.nvim_command('0r '..vim.g.configPath..'/skeletons/gitcommit.skeleton')
    end
  end
})

vim.api.nvim_create_augroup('dadbod-auto-configure', { clear = true })
vim.api.nvim_create_autocmd('VimEnter', {
  group = 'dadbod-auto-configure',
  desc = 'Parse docker compose and set up database variables',
  pattern = '*',
  callback = function()
    local file = vim.fn.getcwd()..'/docker-compose.override.yml'
    local has_docker_compose = u.file_exists(file)
    if not has_docker_compose then
      return
    end

    local paths = {
      ".services.postgres.ports[0]",
      ".services.db.ports[0]",
    }

    local ports = nil
    for _, path in ipairs(paths) do
      ports = vim.fn.system({ "yq", "-r", path, file })

      if ports then
        break
      end
    end

    local local_port = u.split(ports, ":")[1]

    vim.g.db_port = "postgres://postgres@localhost:"..local_port.."/postgres"
    u.nmap('<Leader>dbc', ':DB g:db_port<CR>')
    log.info("Found a docker-compose db. Use <Leader>dbc to connect")
  end
})

-- vim.api.nvim_create_autocmd('BufNew,BufRead', {
--   pattern = '*/pre-incidents/*',
-- })
-- autocmd BufNewFile,BufRead /specificPath/** imap <buffer> ....

-- vim-commentary
-- vim.api.nvim_create_augroup('vim-commentary', { clear = true })
-- vim.api.nvim_create_autocmd('FileType', {
--   group = 'vim-commentary',
--   desc = 'React comments',
--   pattern = 'javascriptreact',
--   command = 'setlocal commentstring={/* %s */}'
-- })

-- From 
vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('auto_create_dir', { clear = true }),
  callback = function(ctx)
    vim.fn.mkdir(vim.fn.fnamemodify(ctx.file, ':p:h'), 'p')
  end
})

-- Vimux.
vim.g.VimuxHeight = "25"
vim.g.VimuxOrientation = "h"
vim.g.VimuxUseNearest = 0

-- Filetype.lua
-- vim.g.do_filetype_lua = 1 -- Enables filetype.lua
-- vim.g.did_load_filetypes = 0 -- Disables filetype.vim

-- Vim Tada
local path = os.getenv("PWD") or io.popen("cd"):read()
local splitPath = u.split(path, "/")
local dir = string.gsub(splitPath[#splitPath], '^%.', '_')
local file = os.getenv("HOME").."/todos/"..dir..".tada"
vim.g.tada_todo_pane_file = file
vim.g.tada_todo_pane_map = '<Leader>td'
vim.g.tada_map_box = '<C-\\>'
vim.g.tada_todo_switch_status_mapping = '\\'
