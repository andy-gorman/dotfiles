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

-- Format-on-save. `actions` are code action kinds applied before formatting;
-- `format` opts the server's textDocument/formatting in. Servers absent from
-- this table are left alone on save -- deliberately an allowlist rather than a
-- `supports_method("textDocument/formatting")` check, since lua_ls advertises
-- formatting and we format Lua with stylua via bin/format instead.
local on_save = {
	gopls = { actions = { "source.organizeImports" }, format = true },
	tsgo = { actions = { "source.organizeImports" }, format = true },
	oxlint = { actions = { "source.fixAll.oxc" } },
	oxfmt = { format = true },
}

-- Exactly one server formats a given buffer. When several attached servers can,
-- the earliest name here wins: oxfmt is a superset of tsgo's whitespace-only
-- formatting, so it takes over in repos that opt into it with an oxfmt config.
-- A format-capable server missing from this list still runs, just unordered.
local format_precedence = { "oxfmt", "tsgo", "gopls" }

-- oxlint only returns source.fixAll.oxc when the requested range spans the
-- diagnostics it wants to fix, so always ask for the whole buffer.
local function buf_range(bufnr)
	local last = vim.api.nvim_buf_line_count(bufnr) - 1
	local last_line = vim.api.nvim_buf_get_lines(bufnr, last, last + 1, false)[1] or ""
	return { start = { line = 0, character = 0 }, ["end"] = { line = last, character = #last_line } }
end

vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup("my.lsp.format", {}),
	callback = function(ev)
		local can_format = {}

		-- Code actions first, so formatting normalizes whatever they emit.
		for _, client in ipairs(vim.lsp.get_clients({ bufnr = ev.buf })) do
			local spec = on_save[client.name]
			if spec then
				if spec.format then
					can_format[client.name] = true
				end
				for _, kind in ipairs(spec.actions or {}) do
					local res = client:request_sync("textDocument/codeAction", {
						textDocument = vim.lsp.util.make_text_document_params(ev.buf),
						range = buf_range(ev.buf),
						context = { only = { kind }, diagnostics = {} },
					}, 3000, ev.buf)
					for _, action in ipairs(res and res.result or {}) do
						if action.edit then
							vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
						end
					end
				end
			end
		end

		for _, name in ipairs(format_precedence) do
			if can_format[name] then
				vim.lsp.buf.format({ async = false, bufnr = ev.buf, name = name })
				return
			end
		end
		local unranked = next(can_format)
		if unranked then
			vim.lsp.buf.format({ async = false, bufnr = ev.buf, name = unranked })
		end
	end,
})

vim.lsp.enable({
	"tsgo",
	"glint",
	"gopls",
	"lua_ls",
	"oxfmt",
	"oxlint",
	"rust_analyzer",
	"bash_ls",
})
