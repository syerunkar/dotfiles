set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'L9'
Plugin 'airblade/vim-gitgutter'
Plugin 'bling/vim-airline'
Plugin 'bronson/vim-trailing-whitespace'
Plugin 'ervandew/supertab'
Plugin 'godlygeek/tabular'
Plugin 'gregsexton/MatchTag'
Plugin 'gmarik/Vundle.vim'
Plugin 'junegunn/vim-easy-align'
Plugin 'kien/ctrlp.vim'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'mattn/emmet-vim'
Plugin 'othree/vim-autocomplpop'
Plugin 'Raimondi/delimitMate'
Plugin 'scrooloose/nerdtree.git'
Plugin 'scrooloose/syntastic'
Plugin 'skammer/vim-css-color'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-sleuth'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-commentary'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'majutsushi/tagbar'

" colorschemes
Plugin 'altercation/vim-colors-solarized'
Plugin 'chriskempson/base16-vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Colors setup
colorscheme solarized
set background=dark
let base16colorspace=256  " Access colors present in 256 colorspace

" Easymotion
hi link EasyMotionTarget ErrorMsg
hi link EasyMotionShade  Comment

" Relative numbers for vim 7.4+
" allows for quicker movement
set relativenumber
set number"

" Key bindings
vmap <Enter> <Plug>(EasyAlign)
nmap <Leader>a <Plug>(EasyAlign)
map <C-e> :NERDTreeToggle<CR>
map <C-t> :TagbarToggle<CR>

" Enable mousing
set mouse=a
set ttymouse=xterm
