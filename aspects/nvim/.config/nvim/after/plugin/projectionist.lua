vim.g.projectionist_heuristics = {
	["*"] = {
		["*.gts"] = {
			["alternate"] = {"{}-provider.ts", "{}-provider.js"},
			["type"] = "template"
		},
		["*.gjs"] = {
			["alternate"] = {"{}-provider.ts", "{}-provider.js"},
			["type"] = "template"
		},
		["*-provider.ts"] = {
			["alternate"] = {"{}.gts", "{}.gjs"},
			["type"] = "provider"
		},
		["*-provider.js"] = {
			["alternate"] = {"{}.gjs", "{}.gts"},
			["type"] = "provider"
		},
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
