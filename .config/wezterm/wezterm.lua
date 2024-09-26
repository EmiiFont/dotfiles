local wezterm = require("wezterm")
local tab = require("tab")
local theme = require("theme")
local config = wezterm.config_builder()

config.color_scheme = "Gruvbox Dark (Gogh)"

config.font = wezterm.font("JetBrains Mono")
config.underline_thickness = "200%"
config.underline_position = "-3pt"
config.font_size = 15.0
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"
config.cursor_blink_rate = 500
config.default_cursor_style = "BlinkingBlock"
config.warn_about_missing_glyphs = true
config.use_fancy_tab_bar = false
config.window_background_opacity = 0.96
config.tab_max_width = 16
config.window_padding = {
	left = 5,
	right = 5,
	top = 10,
	bottom = 2,
}
config.initial_cols = 110
config.initial_rows = 25
config.window_decorations = "RESIZE"

wezterm.on("toggle-opacity", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	if not overrides.window_background_opacity then
		overrides.window_background_opacity = 0.96
		overrides.text_background_opacity = 0.989
	else
		overrides.window_background_opacity = nil
	end
	window:set_config_overrides(overrides)
end)

config.switch_to_last_active_tab_when_closing_tab = true
config.pane_focus_follows_mouse = true
config.scrollback_lines = 5000

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 2000 }

config.keys = {
	-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
	{
		key = "a",
		mods = "LEADER|CTRL",
		action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }),
	},
	{
		key = "b",
		mods = "LEADER|CTRL",
		action = wezterm.action.EmitEvent("toggle-opacity"),
	},
	{
		key = "t",
		mods = "LEADER",
		action = wezterm.action.ShowTabNavigator,
	},
	{
		key = "f",
		mods = "LEADER",
		action = wezterm.action.TogglePaneZoomState,
	},
	{
		key = "n",
		mods = "LEADER",
		action = wezterm.action.ActivateTabRelative(1),
	},
	{
		key = "p",
		mods = "LEADER",
		action = wezterm.action.ActivateTabRelative(-1),
	},
	-- Vertical split of pane
	{
		-- |
		key = "|",
		mods = "LEADER|SHIFT",
		action = wezterm.action.SplitPane({
			direction = "Right",
			size = { Percent = 50 },
		}),
	},
	-- Horizontal split of pane
	{
		-- -
		key = "-",
		mods = "LEADER",
		action = wezterm.action.SplitPane({
			direction = "Down",
			size = { Percent = 50 },
		}),
	},
	-- close pane
	{
		key = "w",
		mods = "LEADER",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},

	{
		-- |
		key = "{",
		mods = "LEADER|SHIFT",
		action = wezterm.action.PaneSelect({ mode = "SwapWithActiveKeepFocus" }),
	},
	-- move between panes
	{
		key = "h",
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		key = "LeftArrow",
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		key = "j",
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	{
		key = "DownArrow",
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},

	{
		key = "l",
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	{
		key = "RightArrow",
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	{
		key = "k",
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		key = "UpArrow",
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},

	{ key = "g", mods = "LEADER", action = wezterm.action.ShowLauncherArgs({
		flags = "FUZZY|WORKSPACES",
	}) },
}

-- theme.setup(config)
tab.setup(config)
return config
