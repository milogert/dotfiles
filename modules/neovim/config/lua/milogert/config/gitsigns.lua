local u = require "milogert.utils"
require('gitsigns').setup()

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

