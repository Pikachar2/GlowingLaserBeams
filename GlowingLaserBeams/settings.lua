data:extend(
{
	{
		type = "bool-setting",
		name = "laserfix-doubletint",
		setting_type = "startup",
		default_value = true,
		order = "a",
		per_user = false,
	},
	{
		type = "string-setting",
		name = "laserfix-color",
		setting_type = "startup",
		default_value = "Custom",
		allowed_values = {"Custom", "Disco"},
		order = "a0",
		per_user = false,
	},
	{
		type = "color-setting",
		name = "laserfix-core-color",
		setting_type = "startup",
		default_value = {r = 255, g = 0, b = 0},
		order = "a2",
		per_user = false,
	},
	{
		type = "color-setting",
		name = "laserfix-glow-color",
		setting_type = "startup",
		default_value = {r = 128, g = 13, b = 13},
		order = "a3",
		per_user = false,
	},
})
