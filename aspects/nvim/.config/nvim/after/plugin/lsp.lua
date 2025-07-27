local lspconfig = require("lspconfig")

-- Global mappings
vim.keymap.set("n", "<Leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ count = -1, float = true })
end)
vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ count = 1, float = true })
end)

vim.keymap.set("n", "<Leader>q", vim.diagnostic.setloclist)

vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
vim.keymap.set("n", "gr", vim.lsp.buf.references)
vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action)

-- lspconfig.glint.setup({ on_attach = on_attach })

lspconfig.rust_analyzer.setup({})

lspconfig.lua_ls.setup({
	settings = {
		Lua = {
			workspace = {
				-- Maybe I will set this to true at some point, but not necessary for my current lua usage
				checkThirdParty = false,
				-- Make the server aware of Neovim runtime files.
				 library = {
          vim.env.VIMRUNTIME
          -- Depending on the usage, you might want to add additional paths
          -- here.
          -- '${3rd}/luv/library'
          -- '${3rd}/busted/library'
        }
			},
		},
	},
})

vim.lsp.enable('tsgo')
