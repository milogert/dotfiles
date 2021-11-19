-- Keybindings.

local u = require 'utils'

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
u.map('', '<Up>', '<nop>')
u.map('', '<Down>', '<nop>')
u.map('', '<Left>', '<nop>')
u.map('', '<Right>', '<nop>')
u.imap('<Up>', '<nop>')
u.imap('<Down>', '<nop>')
u.imap('<Left>', '<nop>')
u.imap('<Right>', '<nop>')

-- Remap j/k to gj/gk but only when we are not counting.
vim.cmd("noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')")
vim.cmd("noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')")
-- u.map('', 'j', "<expr> j (v:count == 0 ? 'gj' : 'j')<cr>")
-- u.map('', 'k', "<expr> k (v:count == 0 ? 'gk' : 'k')<cr>")

-- Fugitive
u.nmap('<Leader>g', ':G<CR>')

-- Tmuxinator helpers.
u.nmap('<Leader>ms', ':Mux start ')
u.nmap('<Leader>mc ', 'Mux stop ')

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

-- For each entry in vimuxMaps, call u.map and u.arpeggio for the key and command.
for _, map in ipairs(vimuxMaps) do
  local command = ':Vimux' .. map.command .. '<CR>'
  u.nmap(                '<Leader>' .. map.key, command)
  u.arpeggio('nnoremap', map.key,               command)
end

-- GitHub Copilot.
u.nmap('<leader>cpe', ':Copilot enable')
u.nmap('<leader>cpd', ':Copilot disable')
