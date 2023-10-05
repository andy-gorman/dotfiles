local cycle_numbering = function()
	vim.wo.relativenumber = not vim.wo.relativenumber
end

vim.opt.splitright = true -- Split vertical windows right to the current windows
vim.opt.splitbelow = true -- Split horizontal windows below to the current windows
vim.opt.autowrite = true -- Automatically save before :next, :make, etc.
vim.opt.ignorecase = true -- Search case insensitive...
vim.opt.smartcase = true -- ... but not when search patterns contains upper case characters
vim.opt.showmatch = true -- highlight matching brace/paren/etc.
-- Folding options
vim.opt.foldmethod = "indent"
vim.opt.foldlevelstart = 1 -- Probably change this at some point, but this is teaching me to use folds

-- Tab settings
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = false
vim.opt.smartindent = true

vim.opt.fixeol = true -- Dont add <EOL> at end of file

-- use mouse
vim.opt.mouse = "a"

-- autocomplete options
vim.opt.wildmode = "longest:full,full"
vim.opt.wildignore = vim.opt.wildignore + "*/build/*,*/node_modules/*"

-- Copy / paste
vim.opt.clipboard = "unnamed"

-- Escape Replacement
vim.api.nvim_set_keymap("i", "jk", "<ESC>", {})

-- Move splits
vim.api.nvim_set_keymap("n", "<C-h>", "<C-W>h", {})
vim.api.nvim_set_keymap("n", "<C-l>", "<C-W>l", {})
vim.api.nvim_set_keymap("n", "<C-J>", "<C-W>j", {})
vim.api.nvim_set_keymap("n", "<C-K>", "<C-W>k", {})

-- Toggle fold at current position.
vim.api.nvim_set_keymap("", "<s-tab>", "za", { noremap = true })

vim.api.nvim_create_autocmd("FocusLost", { pattern = "*", command = ":wa" }) -- Set vim to save the file on focus out.

-- Colors
local set_theme_path = "$HOME/.config/tinted-theming/set_theme.lua"
local is_set_theme_file_readable = vim.fn.filereadable(vim.fn.expand(set_theme_path)) == 1 and true or false
if is_set_theme_file_readable then
	vim.cmd("let base16colorspace=256")
	vim.cmd("source" .. set_theme_path)
end

-- By default, show relative numbers
vim.wo.number = true
vim.wo.relativenumber = true

-- leader mappings
vim.g.mapleader = " "
vim.keymap.set("n", "<Leader>r", function()
	cycle_numbering()
end)
vim.keymap.set("n", "<Leader>n", ":noh<CR>")
vim.keymap.set("n", "<Leader>w", ":w")
