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
		["controller.js"] = {
			["alternate"] = "template.hbs",
			["type"] = "controller",
		},
		["controller.ts"] = {
			["alternate"] = "template.hbs",
			["type"] = "controller",
		},
		["template.hbs"] = {
			["alternate"] = { "route.ts", "route.js" },
			["type"] = "template",
		},
		["route.ts"] = {
			["alternate"] = { "controller.ts", "controller.js" },
			["type"] = "route",
		},
		["route.js"] = {
			["alternate"] = { "controller.ts", "controller.js" },
			["type"] = "route",
		},
	},
}
