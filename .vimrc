set nocompatible
filetype off

" Setting up Vundle - the vim plugin bundler
    let iCanHazVundle=1
    let vundle_readme=expand('~/.vim/bundle/vundle/README.md')
    if !filereadable(vundle_readme)
        echo "Installing Vundle.."
        echo ""
        silent !mkdir -p ~/.vim/bundle
        silent !git clone https://github.com/gmarik/vundle ~/.vim/bundle/vundle
        let iCanHazVundle=0
    endif
    set rtp+=~/.vim/bundle/vundle/
    call vundle#rc()
    Bundle 'gmarik/vundle'
    "Add your bundles here
    Bundle 'tpope/vim-fugitive'
    Bundle 'ctrlpvim/ctrlp.vim'
    Bundle 'tpope/vim-surround'
    Bundle 'mattn/zencoding-vim'
    Bundle 'airblade/vim-gitgutter'
    Bundle 'scrooloose/syntastic'
    Bundle 'oranget/vim-csharp'
    Bundle 'kovisoft/slimv'
    "...All your other bundles...
    if iCanHazVundle == 0
        echo "Installing Bundles, please ignore key map error messages"
        echo ""
        :BundleInstall
    endif
" Setting up Vundle - the vim plugin bundler end

colorscheme zenburn
syntax on
filetype plugin indent on
runtime macros/matchit.vim

set expandtab
set softtabstop=2
set tabstop=2
set shiftwidth=2
set autoindent
set smartindent
set ignorecase
set smartcase
set incsearch
set backspace=indent,eol,start

:au BufWinLeave ?* mkview
:au BufWinEnter ?* silent loadview

:autocmd BufEnter *.thor,Gemfile,Rakefile,Cheffile set filetype=ruby
:autocmd BufEnter *.md set filetype=markdown
:autocmd BufEnter *.py set softtabstop=4 tabstop=4 shiftwidth=4 
:autocmd BufEnter *.pl set softtabstop=4 tabstop=4 shiftwidth=4 
:autocmd BufEnter *.html,*.htm set softtabstop=4 tabstop=4 shiftwidth=4 
:autocmd BufEnter *.css,*.scss set softtabstop=4 tabstop=4 shiftwidth=4 
:autocmd BufEnter *.php set softtabstop=4 tabstop=4 shiftwidth=4 

"Move between windows easier
map <C-J> <C-W>j
map <C-H> <C-W>h
map <C-K> <C-W>k
map <C-L> <C-W>l

"vim-slime
let g:slime_target = "tmux"
