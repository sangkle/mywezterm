local wezterm = require("wezterm")

local module = {}

local custom = wezterm.color.get_builtin_schemes()["Catppuccin Mocha"]
custom.background = "#202020"
custom.tab_bar.background = "#040404"
custom.tab_bar.inactive_tab.bg_color = "#0f0f0f"
custom.tab_bar.new_tab.bg_color = "#080808"

function module.apply_to_config(config)
	config.color_schemes = {
		["OLEDppuccin"] = custom,
	}
	config.color_scheme = "OLEDppuccin"
end

return module
