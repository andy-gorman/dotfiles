vim.opt.termguicolors = true

-- Set colorscheme based on BASE16_THEME environment variable
local base16_theme = vim.env.BASE16_THEME or "nord"
local colorscheme = "base16-" .. base16_theme

require("tinted-colorscheme").setup(colorscheme, {
	supports = {
		tinty = false,
		live_reload = false,
	},
})
