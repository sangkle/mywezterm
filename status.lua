local wezterm = require("wezterm")

local HEADER_HOST = { Foreground = { Color = "#75b1a9" }, Text = " " }
local HEADER_CWD = { Foreground = { Color = "#92aac7" }, Text = "" }
local HEADER_DATE = { Foreground = { Color = "#ffccac" }, Text = "󱪺" }
local HEADER_TIME = { Foreground = { Color = "#bcbabe" }, Text = "" }
local HEADER_BATTERY = { Foreground = { Color = "#dfe166" }, Text = " " }
local DEFAULT_FG = { Color = "#9a9eab" }
local DEFAULT_BG = { Color = "rgba(0 0 10 0.8)" }
local SPACE_1 = " "
local SPACE_3 = "   "
local ACTIVE_LEADER = { Foreground = { Color = "#329a32" }, Text = "󱫒" }
local INACTIVE_LEADER = { Foreground = DEFAULT_FG, Text = "󱫓" }

local function AddElement(elems, header, str)
	table.insert(elems, { Foreground = header.Foreground })
	table.insert(elems, { Background = DEFAULT_BG })
	table.insert(elems, { Text = header.Text .. SPACE_1 })

	table.insert(elems, { Foreground = DEFAULT_FG })
	table.insert(elems, { Background = DEFAULT_BG })
	table.insert(elems, { Text = str .. SPACE_3 })
end

local function AddIcon(elems, icon)
	table.insert(elems, { Foreground = icon.Foreground })
	table.insert(elems, { Background = DEFAULT_BG })
	table.insert(elems, { Text = SPACE_1 .. icon.Text .. SPACE_3 })
end

local function GetKeyboard(elems, window)
	AddIcon(elems, window:leader_is_active() and ACTIVE_LEADER or INACTIVE_LEADER)
end

local function GetHostAndCwd(elems, pane)
	local uri = pane:get_current_working_dir()

	if not uri then
		return
	end

	local cwd_uri = uri:sub(8)
	local slash = cwd_uri:find("/")

	if not slash then
		return
	end

	local host = cwd_uri:sub(1, slash - 1)
	local dot = host:find("[.]")

	AddElement(elems, HEADER_HOST, dot and host:sub(1, dot - 1) or host)
	AddElement(elems, HEADER_CWD, cwd_uri:sub(slash))
end

local function GetDate(elems)
	AddElement(elems, HEADER_DATE, wezterm.strftime("%a %b %-d"))
end

local function GetWorkspace(elems, window)
	AddElement(elems, { Foreground = { Color = "#bcbabe" }, Text = "" }, window:active_workspace())
end

local function GetTime(elems)
	AddElement(elems, HEADER_TIME, wezterm.strftime("%H:%M"))
end

local function GetBattery(elems, window)
	if not window:get_dimensions().is_full_screen then
		return
	end

	local battery = wezterm.battery_info()[1]
	local battery_state = battery.state_of_charge
	if battery_state ~= battery_state then
		return
	else
		AddElement(elems, HEADER_BATTERY, string.format("%.0f%%", battery_state * 100))
	end
end

local function LeftUpdate(window, pane)
	local elems = {}
	GetKeyboard(elems, window)
	GetWorkspace(elems, window)
	window:set_left_status(wezterm.format(elems))
end

local function RightUpdate(window, pane)
	local elems = {}
	GetHostAndCwd(elems, pane)
	-- GetDate(elems)
	GetBattery(elems, window)
	GetTime(elems)
	window:set_right_status(wezterm.format(elems))
end

wezterm.on("update-status", function(window, pane)
	LeftUpdate(window, pane)
	RightUpdate(window, pane)
end)
