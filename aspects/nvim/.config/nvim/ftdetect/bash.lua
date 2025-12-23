-- Detect bash files with custom shebang patterns
vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile'}, {
  callback = function()
    local first_line = vim.fn.getline(1)
    -- Match #!/usr/bin/env/ bash (with extra slash)
    if first_line:match('^#!/usr/bin/env/ bash') then
      vim.bo.filetype = 'bash'
    end
  end,
})
