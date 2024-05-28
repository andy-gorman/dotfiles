vim.opt.termguicolors = true
local set_theme_path = "$HOME/.config/tinted-theming/set_theme.lua"
local is_set_theme_file_readable = vim.fn.filereadable(vim.fn.expand(set_theme_path)) == 1
if is_set_theme_file_readable then
	-- vim.g.base16_colorspace = 256
	vim.cmd("source " .. set_theme_path)
end
