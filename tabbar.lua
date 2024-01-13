local wezterm = require("wezterm")
local M = {}

-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = wezterm.nerdfonts.cod_terminal_bash

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local edge_background = "#0b0022"
	local background = "#1b1032"
	local foreground = "#808080"

	if tab.is_active then
		background = "#216022"
		foreground = "#c0c0c0"
	elseif hover then
		background = "#3b3052"
		foreground = "#909090"
	end

	local edge_foreground = background

	local title = tab_title(tab)

	-- ensure that the titles fit in the available space,
	-- and that we have room for the edges.
	title = wezterm.truncate_right(title, max_width - 2)

	return {
		-- { Background = { Color = background } },
		-- { Foreground = { Color = foreground } },
		{ Text = " " .. SOLID_LEFT_ARROW .. " " },
		-- { Background = { Color = background } },
		-- { Foreground = { Color = foreground } },
		{ Text = title },
		-- { Background = { Color = background } },
		-- { Foreground = { Color = edge_foreground } },
		{ Text = " " },
	}
end)

-- wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
-- 	local zoomed = ""
-- 	if tab.active_pane.is_zoomed then
-- 		zoomed = "[Z] "
-- 	end
--
-- 	local index = ""
-- 	if #tabs > 1 then
-- 		index = string.format("[%d/%d] ", tab.tab_index + 1, #tabs)
-- 	end
--
-- 	return zoomed .. index .. tab.active_pane.title
-- end)

M.colors = {
	tab_bar = {
		background = "rgba(0 0 0 0.8)",
		active_tab = {
			bg_color = "rgba(10 100 20 0.8)",
			fg_color = "rgba(30 194 30 1)",
			intensity = "Normal",
			underline = "None",
			italic = false,
			strikethrough = false,
		},
		inactive_tab = {
			bg_color = "rgba(20 20 20 1.7)",
			fg_color = "#6060a0",
			italic = false,
		},
		inactive_tab_hover = {
			bg_color = "#3b3052",
			fg_color = "#909090",
			italic = true,
		},

		new_tab = {
			bg_color = "#1b1032",
			fg_color = "#808080",
		},

		new_tab_hover = {
			bg_color = "#3b3052",
			fg_color = "#909090",
			italic = true,
		},
	},
}

return M
