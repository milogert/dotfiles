-- Keybindings.

local u = require "utils"
local f = require "functions"
local log = require 'logger'

-- Config maps.
u.nmap('<leader>re', ':tabnew $MYVIMRC<CR>')
u.nmap('<leader>rs', ':so $MYVIMRC<CR>')

-- gF opens the file under the cursor in a new split.
u.nmap('gF', '<C-w>vgf')

-- Enter key starts prompt.
-- u.nmap('<CR>', ':')

-- Fast switch between buffers by pressing leader twice.
u.nmap('<leader><leader>', '<c-^>')

-- Make Y act like C and D
u.nmap('Y', 'y$')

-- Swap ` and ' for marks, since ` (by default) jumps to line and column.
u.nmap("'", '`')
u.nmap('`', "'")

-- Remap the arrow keys to do nothing.
u.map('<Up>', '<nop>')
u.map('<Down>', '<nop>')
u.map('<Left>', '<nop>')
u.map('<Right>', '<nop>')
u.imap('<Up>', '<nop>')
u.imap('<Down>', '<nop>')
u.imap('<Left>', '<nop>')
u.imap('<Right>', '<nop>')

-- Remap j/k to gj/gk but only when we are not counting.
local jkMapOpts = { noremap = true, silent = true, expr = true }
u.map('j', '(v:count == 0 ? "gj" : "j")', jkMapOpts)
u.map('k', '(v:count == 0 ? "gk" : "k")', jkMapOpts)

-- Fugitive
u.nmap('<leader>g', ':G<CR>')

-- Tmuxinator helpers.
u.nmap('<leader>ms', ':Mux start ', { silent = false })
u.nmap('<leader>mc', ':Mux stop ', { silent = false })

-- Escape quickly.
u.imap('jj', '<Esc>')
u.arpeggio('inoremap', 'jk', '<Esc>')

-- Vimux keys.
local vimuxMaps = {
  { key = 'vp', command = 'PromptCommand' },
  { key = 'vl', command = 'RunLastCommand' },
  { key = 'vz', command = 'ZoomRunner' },
  { key = 'vs', command = 'InterruptRunner' },
}

for _, map in ipairs(vimuxMaps) do
  local command = ':Vimux' .. map.command .. '<CR>'
  u.nmap(                '<leader>' .. map.key, command)
  u.arpeggio('nnoremap', map.key,               command)
end

-- Fzf helper importer.
local fzf = function()
  return require('fzf-lua')
end

u.nmap('<C-p>', '', {
  -- Command for calling files or git_files based on the current repo status.
  callback = require('functions').fzfFiles
})
u.nmap('<leader>b', '', {
  callback = fzf().buffers
})
u.nmap('<leader>/', '', {
  callback = function() fzf().live_grep_native({ search = "" }) end
})
u.nmap('<leader>fg', '', {
  callback = fzf().git_branches
})
u.nmap('<leader>fb', '', {
  callback = fzf().builtin
})

-- Function keybindings.
u.nmap('<leader>fl', '', {
  callback = f.addNonConditionalLogger
})
u.nmap('<leader>cfl', '', {
  callback = f.addConditionalLogger
})
u.nmap('<leader>ppj', '', {
  callback = f.prettyPrintJsonFile
})
u.xmap('<leader>ppj', '', {
  callback = f.prettyPrintJsonVisual
})

-- Split lines? Probably not..
-- nnoremap S :keeppatterns substitute/\s*\%#\s*/\r/e <bar> normal! ==<CR>

-- Sort while highlighting something.
u.xmap('u', [[:'<,'>sort<cr>]])
