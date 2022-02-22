"
" .vimrc file.
" Written by: Milo Gertjejansen
"

" Function to source only if file exists.
function! SourceIfExists(file)
  if filereadable(expand(a:file))
    exe 'source' a:file
  else
    echo "Could not source " . a:file
  endif
endfunction

" Set the leader key. This should be first.
call SourceIfExists("~/.config/nvim/settings.lua")

lua require('impatient')

" Load Arpeggio early.
packadd vimplugin-vim-arpeggio

" Helpful remaps.

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

" Silver Searcher config
"if executable('rg')
  "let g:ackprg = 'rg --nogroup --nocolor --column --smart-case --hidden'
"endif
let g:ackhighlight = 1

" Airline theme
let g:airline#extensions#coc#enabled = 1
let g:airline_theme='srcery'
let g:airline#extensions#default#section_truncate_width = {
  \ 'b': 128,
  \ 'x': 60,
  \ 'y': 88,
  \ 'z': 45,
  \ 'warning': 80,
  \ 'error': 80,
  \ }
let g:airline_section_y = ''

" Pretty print json
function! PrettyPrintJsonFile()
  %!python -m json.tool
endfunction
command! -range PrettyPrintJsonFile call PrettyPrintJsonFile()
nnoremap <silent> <Leader>ppj :PrettyPrintJsonFile<CR>
"function! PrettyPrintJsonRange()
"  '<,'>!python -m json.tool
"endfunction
"command! -range PrettyPrintJsonRange call PrettyPrintJsonRange()
"vnoremap <silent> <Leader>ppj :PrettyPrintJsonRange<CR>

" Source other files.
" call SourceIfExists("~/.config/nvim/alpha-nvim.lua")
call SourceIfExists("~/.config/nvim/cmp.lua")
call SourceIfExists("~/.config/nvim/keybindings.lua")
call SourceIfExists("~/.config/nvim/lsp.lua")
call SourceIfExists("~/.config/nvim/luasnip.lua")
call SourceIfExists("~/.config/nvim/package-info.lua")
call SourceIfExists("~/.config/nvim/persistence.lua")
call SourceIfExists("~/.config/nvim/playground.vim")
call SourceIfExists("~/.config/nvim/priv.vim")
call SourceIfExists("~/.config/nvim/profile.vim")
" call SourceIfExists("~/.config/nvim/telescope.lua")
call SourceIfExists("~/.config/nvim/treesitter.lua")
call SourceIfExists("~/.config/nvim/which-key.lua")

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
