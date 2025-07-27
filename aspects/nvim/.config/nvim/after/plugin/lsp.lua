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

local on_attach = function()
	local opts = { buffer = true }
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action, opts)
end

lspconfig.ts_ls.setup({
	init_options = {
		hostInfo = "neovim",
		maxTsServerMemory = 24576, -- Unhinged
	},
	on_attach = on_attach,
})
lspconfig.glint.setup({ on_attach = on_attach })
lspconfig.gopls.setup({ on_attach = on_attach })
lspconfig.eslint.setup({
	on_attach = function(_, bufnr)
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = bufnr,
			command = "EslintFixAll",
		})
		on_attach()
	end,
})

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

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
    -- buf_request_sync defaults to a 1000ms timeout. Depending on your
    -- machine and codebase, you may want longer. Add an additional
    -- argument after params if you find that you have to write the file
    -- twice for changes to be saved.
    -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format({async = false})
  end
})
