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
    Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
        autocmd! User nerdtree echom 'NERDTree loaded!'
    Plug 'Xuyuanp/nerdtree-git-plugin'
    "Plug 'ryanoasis/vim-devicons'
    "Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
    "Plug 'ctrlpvim/ctrlp.vim'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'airblade/vim-gitgutter'
    "Plug 'mileszs/ack.vim'
    Plug 'tpope/vim-fugitive'
    Plug 'w0rp/ale'
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'benmills/vimux'
    Plug 'kana/vim-arpeggio', { 'on': 'Arpeggio' }
    Plug 'tpope/vim-obsession'
    Plug 'tpope/vim-unimpaired'
    Plug 'adelarsq/vim-matchit'

    " Helpers
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'srcery-colors/srcery-vim'
    Plug 'https://github.com/adelarsq/vim-matchit'
    "Plug 'camspiers/animate.vim'
    "Plug 'camspiers/lens.vim'
    Plug 'pechorin/any-jump.vim'

    " Languages
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
call plug#end()

" AnyJump
let g:any_jump_search_prefered_engine = 'ag'
let g:any_jump_results_ui_style = 'filename_last'

" ALE
let g:ale_completion_enabled = 1
let g:ale_lint_on_text_changed = 1
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_save = 1
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['eslint'],
\   'elm': ['elm_ls'],
\}
nnoremap <silent> <leader>aj :ALENext<CR>
nnoremap <silent> <leader>ak :ALEPrevious<CR>
nnoremap <silent> <leader>agd :ALEGoToDefinition<CR>
nnoremap <silent> <leader>agt :ALEGoToTypeDefinition<CR>
nnoremap <silent> <leader>ah :ALEHover<CR>
nnoremap <silent> <leader>af :ALEFindReferences<CR>
nnoremap <leader>ass :ALESymbolSearch<space>
"Arpeggio nnoremap <silent> aj :ALENext<CR>
"Arpeggio nnoremap <silent> ak :ALEPrevious<CR>

" Splitting.
set splitbelow
set splitright

" Enable modelines.
set nocompatible
filetype plugin on
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

" Special language stuff.
autocmd! BufNewFile,BufReadPre,FileReadPre Makefile source ~/.vim/langs/makefile.vim
autocmd BufWritePre *.py execute ':Black'

autocmd FileType eelixir,elixir,javascript,javascriptreact,sass,yaml setlocal shiftwidth=2 tabstop=2

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

" CtrlP config.
let g:ctrlp_user_command = [
    \ '.git',
    \ 'cd %s && git ls-files -co --exclude-standard',
    \ 'find . -type f -not -path "./.git/*" -not -path "./node_modules/*"'
    \ ]
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.snap     " MacOSX/Linux

" fzf config.
nnoremap <silent> <C-p> :GFiles <CR>
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
command! -bang -nargs=? -complete=dir GFiles
    \ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(), <bang>0)

" Silver Searcher config
if executable('ag')
    let g:ackprg = 'ag --nogroup --nocolor --column --smart-case --hidden'
endif
"cnoreabbrev ag Ack!
"cnoreabbrev aG Ack!
"cnoreabbrev Ag Ack!
"cnoreabbrev AG Ack!
"nnoremap <Leader>/ :Ack!<Space>
nnoremap <Leader>/ :Ag<Space>
let g:ackhighlight = 1

" Fugitive aliases.
cnoreabbrev G vert<space>G
cnoreabbrev Gstatus vert<space>Gstatus

" GitGutter options.
set updatetime=10

" NerdTree colors
"function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
    "exec 'autocmd FileType nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
    "exec 'autocmd FileType nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
"endfunction
"
"call NERDTreeHighlightFile('jade', 'red', 'none', 'red', '#151515')
"call NERDTreeHighlightFile('pug', 'red', 'none', 'red', '#151515')
"call NERDTreeHighlightFile('html', 'red', 'none', 'red', '#151515')
"call NERDTreeHighlightFile('md', 'magenta', 'none', 'gray', '#151515')
"call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
"call NERDTreeHighlightFile('less', 'brown', 'none', 'cyan', '#151515')
"call NERDTreeHighlightFile('css', 'brown', 'none', 'cyan', '#151515')
"call NERDTreeHighlightFile('js', 'darkgreen', 'none', 'darkgreen', '#151515')
"call NERDTreeHighlightFile('jsx', 'darkgreen', 'none', 'darkgreen', '#151515')
"call NERDTreeHighlightFile('rs', 'darkgreen', 'none', 'darkgreen', '#151515')
"call NERDTreeHighlightFile('purs', 'darkgreen', 'none', 'darkgreen', '#151515')
"call NERDTreeHighlightFile('elm', 'darkgreen', 'none', 'darkgreen', '#151515')
"call NERDTreeHighlightFile('Dockerfile', 'yellow', 'none', 'yellow', '#151515')
"call NERDTreeHighlightFile('yml', 'yellow', 'none', 'yellow', '#151515')
"call NERDTreeHighlightFile('toml', 'yellow', 'none', 'yellow', '#151515')
"call NERDTreeHighlightFile('acme', 'darkgreen', 'none', 'darkgreen', '#151515')
"call NERDTreeHighlightFile('cpp', 'darkgreen', 'none', 'darkgreen', '#151515')
"call NERDTreeHighlightFile('hpp', 'brown', 'none', 'cyan', '#151515')
"call NERDTreeHighlightFile('Makefile', 'yellow', 'none', 'yellow', '#151515')

" NERDTree Key Binding (Plugin)
noremap <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

" Airline theme
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
noremap <Leader>vp :VimuxPromptCommand<CR>
Arpeggio nmap <silent> vp :VimuxPromptCommand<CR>
noremap <Leader>vl :VimuxRunLastCommand<CR>
Arpeggio nmap <silent> vl :VimuxRunLastCommand<CR>
noremap <Leader>vz :VimuxZoomRunner<CR>
