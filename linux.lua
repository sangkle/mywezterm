local wezterm = require("wezterm")

local module = {}

function module.apply_to_config(config)
	config.default_prog = { "zsh", "-l" }
	config.font_size = 10
	config.line_height = 1.25
	config.font = wezterm.font_with_fallback({
		{ family = "FiraCode Nerd Font", scale = 1.00, weight = "Medium" },
		{ family = "D2Coding ligature", scale = 1.12, weight = "Medium" },
	})
end

return module
