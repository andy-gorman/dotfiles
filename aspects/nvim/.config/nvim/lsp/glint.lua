-- Glint uses a hybrid architecture requiring typescript-language-server
-- with the @glint/tsserver-plugin for full functionality
-- Only enabled for auditboard-frontend

return {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = {
		"typescript",
		"javascript",
	},
	root_dir = function(bufnr, on_dir)
		-- Only attach to Ember projects
		if not vim.fs.root(bufnr, { "ember-cli-build.js", ".ember-cli" }) then
			return
		end
		local root = vim.fs.root(bufnr, { "tsconfig.json", ".glintrc.yml", ".glintrc", "package.json" })
		if root then
			on_dir(root)
		end
	end,
	before_init = function(params)
		local root_dir = params.rootPath
		local plugin_path = root_dir .. "/node_modules/@glint/tsserver-plugin"
		params.initializationOptions = {
			plugins = {
				{
					name = "@glint/tsserver-plugin",
					location = plugin_path,
				},
			},
		}
	end,
}
