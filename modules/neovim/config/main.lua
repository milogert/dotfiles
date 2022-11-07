local log = require("milogert.logger")

-- require("impatient")

-- Set the leader key. This should be first.
require("milogert.settings")

vim.cmd [[ packadd vimplugin-vim-arpeggio ]]

-- Source plugin configs.
local plugins = {
  "cmp",
  "colorizer",
  "comment",
  "dap",
  "fidget",
  "fzf-lua",
  "gitsigns",
  "keybindings",
  "lsp.settings",
  "lsp.kind",
  "lsp.installer",
  "luasnip",
  "mini",
  "null-ls",
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
]]
