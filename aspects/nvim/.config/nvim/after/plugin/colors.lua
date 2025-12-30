vim.opt.termguicolors = true

local base24_theme = vim.env.BASE24_THEME
local base16_theme = vim.env.BASE16_THEME

local colorscheme
if base24_theme and base24_theme ~= "" then
	colorscheme = "base24-" .. base24_theme
elseif base16_theme and base16_theme ~= "" then
	colorscheme = "base16-" .. base16_theme
else
	vim.notify("No BASE24_THEME or BASE16_THEME set, skipping colorscheme", vim.log.levels.WARN)
	return
end

require("tinted-colorscheme").setup(colorscheme, {
	supports = {
		tinty = false,
		live_reload = false,
	},
})
