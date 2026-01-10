-- Global mappings
vim.keymap.set("n", "<Leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ count = -1, float = true })
end)
vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ count = 1, float = true })
end)

vim.keymap.set("n", "<Leader>q", vim.diagnostic.setloclist)

vim.api.nvim_create_user_command("LspRestart", function()
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
		vim.lsp.stop_client(client.id)
	end
	vim.cmd("edit")
end, {})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function()
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition)
		vim.keymap.set("n", "K", vim.lsp.buf.hover)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
		vim.keymap.set("n", "gr", vim.lsp.buf.references)
		vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action)
		vim.keymap.set("n", "<Leader>cr", vim.lsp.buf.rename)
	end,
})

vim.lsp.enable({
	"tsgo",
	"glint",
	"gopls",
	"lua_ls",
	"rust_analyzer",
	"bash_ls",
})
