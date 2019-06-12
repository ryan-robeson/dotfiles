if &compatible
  " Only cause side effects when necessary
  set nocompatible
endif

" Packages
" Plugin 'airblade/vim-gitgutter'
" Plugin 'ctrlpvim/ctrlp.vim'
" Plugin 'kovisoft/slimv'
" Plugin 'mattn/emmet-vim'
" Plugin 'oranget/vim-csharp'
" Plugin 'tpope/vim-fugitive'
" Plugin 'tpope/vim-surround'
" Plugin 'w0rp/ale'
" END Packages

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

" GitGutter started using colorscheme Diff* highlight settings.
" ctermbg and guibg come from `:hi LineNr`. SignColumn links to LineNr and is
" therefore overridden.
" ctermfg and guifg come from the GitGutter readme.
highlight GitGutterAdd    ctermfg=2 ctermbg=238 guifg=#009900 guibg=#262626
highlight GitGutterChange ctermfg=3 ctermbg=238 guifg=#bbbb00 guibg=#262626
highlight GitGutterDelete ctermfg=1 ctermbg=238 guifg=#ff2222 guibg=#262626

" Highlight trailing whitespace automatically
highlight TrailingWhitespace ctermbg=red guibg=red

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

augroup custom_highlighting
  au!
  au BufEnter * call matchadd("TrailingWhitespace", '\s\+$')
augroup END

augroup persist_views
  au!
  au BufWinLeave ?* mkview
  au BufWinEnter ?* silent loadview
augroup END

augroup filetypes
  au!
  autocmd BufEnter *.thor,Gemfile,Rakefile,Cheffile set filetype=ruby
  autocmd BufEnter *.md set filetype=markdown

  autocmd FileType ruby setlocal formatoptions-=o formatoptions+=j
  autocmd FileType markdown,python set tabstop=4
augroup END

"Move between windows easier
map <C-J> <C-W>j
map <C-H> <C-W>h
map <C-K> <C-W>k
map <C-L> <C-W>l

" Save file and execute previous command in right tmux pane
nnoremap \q :w<CR>:silent call system('tmux send-keys -t right C-p C-j') <CR>

" Package Management
if has('job')
  command! VipackInstall call VipackAsync('install')
  command! VipackUpdate call VipackAsync('update')
else
  command! VipackInstall vsplit __VipackInstall__ <BAR> setlocal buftype=nofile <BAR> let result=system('vipack install') <BAR> call append(0, split(result, '\v\n'))
  command! VipackUpdate vsplit __VipackUpdate__ <BAR> setlocal buftype=nofile <BAR> let result=system('vipack update') <BAR> call append(0, split(result, '\v\n'))
endif

" Inspired by:
" http://www.patternweld.com/code/2016/10/20/running-tests-asynchronously-in-vim.html
function! VipackAsync(action)
  let script = 'vipack '. a:action
  let outname = '__Vipack ' . a:action . '__'
  let options = { 'in_io': 'null', 'out_io': 'buffer', 'out_name': outname }

  let job = job_start(script, options)

  " Only split when necessary
  " See: https://stackoverflow.com/a/6640380
  let bufnum = bufnr(outname)
  let winnum = bufwinnr(bufnum)
  if winnum == -1
    " Open a vertical split for the output
    execute 'vertical sbuf ' . outname
  else
    " Jump to the existing split
    execute winnum . "wincmd w"
  endif

  " Clear the buffer
  normal ggdG
  " Make sure the buffer is treated like a Scratch buffer
  setlocal nobuflisted
  setlocal bufhidden=hide
  setlocal buftype=nofile
  setlocal noswapfile
  " Set the width of the split
  vertical resize 45
endfunction

"omnifunc
set omnifunc=syntaxcomplete#Complete

"Slimv
"Declare the default leader so we can use it below
let g:slimv_leader = ','
"ctag support. (N) sets up NULL_GLOB so zsh doesn't complain
let g:slimv_ctags = '$HOMEBREW_ROOT/bin/ctags -a --language-force=lisp *.lisp(N) *.clj(N)'
