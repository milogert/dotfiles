-- Keybindings.

local u = require "milogert.utils"
local f = require "milogert.functions"

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
  callback = require('milogert.functions').fzfFiles
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

-- Jump between hunks
local gitsignsMaps = {
  [']g'] = {
    cmd = [[&diff ? ']g' : '<cmd>Gitsigns next_hunk<CR>']],
    opts = { expr = true },
  },
  ['[g'] = {
    cmd = [[&diff ? '[g' : '<cmd>Gitsigns prev_hunk<CR>']],
    opts = { expr = true },
  },

  -- Popup what's changed in a hunk under cursor
  ['<Leader>gp'] = ':Gitsigns preview_hunk<CR>',

  -- Stage/reset individual hunks under cursor in a file
  ['<Leader>gs'] = ':Gitsigns stage_hunk<CR>',
  ['<Leader>gr'] = ':Gitsigns reset_hunk<CR>',
  ['<Leader>gu'] = ':Gitsigns undo_stage_hunk<CR>',

  -- Stage/reset all hunks in a file
  ['<Leader>gS'] = ':Gitsigns stage_buffer<CR>',
  ['<Leader>gU'] = ':Gitsigns reset_buffer_index<CR>',
  ['<Leader>gR'] = ':Gitsigns reset_buffer<CR>',

  -- Open git status in interative window (similar to lazygit)
  ['<Leader>gg'] = ':Git<CR>',

  -- Show `git status output`
  -- ['<Leader>gs'] = ':Git status<CR>',

  -- Open commit window (creates commit after writing and saving commit msg)
  ['<Leader>gc'] = ':Git commit | startinsert<CR>',

  -- Other tools from fugitive
  ['<Leader>gd'] = ':Git difftool<CR>',
  ['<Leader>gm'] = ':Git mergetool<CR>',
  ['<Leader>g|'] = ':Gvdiffsplit<CR>',
  ['<Leader>g_'] = ':Gdiffsplit<CR>',
}

for key, map in pairs(gitsignsMaps) do
  if type(map) == 'string' then
    u.nmap(key, map)
  else
    u.nmap(key, map.cmd, map.opts)
  end
end

u.nmap('dd', '', { callback = f.smart_dd, expr = true })

u.nmap('<Leader>gl', '', { callback = f.git_permalink })

-- Spellcheck
u.nmap('<F11>', ':set spell!<CR>')
u.imap('<F11>', '<C-O>:set spell!<CR>')
