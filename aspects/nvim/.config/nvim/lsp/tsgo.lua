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
