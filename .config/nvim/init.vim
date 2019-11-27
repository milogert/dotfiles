"
" .vimrc file.
" Written by: Milo Gertjejansen
"

" Set the leader key to space.
let mapleader = " "

set background=dark

" vim-plug
call plug#begin('~/.config/nvim/plugged')
    " Tool extensions
    Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
    Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'airblade/vim-gitgutter'
    Plug 'mileszs/ack.vim'
    Plug 'tpope/vim-fugitive'
    Plug 'w0rp/ale'

    " Helpers
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'

    " Languages
    Plug 'elmcast/elm-vim'
    Plug 'python/black'
    Plug 'rust-lang/rust.vim'
    Plug 'roxma/python-support.nvim'
    Plug 'vim-python/python-syntax'
    Plug 'mxw/vim-jsx'
    Plug 'pangloss/vim-javascript'
    Plug 'leafgarland/typescript-vim'
    Plug 'digitaltoad/vim-pug'
call plug#end()


" ALE
let g:ale_completion_enabled = 1

" Splitting.
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
set splitbelow
set splitright

" Enable modelines.
set nocompatible
filetype plugin on
set modeline

" Enable syntax highlighting.
"colorscheme nofrils-dark

" Encoding.
set encoding=utf-8

" Set line numbers.
set number
set relativenumber

" Setup proper tabs.
set expandtab
set tabstop=4 shiftwidth=4
set softtabstop=4

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

function! AddFlogger()
  let l:flogger = printf("const fl = tag => logData => ( console.log(tag, logData), logData )")
  call append(0, l:flogger)
endfunction
nnoremap <silent> <Leader>fl :call AddFlogger()<CR>

" Special language stuff.
autocmd! BufNewFile,BufReadPre,FileReadPre Makefile source ~/.vim/langs/makefile.vim
autocmd BufWritePre *.py execute ':Black'
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2
autocmd BufNewFile,BufRead *.jsx,*.scss setlocal shiftwidth=2 tabstop=2


" Backspace.
set backspace=2

" Undo file to maintain undo's between runs.
set undodir=~/.config/nvim/undodir
set undofile

" y/p uses system clipboard now.
set clipboard+=unnamed

" True colors.
set termguicolors

" ALE nav to next errors
nmap <silent> <leader>ej :ALENext<cr>
nmap <silent> <leader>ek :ALEPrevious<cr>

" Black location
let g:black_virtualenv = "~/.config/nvim/blackvenv"

" Python syntax
let g:python_highlight_all = 1

" CtrlP config.
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" Silver Searcher config
if executable('ag')
    let g:ackprg = 'ag --vimgrep --smart-case'
endif
cnoreabbrev ag Ack!
cnoreabbrev aG Ack!
cnoreabbrev Ag Ack!
cnoreabbrev AG Ack!
nnoremap <Leader>a :Ack!<Space>

" NerdTree colors
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
    exec 'autocmd FileType nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
    exec 'autocmd FileType nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

call NERDTreeHighlightFile('jade', 'red', 'none', 'red', '#151515')
call NERDTreeHighlightFile('pug', 'red', 'none', 'red', '#151515')
call NERDTreeHighlightFile('html', 'red', 'none', 'red', '#151515')
call NERDTreeHighlightFile('md', 'magenta', 'none', 'gray', '#151515')
call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('less', 'brown', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('css', 'brown', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('js', 'darkgreen', 'none', 'darkgreen', '#151515')
call NERDTreeHighlightFile('jsx', 'darkgreen', 'none', 'darkgreen', '#151515')
call NERDTreeHighlightFile('rs', 'darkgreen', 'none', 'darkgreen', '#151515')
call NERDTreeHighlightFile('purs', 'darkgreen', 'none', 'darkgreen', '#151515')
call NERDTreeHighlightFile('elm', 'darkgreen', 'none', 'darkgreen', '#151515')
call NERDTreeHighlightFile('Dockerfile', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('yml', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('toml', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('acme', 'darkgreen', 'none', 'darkgreen', '#151515')
call NERDTreeHighlightFile('cpp', 'darkgreen', 'none', 'darkgreen', '#151515')
call NERDTreeHighlightFile('hpp', 'brown', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('Makefile', 'yellow', 'none', 'yellow', '#151515')

" NERDTree Key Binding (Plugin)
map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

" Airline theme
let g:airline_theme='dark'
let g:airline#extensions#default#section_truncate_width = {
  \ 'b': 128,
  \ 'x': 60,
  \ 'y': 88,
  \ 'z': 45,
  \ 'warning': 80,
  \ 'error': 80,
  \ }

