" Configuration file for vim
set modelines=0		" CVE-2007-2438

" Normally we use vim-extensions. If you want true vi-compatibility
" remove change the following statements
set nocompatible	" Use Vim defaults instead of 100% vi compatibility
set backspace=2		" more powerful backspacing

" Don't write backup file if vim is being called by "crontab -e"
au BufWrite /private/tmp/crontab.* set nowritebackup
" Don't write backup file if vim is being called by "chpass"
au BufWrite /private/etc/pw.* set nowritebackup

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
set background=dark

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif
endif

" Uncomment the following to have Vim load indentation rules according to the
" detected filetype. Per default Debian Vim only load filetype specific
" plugins.
if has("autocmd")
  filetype indent on
endif

if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

filetype plugin on

if &term=="xterm"
     set t_Co=8
     set t_Sb=[4%dm
     set t_Sf=[3%dm
endif

" colorscheme torte
" au GUIEnter * simalt ~x
filetype indent on
set autoindent
set cindent shiftwidth=4
set nu
set tabstop=4
set nobackup
" set ignorecase
" set foldmethod=marker
" set guifont=Monospace\ 16

set showcmd			" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set incsearch		" Incremental search
"set autowrite		" Automatically save before commands like :next and :make
"set hidden             " Hide buffers when they are abandoned
set mouse=a		" Enable mouse usage (all modes) in terminals
"set ttymouse=xterm2
"behave xterm
"set selectmode=mouse
"set paste
set nowrap
set wildmode=longest,list
set clipboard=unnamed
syntax sync minlines=200
au BufNewFile,BufRead *.nut setf squirrel

map <Left> gT
map <Right> gt
imap <Left> <ESC>gT
imap <Right> <ESC>gt
map <F7> :.w !pbcopy<CR><CR>
vmap <F7> :w !pbcopy<CR><CR>
