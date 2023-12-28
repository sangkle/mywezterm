local wezterm = require("wezterm")

local color = (function()
	local COLOR = require("colors")

	local coolors = {
		COLOR.VERIDIAN,
		COLOR.PAYNE,
		COLOR.INDIGO,
		COLOR.CAROLINA,
		COLOR.FLAME,
		COLOR.JET,
		COLOR.TAUPE,
		COLOR.ECRU,
		COLOR.VIOLET,
		COLOR.VERDIGRIS,
	}

	return coolors[math.random(#coolors)]
end)()

local color_primary = color

local title_color_bg = color_primary.bg
local title_color_fg = color_primary.fg

local color_off = title_color_bg:lighten(0.4)
local color_on = color_off:lighten(0.4)
wezterm.on("update-right-status", function(window)
	local bat = ""
	local b = wezterm.battery_info()[1]
	bat = wezterm.format({
		{ Foreground = {
			Color = b.state_of_charge > 0.2 and color_on or color_off,
		} },
		{ Text = "▉" },
		{ Foreground = {
			Color = b.state_of_charge > 0.4 and color_on or color_off,
		} },
		{ Text = "▉" },
		{ Foreground = {
			Color = b.state_of_charge > 0.6 and color_on or color_off,
		} },
		{ Text = "▉" },
		{ Foreground = {
			Color = b.state_of_charge > 0.8 and color_on or color_off,
		} },
		{ Text = "▉" },
		{ Background = {
			Color = b.state_of_charge > 0.98 and color_on or color_off,
		} },
		{
			Foreground = {
				Color = b.state == "Charging" and color_on:lighten(0.3):complement()
					or (b.state_of_charge < 0.2 and wezterm.GLOBAL.count % 2 == 0) and color_on
						:lighten(0.1)
						:complement()
					or color_off:darken(0.1),
			},
		},
		{ Text = " ⚡ " },
	})

	local time = wezterm.strftime("%-l:%M %P")

	local bg1 = title_color_bg:lighten(0.1)
	local bg2 = title_color_bg:lighten(0.2)

	window:set_right_status(wezterm.format({
		{ Background = { Color = title_color_bg } },
		{ Foreground = { Color = bg1 } },
		{ Text = "" },
		{ Background = { Color = title_color_bg:lighten(0.1) } },
		{ Foreground = { Color = title_color_fg } },
		{ Text = " " .. window:active_workspace() .. " " },
		{ Foreground = { Color = bg1 } },
		{ Background = { Color = bg2 } },
		{ Text = "" },
		{ Foreground = { Color = title_color_bg:lighten(0.4) } },
		{ Foreground = { Color = title_color_fg } },
		{ Text = " " .. time .. " " .. bat },
	}))
end)

wezterm.on("gui-startup", function(cmd)
	local mux = wezterm.mux

	local padSize = 80
	local screenWidth = 2560
	local screenHeight = 1600

	local tab, pane, window = mux.spawn_window(cmd or {
		workspace = "main",
	})

	local icons = {
		"🌞",
		"🍧",
		"🫠",
		"🏞️",
		"📑",
		"🪁",
		"🧠",
		"🦥",
		"🦉",
		"📀",
		"🌮",
		"🍜",
		"🧋",
		"🥝",
		"🍊",
	}

	tab:set_title("  " .. icons[math.random(#icons)] .. "  ")

	if window ~= nil then
		window:gui_window():set_position(padSize, padSize)
		window:gui_window():set_inner_size(screenWidth - (padSize * 2), screenHeight - (padSize * 2) - 48)
	end
end)

local TAB_EDGE_LEFT = wezterm.nerdfonts.ple_left_half_circle_thick
local TAB_EDGE_RIGHT = wezterm.nerdfonts.ple_right_half_circle_thick

local function tab_title(tab_info)
	local title = tab_info.tab_title

	if title and #title > 0 then
		return title
	end

	return tab_info.active_pane.title:gsub("%.exe", "")
end

wezterm.on("format-tab-title", function(tab, _, _, _, hover, max_width)
	local edge_background = title_color_bg
	local background = title_color_bg:lighten(0.05)
	local foreground = title_color_fg

	if tab.is_active then
		background = background:lighten(0.1)
		foreground = foreground:lighten(0.1)
	elseif hover then
		background = background:lighten(0.2)
		foreground = foreground:lighten(0.2)
	end

	local edge_foreground = background

	local title = tab_title(tab)

	-- ensure that the titles fit in the available space,
	-- and that we have room for the edges.
	title = wezterm.truncate_right(title, max_width - 2)

	return {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = TAB_EDGE_LEFT },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = TAB_EDGE_RIGHT },
	}
end)

return {
	window_decorations = "RESIZE",
	-- win32_system_backdrop = "Acrylic",
	macos_window_background_blur = 20,
	show_tab_index_in_tab_bar = false,
	show_new_tab_button_in_tab_bar = false,

	window_frame = {
		-- The font used in the tab bar.
		-- Roboto Bold is the default; this font is bundled
		-- with wezterm.
		-- Whatever font is selected here, it will have the
		-- main font setting appended to it to pick up any
		-- fallback fonts you may have used there.
		font = wezterm.font({ family = "Roboto", weight = "Bold" }),

		-- The size of the font in the tab bar.
		-- Default to 10.0 on Windows but 12.0 on other systems
		font_size = 12.0,

		-- The overall background color of the tab bar when
		-- the window is focused
		active_titlebar_bg = "#333333",

		-- The overall background color of the tab bar when
		-- the window is not focused
		inactive_titlebar_bg = "#333333",
	},

	colors = {
		tab_bar = {
			-- The color of the inactive tab bar edge/divider
			inactive_tab_edge = "#575757",
		},
	},
}
