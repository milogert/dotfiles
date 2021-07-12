"
" .vimrc file.
" Written by: Milo Gertjejansen
"

" Load Arpeggio early?
packadd vim-arpeggio

" Set the leader key to space.
let mapleader = " "

" Reload the config.
nnoremap <leader>ce :tabnew $MYVIMRC<CR>
nnoremap <leader>cs :so $MYVIMRC<CR>

:set viminfo='1000,f1
":mark V $MYVIMRC

" Setup runtime path
set rtp+=/usr/local/bin/fzf

" AnyJump
let g:any_jump_search_prefered_engine = 'ag'
let g:any_jump_results_ui_style = 'filename_last'

" Opening new files
map gF :e <cfile><CR>

" Highlight the current line.
set cursorline

" CoC.nvim
nmap <silent> <leader>aj <Plug>(coc-diagnostic-next)
nmap <silent> <leader>ak <Plug>(coc-diagnostic-prev)
"nnoremap <silent> <leader>agd :ALEGoToDefinition<CR>
"nnoremap <silent> <leader>agt :ALEGoToTypeDefinition<CR>
"nnoremap <silent> <leader>ah :ALEHover<CR>
"nnoremap <silent> <leader>af :ALEFindReferences<CR>
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" ShaDa
set shada='50

" Splitting.
set splitbelow
set splitright

" Enable modelines.
set nocompatible
filetype on
filetype plugin on
filetype indent on
set modeline

" Enable syntax highlighting.
"colorscheme nofrils-dark
" True colors.
"set termguicolors
"set background=dark
set t_Co=256
colorscheme srcery

" Encoding.
set encoding=utf-8

" Set line numbers.
set number
set relativenumber
set list
set listchars=eol:$,tab:-->,trail:~,extends:>,precedes:<,space:·

" Setup proper tabs.
set expandtab
set tabstop=2 shiftwidth=2
set softtabstop=-1

" Searching.
set hlsearch
set incsearch
set ignorecase
set smartcase

" Other settings.
set hidden
set cmdheight=2
set updatetime=10
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Remap the arrow keys to do nothing.
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>

inoremap <Up> <nop>
inoremap <Down> <nop>
inoremap <Left> <nop>
inoremap <Right> <nop>

" Remap j/k to gj/gk but only when we are not counting.
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

" Folding.
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
"set foldmethod=indent   " Fold based on indent.
set foldnestmax=10      " Deepest fold is 10 levels.
set nofoldenable        " Don't fold by default.
"set foldlevel=1         " This is just what I use.

" Helpful remaps.
inoremap jj <Esc>
Arpeggio inoremap jk <Esc>

" Append modeline after last line in buffer.
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.
function! AppendModeline()
  let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d %set :",
        \ &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
  let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
  call append(line("$"), l:modeline)
endfunction
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>

" Functional logger.
function! AddFunctionalLogger()
  let l:logger = printf("const fl = tag => logData => ( console.log(`%s: ${tag}`, logData), logData )", expand('%:t'))
  call append(0, l:logger)
endfunction
nnoremap <silent> <Leader>fl :call AddFunctionalLogger()<CR>
function! AddConditionalFunctionalLogger()
  let l:logger = printf("const cfl = tag => predicate => logData => ( console.log(`CONDITION ${predicate(logData) ? '' : 'NOT '}MET: ${tag}`, logData) , logData )")
  call append(0, l:logger)
endfunction
nnoremap <silent> <Leader>cfl :call AddConditionalFunctionalLogger()<CR>

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

" Backspace.
set backspace=indent,eol,start

" Undo file to maintain undo's between runs.
set undodir=~/.config/nvim/undodir
set undofile

" y/p uses system clipboard now.
set clipboard+=unnamed

" Black location
let g:black_virtualenv = "~/.config/nvim/blackvenv"

" Python syntax
let g:python_highlight_all = 1

set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.snap     " MacOSX/Linux

" fzf config.
nnoremap <silent> <C-p> :GFiles <CR>
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
command! -bang -nargs=? -complete=dir GFiles
    \ call fzf#vim#gitfiles(join([<q-args>, '--cached --others --exclude-standard'], ' '), fzf#vim#with_preview(), <bang>0)
nnoremap <Leader>b :Buffer <CR>
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
command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)
nnoremap <Leader>/ :Rg<CR>
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

" Fugitive aliases.
cnoreabbrev G vert<space>G
cnoreabbrev Gstatus vert<space>Gstatus

" GitGutter options.

" Netrw
"noremap <silent> <C-n> :20Lex<CR>
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
"let g:netrw_winsize = 20
let g:netrw_preview = 1
let g:netrw_alto = 1
let g:netrw_altv = 1
"augroup ProjectDrawer
"  autocmd!
"  autocmd VimEnter * :Vexplore
"augroup END
function! NetRWFind()
  Lex %:p:h
endfunction
command! NetRWFind call NetRWFind()

" coc-explorer
nmap <Leader>e :CocCommand explorer<CR>

" Airline theme
let g:airline#extensions#ale#enabled = 1
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

" Vimux config.
let g:VimuxHeight = "25"
let g:VimuxOrientation = "h"
let g:VimuxUseNearest = 0
noremap <Leader>vp :VimuxPromptCommand<CR>
Arpeggio nmap <silent> vp :VimuxPromptCommand<CR>
noremap <Leader>vl :VimuxRunLastCommand<CR>
Arpeggio nmap <silent> vl :VimuxRunLastCommand<CR>
noremap <Leader>vz :VimuxZoomRunner<CR>
Arpeggio nmap <silent> vz :VimuxZoomRunner<CR>
noremap <Leader>vs :VimuxInterruptRunner<CR>
Arpeggio nmap <silent> vs :VimuxInterruptRunner<CR>

" UltiSnips config
"let g:UltiSnipsExpandTrigger="<tab>"
"let g:UltiSnipsJumpForwardTrigger="<c-b>"
"let g:UltiSnipsJumpBackwardTrigger="<c-z>"
"let g:UltiSnipsEditSplit="vertical"

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

" Profile functions.
source ~/.config/nvim/profile.vim

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

" Tmux config stuff
cnoreabbrev Mux !tmuxinator

" Run from an empty buffer
function! GetCommandFrequency()
  " Be sure to change viminfo path if you put yours elsewhere (like nvim's shada or my vim-cache).
  .! grep -e"^:"  ~/.viminfo
  %v/^:/d
  %sm/\v^:(silent|verb\w*) /:
  %sm,[ /].*
  %sm/^:..,../:
  %sm/^:%/:
  %g/\v^:?\s*$/d
  %sort
  %g/^:\W/d
  %! uniq -c
  %sort n
  " Ignore single use items
  %g/   1 :/d
  10,$-10delete
  0put ='Bottom (but more than once) usage:'
  10put ='Top usage:'
  $put ='out of total non-unique commands'
  $put =''
  $! grep -e"^:"  ~/.viminfo | wc -l
  " Indent for posting to reddit.
  exec "norm! gg0\<C-v>GI    "
endf

" Skeleton configs
autocmd FileType gitcommit 0r ~/.config/nvim/skeletons/gitcommit.skeleton

" nvim-treesitter config.
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  --ignore_install = { "javascript" }, -- List of parsers to ignore installing
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = {  -- list of language that will be disabled
    },
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },

}
EOF
