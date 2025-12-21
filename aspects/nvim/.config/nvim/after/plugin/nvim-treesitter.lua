-- Languages to enable tree-sitter for
local languages = { 'lua', 'vim', 'vimdoc', 'typescript', 'javascript', 'python', 'rust', 'go' }

-- Install parsers (only needs to run once, or when adding new languages)
require('nvim-treesitter').install(languages)

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
