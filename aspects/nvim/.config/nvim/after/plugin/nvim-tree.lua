require("nvim-tree").setup({
	renderer = {
		icons = { show = { file = false, folder = false, git = false, modified = false } },
	},
	filters = { custom = { "^.git$" } },
	filesystem_watchers = {
		ignore_dirs = { 'node_modules/' },
	},
})

vim.keymap.set("n", "<Leader>t", ":NvimTreeToggle<CR>")
vim.keymap.set("n", "<Leader>T", ":NvimTreeFindFile<CR>")
