vim.g.projectionist_heuristics = {
	["*"] = {
		["*.ts"] = {
			["alternate"] = "{}.hbs",
			["type"] = "controller",
		},
		["*.js"] = {
			["alternate"] = "{}.hbs",
			["type"] = "controller",
		},
		["*.hbs"] = {
			["alternate"] = { "{}.ts", "{}.js" },
			["type"] = "template",
		},
	},
}
