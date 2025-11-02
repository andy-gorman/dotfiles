return {
	cmd = { "bunx", "@typescript/native-preview", "--lsp", "--stdio" },
	filetypes = {
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},
	root_markers = { "tsconfig.base.json", "tsconfig.json", "jsconfig.json", "package.json" },
}
