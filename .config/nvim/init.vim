"
" .vimrc file.
" Written by: Milo Gertjejansen
"

" Set the leader key to space.
let mapleader = " "

" Reload the config.
nnoremap <leader>ce :tabnew $MYVIMRC<CR>
nnoremap <leader>cs :so $MYVIMRC<CR>

" vim-plug
call plug#begin('~/.config/nvim/plugged')
  Plug 'tpope/vim-sensible'

  " Tool extensions
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'mhinz/vim-signify'
  Plug 'tpope/vim-fugitive'
  "Plug 'w0rp/ale'
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'benmills/vimux'
  Plug 'kana/vim-arpeggio', { 'on': 'Arpeggio' }
  Plug 'tpope/vim-obsession'
  Plug 'tpope/vim-unimpaired'
  Plug 'adelarsq/vim-matchit'
  Plug 'SirVer/ultisnips'
  Plug 'tpope/vim-vinegar'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}

  " Helpers
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'srcery-colors/srcery-vim'
  Plug 'pechorin/any-jump.vim'

  " Languages
    " CSS
    Plug 'gko/vim-coloresque'

    " Elm
    Plug 'elmcast/elm-vim', { 'for': 'elm' }
    Plug 'andys8/vim-elm-syntax', { 'for': 'elm' }

    " Python
    Plug 'python/black', { 'tag': '19.10b0', 'for': 'python' }
    Plug 'roxma/python-support.nvim', { 'for': 'python' }
    Plug 'vim-python/python-syntax', { 'for': 'python' }

    " Rust
    Plug 'rust-lang/rust.vim', { 'for': 'rust' }

    " JS
    Plug 'MaxMEllon/vim-jsx-pretty'
    Plug 'pangloss/vim-javascript'
    Plug 'digitaltoad/vim-pug'

    " Elixir
    Plug 'elixir-editors/vim-elixir'

    " Terraform
    Plug 'hashivim/vim-terraform'

    " Coffeescript
    Plug 'kchmck/vim-coffee-script'
call plug#end()

" AnyJump
let g:any_jump_search_prefered_engine = 'ag'
let g:any_jump_results_ui_style = 'filename_last'

" CoC.nvim
nmap <silent> <leader>aj <Plug>(coc-diagnostic-next)
nmap <silent> <leader>ak <Plug>(coc-diagnostic-prev)
"nnoremap <silent> <leader>agd :ALEGoToDefinition<CR>
"nnoremap <silent> <leader>agt :ALEGoToTypeDefinition<CR>
"nnoremap <silent> <leader>ah :ALEHover<CR>
"nnoremap <silent> <leader>af :ALEFindReferences<CR>


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
set termguicolors
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
set foldmethod=indent   " Fold based on indent.
set foldnestmax=10      " Deepest fold is 10 levels.
set nofoldenable        " Don't fold by default.
set foldlevel=1         " This is just what I use.

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
  let l:logger = printf("const fl = tag => logData => ( console.log(tag, logData), logData )")
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
set backspace=2

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

" Silver Searcher config
if executable('ag')
  let g:ackprg = 'ag --nogroup --nocolor --column --smart-case --hidden'
endif
nnoremap <Leader>/ :Ag<Space>
let g:ackhighlight = 1

" Fugitive aliases.
cnoreabbrev G vert<space>G
cnoreabbrev Gstatus vert<space>Gstatus

" GitGutter options.
set updatetime=10

" Netrw
noremap <silent> <C-n> :20Lex<CR>
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

" NetRanger stuff
"let g:NETRPreviewDefaultOn=v:false
"let g:NETRDefaultMapSkip = ['<cr>']
"let g:NETRToggleExpand = ['<cr>']
"let g:NETRBugPanelOpen = ['<cr>']
"function! NetRangerToggle()
  "topleft 40vsplit ./
"endfunction
"command! NetRangerToggle call NetRangerToggle()

" NerdTree colors
"function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
    "exec 'autocmd FileType nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
    "exec 'autocmd FileType nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
"endfunction

" NERDTree Key Binding (Plugin)
"noremap <C-n> :NERDTreeToggle<CR>
"noremap <C-n> :NetRangerToggle<CR>
let g:NETRDefaultMapSkip = ['l']
let g:NETRBufPanelOpen = ['l']
let NERDTreeShowHidden=1

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

" Vimux config.
let g:VimuxHeight = "25"
let g:VimuxOrientation = "h"
let g:VimuxUseNearest = 0
noremap <Leader>vp :VimuxPromptCommand<CR>
Arpeggio nmap <silent> vp :VimuxPromptCommand<CR>
noremap <Leader>vl :VimuxRunLastCommand<CR>
Arpeggio nmap <silent> vl :VimuxRunLastCommand<CR>
noremap <Leader>vz :VimuxZoomRunner<CR>

" UltiSnips config
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsEditSplit="vertical"

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

