if vim.g.configPath == nil then
  print('vim.g.configPath is missing')
  return
end

-- Add the config directory to the start of the rtp.
vim.opt.runtimepath:prepend(vim.g.configPath)

local log = require("milogert.logger")

-- https://github.com/neovim/neovim/issues/21749#issuecomment-1378720864
-- Fix loading of json5
table.insert(vim._so_trails, "/?.dylib")

-- require("impatient")

-- Set the leader key. This should be first.
require("milogert.settings")
require("milogert.autocmds")
require("milogert.variables")

vim.cmd.packadd('vimplugin-vim-arpeggio')

-- Source plugin configs.
local plugins = {
  "cmp",
  "colorizer",
  "comment",
  "copilot",
  "dap",
  "devcontainer",
  "fidget",
  "fzf-lua",
  "gitsigns",
  "keybindings",
  -- "hardtime",
  "lsp.installer",
  "luasnip",
  "mini",
  "null-ls",
  "octo",
  "package-info",
  "persistence",
  "runscript",
  "treesitter",

  "heirline", -- Needs to be last since it uses info from other imports
}

for _, plugin in ipairs(plugins) do
  local ok, err = pcall(require, 'milogert.config.' .. plugin)
  if not ok then
    log.error('Failed to load plugin config: ' .. plugin)
    log.error(err)
  end
end

-- Load optional files.
local optionals = {
  'playground',
  'priv',
}

for _, mod in ipairs(optionals) do
  local ok, err = pcall(require, mod)
  if not ok then
    log.info('Failed to load file: ' .. mod .. '.lua')
    log.error(err)
  end
end

-- Perform language setup.
require('milogert.config.lang.main')

-- Dirvish - override netrw when using Explore, Sexplore, and Vexplore.
vim.g.loaded_netrwPlugin = 'loaded due to dirvish'
for _, value in ipairs({ { 'Explore', '' }, { 'Sexplore', 'split | silent ' }, { 'Vexplore', 'vsplit | silent ' } }) do
  vim.api.nvim_create_user_command(
    value[1],
    function(opts)
      vim.cmd(value[2] .. 'Dirvish ' .. opts.fargs[1])
    end,
    { nargs = '?', complete = 'dir' }
  )
end

vim.cmd [[
" Function to source only if file exists.
function! SourceIfExists(file)
  if filereadable(expand(a:file))
    exe 'source' a:file
  endif
endfunction

function! TwiddleCase(str)
  if a:str ==# toupper(a:str)
    let result = tolower(a:str)
  elseif a:str ==# tolower(a:str)
    let result = substitute(a:str,'\(\<\w\+\>\)', '\u\1', 'g')
  else
    let result = toupper(a:str)
  endif
  return result
endfunction
vnoremap ~ y:call setreg('', TwiddleCase(@"), getregtype(''))<CR>gv""Pgv

" Source other files.
call SourceIfExists("~/.config/nvim/profile.vim")

function! Scratch()
  vsplit
  noswapfile hide enew
  setlocal buftype=nofile
  setlocal bufhidden=hide
  "setlocal nobuflisted
  "lcd ~
  file scratch
endfunction
]]
