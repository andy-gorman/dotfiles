let mapleader = ","
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

set incsearch			" Shows the match while typeing
set hlsearch 			" Highlight found searches
set ignorecase			" Search case insensitive...
set smartcase			" ... but not when search patterns contains upper case characters
set lazyredraw			" Wait to redraw

" speed up syntax highlighting
set nocursorcolumn
set nocursorline
syntax enable

set showmatch " highlight matching brace/paren/etc.

" Tab settings
set tabstop=2
set shiftwidth=2
set softtabstop=2
set noexpandtab
set smartindent

" Dont add an eol character
set nofixeol

" Key mappings
imap jk <ESC>

let &t_SI = "\e[5 q" " Vertical bar on insert mode
let &t_EI = "\e[2 q" " Steady block on normal mode
autocmd VimEnter * silent !echo -ne "\e[2 q"
autocmd VimLeave * silent !echo -ne "\e[5 q"

" ctrl-p shortcuts
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_max_files=0
let g:ctrlp_max_depth=40
" Move splits
map <C-h> <C-W>h
map <C-l> <C-W>l
map <C-J> <C-W>j
map <C-K> <C-W>k

" NERDTree shortcut
map <c-b> :NERDTreeToggle<CR>
let g:NERDTreeWinSize=40

" Sensible Folding
set foldmethod=indent
set foldlevelstart=1 " Probably change this at some point, but this is teaching me to use folds

" Toggle fold at current position.
nnoremap <s-tab> za

" Projectionist mappings
let g:projectionist_heuristics = {
		\   '*': {
		\     '*.ts': {
		\				'alternate': '{}.hbs', 
		\       'type': 'controller',
		\     },
		\     '*.js': {
		\			  'alternate': '{}.hbs', 
		\       'type': 'controller',
		\     },
		\     '*.hbs': {
		\		    'alternate': ['{}.ts', '{}.js'],
		\				'type': 'template'
		\     }
		\   }
		\ }

" Airline settings
let g:airline_powerline_fonts = 1
let g:airline_theme = 'base16_tomorrow_night'


" use mouse
set mouse=a

" tab autocomplete options
set wildmenu
set wildmode=longest:full,full
set wildignore+=*/build/*,*/node_modules/*

" Colors
let base16_colorspace=256
if exists('$BASE16_THEME')
    \ && (!exists('g:colors_name')
    \ || g:colors_name != 'base16-$BASE16_THEME')
  let base16colorspace=256
  colorscheme base16-$BASE16_THEME
endif

" Copy / paste
set clipboard=unnamed
