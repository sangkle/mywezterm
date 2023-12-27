--- wezterm.lua
--- $ figlet -f small Wezterm
--- __      __      _
--- \ \    / /__ __| |_ ___ _ _ _ __
---  \ \/\/ / -_)_ /  _/ -_) '_| '  \
---   \_/\_/\___/__|\__\___|_| |_|_|_|
---
--- My Wezterm config file

local wezterm = require("wezterm")
local act = wezterm.action

local config = {}
-- Use config builder object if possible
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Settings
local zsh_path = "/usr/bin/zsh"
config.default_prog = { zsh_path, "-l" }

config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font_with_fallback({
	{ family = "FiraCode Nerd Font", scale = 1.00, weight = "Medium" },
	{ family = "D2Coding ligature", scale = 1.12, weight = "Medium" },
})
config.font_size = 10
config.line_height = 1.25
config.use_dead_keys = false
config.window_background_opacity = 0.9
config.window_decorations = "RESIZE"
config.window_close_confirmation = "AlwaysPrompt"
config.scrollback_lines = 3000
config.default_workspace = "main"

-- Dim inactive panes
config.inactive_pane_hsb = {
	saturation = 0.44,
	brightness = 1.0,
}

config.colors = require("tabbar").colors

-- keys bindings
local keybindings = require("keybindings")
config.disable_default_key_bindings = true
config.keys = keybindings.create_keybinds()
config.key_tables = keybindings.key_tables
config.mouse_bindings = keybindings.mouse_bindings
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

-- Tab bar
config.use_fancy_tab_bar = false
config.status_update_interval = 1000
-- config.tab_bar_at_bottom = false
--
require("status")

return config
