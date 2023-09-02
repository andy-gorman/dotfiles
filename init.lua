vim.opt.number = true -- Show line numbers

vim.opt.splitright = true -- Split vertical windows right to the current windows
vim.opt.splitbelow = true -- Split horizontal windows below to the current windows
vim.opt.autowrite = true -- Automatically save before :next, :make, etc.
vim.opt.ignorecase = true -- Search case insensitive...
vim.opt.smartcase = true -- ... but not when search patterns contains upper case characters
vim.opt.showmatch = true -- highlight matching brace/paren/etc.
-- Folding options
vim.opt.foldmethod='indent'
vim.opt.foldlevelstart=1 -- Probably change this at some point, but this is teaching me to use folds

-- Tab settings
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = false
vim.opt.smartindent = true 

vim.opt.fixeol = true -- Dont add <EOL> at end of file

-- use mouse
vim.opt.mouse = 'a'

-- autocomplete options
vim.opt.wildmode = 'longest:full,full'
vim.opt.wildignore = vim.opt.wildignore + '*/build/*,*/node_modules/*'

-- Copy / paste
clipboard=unnamed

-- Escape Replacement
vim.api.nvim_set_keymap('i', 'jk', '<ESC>', {})

-- Move splits
vim.api.nvim_set_keymap('n', '<C-h>', '<C-W>h', {})
vim.api.nvim_set_keymap('n', '<C-l>', '<C-W>l', {})
vim.api.nvim_set_keymap('n', '<C-J>', '<C-W>j', {})
vim.api.nvim_set_keymap('n', '<C-K>', '<C-W>k', {})

-- Toggle fold at current position.
vim.api.nvim_set_keymap('', '<s-tab>', 'za', {noremap = true})

vim.api.nvim_create_autocmd('FocusLost', { pattern = "*", command = ':wa' })		-- Set vim to save the file on focus out.

-- Colors
--let base16_colorspace=256
--if exists('$BASE16_THEME')
--    \ && (!exists('g:colors_name')
--    \ || g:colors_name != 'base16-$BASE16_THEME')
--  let base16colorspace=256
--  colorscheme base16-$BASE16_THEME
--endif

-- ctrl-p shortcuts
-- let g:ctrlp_map = '<c-p>'
-- let g:ctrlp_cmd = 'CtrlP'
-- let g:ctrlp_working_path_mode = 'ra'
-- let g:ctrlp_max_files=0
-- let g:ctrlp_max_depth=40

-- NERDTree shortcut
-- map <c-b> :NERDTreeToggle<CR>
-- let g:NERDTreeWinSize=40

-- Projectionist mappings
-- let g:projectionist_heuristics = {
-- 		\   '*': {
-- 		\     '*.ts': {
-- 		\				'alternate': '{}.hbs', 
-- 		\       'type': 'controller',
-- 		\     },
-- 		\     '*.js': {
-- 		\			  'alternate': '{}.hbs', 
-- 		\       'type': 'controller',
-- 		\     },
-- 		\     '*.hbs': {
-- 		\		    'alternate': ['{}.ts', '{}.js'],
-- 		\				'type': 'template'
-- 		\     }
-- 		\   }
-- 		\ }

-- Airline settings
-- let g:airline_powerline_fonts = 1
-- let g:airline_theme = 'base16_tomorrow_night'

