return {
	cmd = { "bunx", "@typescript/native-preview", "--lsp", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},
	root_markers = { "tsconfig.base.json", "tsconfig.json", "jsconfig.json", "package.json" },
}
