-- Global mappings
vim.keymap.set("n", "<Leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ count = -1, float = true })
end)
vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ count = 1, float = true })
end)

vim.keymap.set("n", "<Leader>q", vim.diagnostic.setloclist)

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
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.go",
	callback = function()
		local params = vim.lsp.util.make_range_params(0, "utf-8")
		-- buf_request_sync defaults to a 1000ms timeout. Depending on your
		-- machine and codebase, you may want longer. Add an additional
		-- argument after params if you find that you have to write the file
		-- twice for changes to be saved.
		-- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
		local result = vim.lsp.buf_request_sync(
			0,
			"textDocument/codeAction",
			vim.tbl_deep_extend("error", params, { context = { only = { "source.organizeImports" } } })
		)
		for cid, res in pairs(result or {}) do
			for _, r in pairs(res.result or {}) do
				if r.edit then
					local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
					vim.lsp.util.apply_workspace_edit(r.edit, enc)
				end
			end
		end
		vim.lsp.buf.format({ async = false })
	end,
})

vim.api.nvim_create_user_command("LspRestart", function()
	local detach_clients = {}
	for _, client in ipairs(vim.lsp.get_clients()) do
		client:stop()
		if vim.tbl_count(client.attached_buffers) > 0 then
			detach_clients[client.name] = { client, vim.lsp.get_buffers_by_client_id(client.id) }
		end
	end
	local timer = assert(vim.uv.new_timer())
	timer:start(
		500,
		100,
		vim.schedule_wrap(function()
			for client_name, tuple in pairs(detach_clients) do
				local client, attached_buffers = unpack(tuple)
				if client.is_stopped() then
					for _, buf in pairs(attached_buffers) do
						vim.lsp.start(client.config, { bufnr = buf })
					end
					detach_clients[client_name] = nil
				end
			end
			if next(detach_clients) == nil and not timer:is_closing() then
				timer:close()
			end
		end)
	)
end, {
	desc = "Manually restart the given language client(s)",
	nargs = "?",
})

vim.api.nvim_create_user_command("LspStop", function()
	for _, client in ipairs(vim.lsp.get_clients()) do
		client:stop()
	end
end, {
	desc = "Manully stop language clients",
	nargs = "?",
})
