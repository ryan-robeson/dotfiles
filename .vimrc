if &compatible
  " Only cause side effects when necessary
  set nocompatible
endif

colorscheme zenburn
syntax on
filetype plugin indent on

if has("packages")
  packadd! matchit
else
  runtime macros/matchit.vim
endif

set autoindent
set backspace=indent,eol,start
set expandtab
set ignorecase
set incsearch
set mouse=n
set number
set shiftwidth=0 " Use value of 'tabstop'
set smartcase
set smartindent
set softtabstop=-1 " Use value of 'shiftwidth'
set tabstop=2
set wildmenu

" Increase viminfo registry limits
" See: help 'viminfo
" Marks = 100
" register lines = <1000
" register max size = 100kb
" don't restore search highlighting
set viminfo='100,<1000,s100,h

highlight IncSearch ctermfg=28 ctermbg=254
highlight NonText   ctermfg=123

" Highlight trailing whitespace automatically
highlight TrailingWhitespace ctermbg=red guibg=red
call matchadd("TrailingWhitespace", '\s\+$')

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

au BufWinLeave ?* mkview
au BufWinEnter ?* silent loadview

autocmd BufEnter *.thor,Gemfile,Rakefile,Cheffile set filetype=ruby
autocmd BufEnter *.md set filetype=markdown
autocmd BufEnter *.py set softtabstop=4 tabstop=4 shiftwidth=4
autocmd BufEnter *.pl set softtabstop=4 tabstop=4 shiftwidth=4
autocmd BufEnter *.html,*.htm set softtabstop=4 tabstop=4 shiftwidth=4
autocmd BufEnter *.css,*.scss set softtabstop=4 tabstop=4 shiftwidth=4
autocmd BufEnter *.php set softtabstop=4 tabstop=4 shiftwidth=4

autocmd FileType ruby setlocal formatoptions-=o formatoptions+=j

"Move between windows easier
map <C-J> <C-W>j
map <C-H> <C-W>h
map <C-K> <C-W>k
map <C-L> <C-W>l

" Save file and execute previous command in right tmux pane
nnoremap \q :w<CR>:silent call system('tmux send-keys -t right C-p C-j') <CR>

"omnifunc
set omnifunc=syntaxcomplete#Complete

"Slimv
"Declare the default leader so we can use it below
let g:slimv_leader = ','
"ctag support. (N) sets up NULL_GLOB so zsh doesn't complain
let g:slimv_ctags = '$HOMEBREW_ROOT/bin/ctags -a --language-force=lisp *.lisp(N) *.clj(N)'
