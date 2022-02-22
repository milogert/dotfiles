local log = require('logger')

-- require("impatient")

-- Set the leader key. This should be first.
require("settings")

vim.cmd [[ packadd vimplugin-vim-arpeggio ]]

-- Source plugin configs.
local plugins = {
  -- "alpha-nvim",
  "cmp",
  "fzf-lua",
  "gitsigns",
  -- "gps",
  "keybindings",
  "lsp",
  "luasnip",
  "package-info",
  "persistence",
  -- "telescope",
  "treesitter",
  -- "which-key",

  -- Needs to be last since it uses info from other imports
  "heirline",
}

for _, plugin in ipairs(plugins) do
  local ok, _ = pcall(require, 'plugins.' .. plugin)
  if not ok then
    log.error('Failed to load plugin config: ' .. plugin)
  end
end

-- Load optional files.
local optionals = {
  'playground',
  'priv',
}

for _, mod in ipairs(optionals) do
  local ok, _ = pcall(require, mod)
  if not ok then
    log.info('Failed to load file: ' .. mod .. '.lua')
  end
end


vim.cmd [[
" Function to source only if file exists.
function! SourceIfExists(file)
  if filereadable(expand(a:file))
    exe 'source' a:file
  endif
endfunction

" Append modeline after last line in buffer.
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.
function! AppendModeline()
  let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d %set :",
        \ &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
  let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
  call append(line("$"), l:modeline)
endfunction
nnoremap <silent> <Leader>l :call AppendModeline()<CR>

" Twiddle case by highlighting text and hitting ~
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

" fzf config.
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
command! -bang -nargs=? -complete=dir GFiles
    \ call fzf#vim#gitfiles(join([<q-args>, '--cached --others --exclude-standard'], ' '), fzf#vim#with_preview(), <bang>0)
" Use `:command Rg` to see current config
" Old command!
"command! -bang -nargs=* Rg
"  \ call fzf#vim#grep(
"  \   "rg --column --line-number --with-filename --no-heading --color=always --smart-case -- ".shellescape(<q-args>),
"  \   1,
"  \   fzf#vim#with_preview(),
"  \   <bang>0
"  \ )
"make :Rg from fzf.vim only search contents of files and not include the file names
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   "rg --column --line-number --with-filename --no-heading --color=always --smart-case ".shellescape(<q-args>),
  \   1,
  \   fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}),
  \   <bang>0
  \ )
" An action can be a reference to a function that processes selected lines
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" let g:ackhighlight = 1

" Source other files.
call SourceIfExists("~/.config/nvim/profile.vim")

" Thank you next please, from https://ctoomey.com/writing/using-vims-arglist-as-a-todo-list/
function! s:ThankYouNext() abort
  update
  argdelete %
  bdelete
  if !empty(argv())
    argument
  endif
endfunction
command! ThankYouNext call <sid>ThankYouNext()

" augroup BgHighlight
"   autocmd!
"   autocmd WinEnter * set cul
"   autocmd WinLeave * set nocul
" augroup END

]]
