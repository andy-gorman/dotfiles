require("nvim-tree").setup({
	renderer = {
		icons = { show = { file = false, folder = false, git = false, modified = false } },
	},
	filters = { custom = { "^.git$" } },
})

vim.keymap.set("n", "<Leader>t", ":NvimTreeToggle<CR>")
vim.keymap.set("n", "<Leader>T", ":NvimTreeFindFile<CR>")
