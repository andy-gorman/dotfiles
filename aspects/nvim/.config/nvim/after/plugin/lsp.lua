local lspconfig = require("lspconfig")

local on_attach = function()
	vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { buffer = true, silent = true })
end

lspconfig.tsserver.setup({ on_attach = on_attach })
lspconfig.glint.setup({ on_attach = on_attach })
