--- wezterm.lua
local wezterm = require("wezterm")
local act = wezterm.action

local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Settings
if wezterm.target_triple == "aarch64-apple-darwin" then
	require("apple").apply_to_config(config)
elseif wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.default_prog = { "powershell.exe", "-NoLogo", "-NoProfile" }
else
	require("linux").apply_to_config(config)
end

config.window_decorations = "RESIZE"
config.window_close_confirmation = "AlwaysPrompt"
config.scrollback_lines = 3000
config.default_workspace = "main"
config.color_scheme = "Catppuccin Mocha"
config.window_background_opacity = 0.9
config.inactive_pane_hsb = {
	saturation = 0.44,
	brightness = 1.0,
}

-- Keys bindings
config.use_dead_keys = false
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
local keybindings = require("keybindings")
config.disable_default_key_bindings = true
config.keys = keybindings.create_keybinds()
config.key_tables = keybindings.key_tables
config.mouse_bindings = keybindings.mouse_bindings

-- Tab bar
config.colors = require("tabbar").colors
config.use_fancy_tab_bar = false
config.status_update_interval = 1000
config.tab_bar_at_bottom = false
require("status")

return config
