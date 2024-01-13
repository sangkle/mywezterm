--- wezterm.lua
local wezterm = require("wezterm")
local mux = wezterm.mux
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
config.enable_scroll_bar = false
config.window_decorations = "RESIZE"
config.window_close_confirmation = "AlwaysPrompt"
config.scrollback_lines = 3000
config.default_workspace = "main"
-- config.color_scheme = "Catppuccin Mocha"
config.window_background_opacity = 0.94
config.inactive_pane_hsb = {
	saturation = 0.44,
	brightness = 1.0,
}
require("colorscheme").apply_to_config(config)

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

wezterm.on("gui-startup", function(cmd)
	local args = {}
	if cmd then
		args = cmd.args
	end

	local project_dir = wezterm.home_dir .. "/Herd"
	local tab, build_pane, window = mux.spawn_window({
		workspace = "coding",
		cmd = project_dir,
		args = args,
	})
	window:gui_window():maximize()
	local editor_pane = build_pane:split({
		direction = "Top",
		size = 0.9,
		cwd = project_dir,
	})
	editor_pane:send_text("nvim\n")

	local tab, pane, window = mux.spawn_window({
		workspace = "ing",
		args = { "ssh", "mini" },
	})
	pane:send_text("brew update && brew upgrade --greedy\n")
	mux.set_active_workspace("coding")
end)

return config
