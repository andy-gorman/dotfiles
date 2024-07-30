local lspconfig = require("lspconfig")

-- Global mappings
vim.keymap.set("n", "<Leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<Leader>q", vim.diagnostic.setloclist)

local on_attach = function()
	local opts = { buffer = true }
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action, opts)
end

lspconfig.tsserver.setup({
	init_options = {
		maxTsServerMemory = 16384 -- Unhinged
	},
	on_attach = on_attach
})
lspconfig.glint.setup({ on_attach = on_attach })
lspconfig.rust_analyzer.setup({ on_attach = on_attach })

lspconfig.lua_ls.setup({
	on_attach = on_attach,
	settings = {
		Lua = {
			workspace = {
				-- Maybe I will set this to true at some point, but not necessary for my current lua usage
				checkThirdParty = false,
				-- Make the server aware of Neovim runtime files.
				library = vim.api.nvim_get_runtime_file("", true),
			},
		},
	},
})
