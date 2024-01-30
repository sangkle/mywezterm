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
config.enable_csi_u_key_encoding = false
config.enable_kitty_keyboard = false
config.use_dead_keys = false
config.debug_key_events = true
config.disable_default_key_bindings = true

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
local keybindings = require("keybindings")
config.keys = keybindings.create_keybinds()
config.key_tables = keybindings.key_tables
config.mouse_bindings = keybindings.mouse_bindings

-- config.debug_key_events = true

local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
-- you can put the rest of your Wezterm config here
smart_splits.apply_to_config(config, {
	-- the default config is here, if you'd like to use the default keys,
	-- you can omit this configuration table parameter and just use
	-- smart_splits.apply_to_config(config)

	-- directional keys to use in order of: left, down, up, right
	direction_keys = { "h", "j", "k", "l" },
	-- modifier keys to combine with direction_keys
	modifiers = {
		move = "CTRL", -- modifier to use for pane movement, e.g. CTRL+h to move left
		resize = "META", -- modifier to use for pane resize, e.g. META+h to resize to the left
	},
})
--
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
		direction = "Bottom",
		cwd = project_dir,
		size = 0.05,
	})
	-- editor_pane:send_text("nvim\n")
	-- local editor_pane2 = build_pane:split({
	-- 	direction = "Top",
	-- 	cwd = project_dir,
	-- 	size = 0.5,
	-- })
	-- editor_pane:send_text("nvim\n")

	local tab, pane, window = mux.spawn_window({
		workspace = "ing",
		-- args = { "ssh", "mini" },
	})
	-- pane:send_text("brew update && brew upgrade --greedy\n")
	mux.set_active_workspace("coding")
end)

-- wezterm.on("update-status", function(window, pane)
-- 	local mods, leds = window:keyboard_modifiers()
-- 	window:set_right_status("mods=" .. mods .. " leds=" .. leds)
-- end)
--
local session_manager = require("session-manager")
wezterm.on("save_session", function(window)
	session_manager.save_state(window)
end)
wezterm.on("load_session", function(window)
	session_manager.load_state(window)
end)
wezterm.on("restore_session", function(window)
	session_manager.restore_state(window)
end)

return config
