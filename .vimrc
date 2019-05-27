set nocompatible
filetype off

"profile start /tmp/gitgutter.log
"profile! file */vim-gitgutter/*

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
    Bundle 'mattn/emmet-vim'
    Bundle 'airblade/vim-gitgutter'
    Bundle 'w0rp/ale'
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
set mouse=n
set number

" Persistent undo
if has("persistent_undo")
  let &undodir = expand("$HOME/.vim/undo")
  if !isdirectory(&undodir)
    call mkdir(&undodir, "p")
  endif
  set undofile
end

" Improved mouse functionality
if has("mouse_sgr")
  set ttymouse=sgr
else
  set ttymouse=xterm2
end

" Printer options
set printoptions=left:5pc,header:0

:au BufLeave,BufUnload,BufWinLeave ?* mkview
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

"omnifunc
set omnifunc=syntaxcomplete#Complete

"Slimv
"Declare the default leader so we can use it below
let g:slimv_leader = ','
"ctag support. (N) sets up NULL_GLOB so zsh doesn't complain
let g:slimv_ctags = '$HOMEBREW_ROOT/bin/ctags -a --language-force=lisp *.lisp(N) *.clj(N)' 
