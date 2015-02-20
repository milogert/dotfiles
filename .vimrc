"
" .vimrc file.
" Written by: Milo Gertjejansen
"

" Enable syntax highlighting.
syntax enable

" Encoding.
set encoding=utf-8

" Set line numbers.
set nu

" Setup proper tabs.
set expandtab
set tabstop=2 shiftwidth=2
set softtabstop=2

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

" Folding.
set foldmethod=indent   " Fold based on indent.
set foldnestmax=10      " Deepest fold is 10 levels.
set nofoldenable        " Don't fold by default.
set foldlevel=1         " This is just what I use.

