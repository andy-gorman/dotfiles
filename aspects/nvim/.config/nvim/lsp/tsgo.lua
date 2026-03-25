-- Disabled for auditboard-frontend (uses glint instead)
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
	root_dir = function(bufnr, on_dir)
		-- Skip Ember projects (use glint instead)
		if vim.fs.root(bufnr, { "ember-cli-build.js", ".ember-cli" }) then
			return
		end
		local root = vim.fs.root(bufnr, { "tsconfig.base.json", "tsconfig.json", "jsconfig.json", "package.json" })
		if root then
			on_dir(root)
		end
	end,
	on_attach = function(client, bufnr)
		-- Format on save: LSP first, then Prettier
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = bufnr,
			callback = function()
				-- Step 1: LSP formatting (imports, auto-fixes, etc.)
				vim.lsp.buf.format({ async = false, bufnr = bufnr })

				-- Step 2: Prettier formatting (code style)
				local filepath = vim.api.nvim_buf_get_name(bufnr)
				local content = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n")
				local formatted = vim.fn.system("prettier --stdin-filepath " .. vim.fn.shellescape(filepath), content)

				if vim.v.shell_error == 0 then
					local lines = vim.split(formatted, "\n")
					if lines[#lines] == "" then
						table.remove(lines)
					end
					vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
				end
			end,
		})
	end,
}
