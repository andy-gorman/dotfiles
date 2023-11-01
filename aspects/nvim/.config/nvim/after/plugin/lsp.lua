local lspconfig = require("lspconfig")

local on_attach = function()
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = true, silent = true })
	vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = true })
end

lspconfig.tsserver.setup({ on_attach = on_attach })
lspconfig.glint.setup({ on_attach = on_attach })
