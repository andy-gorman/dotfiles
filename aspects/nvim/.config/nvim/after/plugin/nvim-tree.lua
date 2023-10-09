require("nvim-tree").setup({
	renderer = {
		icons = { show = { file = false, folder = false, git = false, modified = false } },
	},
	filters = { custom = { "^.git$" } },
})
