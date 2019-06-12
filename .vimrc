
" be iMproved, required
set nocompatible

filetype plugin indent on

set noerrorbells		" No Beeps
set number			" Show line numbers
set backspace=indent,eol,start	" Makes backspace key more powerful
set showcmd			" Show me what I'm typing
set showmode			" Show current mode

set noswapfile			" Don't use swapfile
set nobackup			" Don't create annoying backup files
set nowritebackup
set splitright			" Split vertical windows right to the current windows
set splitbelow			" Split horizontal windows below to the current windows
set encoding=utf-8		" Set default encoding to UTF-8
set autowrite			" Automatically save before :next, :make, etc.
set autoread			" Automatically reread changed files without asking me anything
set laststatus=2		" Show statusline
set hidden			" Hide buffer instead of closing

set ruler			" Show the cursor position all the time
au FocusLost * :wa		" Set vim to save the file on focus out.

set fileformats=unix,mac,dos	" Prefer Unix over OS 9 over Windows formats

set noshowmatch			" Do not show matching brackets by filckering
set incsearch			" Shows the match while typeing
set hlsearch 			" Highlight found searches
set ignorecase			" Search case insensitive...
set smartcase			" ... but not when search patterns contains upper case characters
set lazyredraw			" Wait to redraw

" speed up syntax highlighting
set nocursorcolumn
set nocursorline

" Tab settings
set tabstop=4
set expandtab
set shiftwidth=4
set softtabstop=4
imap jk <ESC>
syntax enable
