-- Languages to enable tree-sitter for
local languages = { 'lua', 'vim', 'vimdoc', 'typescript', 'javascript', 'python', 'rust', 'go', 'bash' }

-- Update parsers if needed (silently checks and only updates outdated parsers)
require('nvim-treesitter').update(languages)

-- Enable tree-sitter highlighting and indentation for specified languages
vim.api.nvim_create_autocmd('FileType', {
  pattern = vim.list_extend(vim.deepcopy(languages), { 'typescriptreact', 'javascriptreact' }),
  callback = function()
    vim.treesitter.start()
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
	vim.wo[0][0].foldmethod = 'expr'
  end,
})

-- Command to list installed parsers
vim.api.nvim_create_user_command('TSInstalled', function()
  local installed = require('nvim-treesitter').get_installed()
  table.sort(installed)
  print('Installed parsers: ' .. table.concat(installed, ', '))
end, {})

-- Command to install configured languages
vim.api.nvim_create_user_command('TSInstallConfigured', function()
  require('nvim-treesitter').install(languages)
end, {})
