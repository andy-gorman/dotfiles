local lspconfig = require("lspconfig")

-- Global mappings
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

local on_attach = function()
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = true, silent = true })
	vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = true })
end

lspconfig.tsserver.setup({ on_attach = on_attach })
lspconfig.glint.setup({ on_attach = on_attach })
lspconfig.lua_ls.setup({ on_attach = on_attach})
