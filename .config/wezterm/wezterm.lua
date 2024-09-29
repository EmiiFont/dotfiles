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
	-- show tab list useful when you have many tabs, otherwise use index or next/previous tab
	{
		key = "t",
		mods = "LEADER",
		action = wezterm.action.ShowTabNavigator,
	},
	-- zoom pane equivalent to make it fullscreen and back
	{
		key = "f",
		mods = "LEADER",
		action = wezterm.action.TogglePaneZoomState,
	},
	-- next tab
	{
		key = "n",
		mods = "LEADER",
		action = wezterm.action.ActivateTabRelative(1),
	},
	-- previous tab
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
			size = { Percent = 30 },
		}),
	},
	-- Horizontal split of pane
	{
		-- -
		key = "-",
		mods = "LEADER",
		action = wezterm.action.SplitPane({
			direction = "Down",
			size = { Percent = 30 },
		}),
	},
	-- close pane
	{
		key = "w",
		mods = "LEADER",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	-- toggle the swap pane selector to change content with another pane
	{
		-- |
		key = "{",
		mods = "LEADER|SHIFT",
		action = wezterm.action.PaneSelect({ mode = "SwapWithActiveKeepFocus" }),
	},
	-- move between panes
	{
		key = ";",
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Prev"),
	},
	{
		key = "o",
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Next"),
	},
	{ key = "<", mods = "LEADER|SHIFT", action = wezterm.action.MoveTabRelative(-1) },
	{ key = ">", mods = "LEADER|SHIFT", action = wezterm.action.MoveTabRelative(1) },
	{
		key = "t",
		mods = "LEADER",
		action = wezterm.action_callback(function(_, pane)
			local tab = pane:tab()
			local panes = tab:panes_with_info()
			if #panes == 1 then
				pane:split({
					direction = "Right",
					size = 0.4,
				})
			elseif not panes[1].is_zoomed then
				panes[1].pane:activate()
				tab:set_zoomed(true)
			elseif panes[1].is_zoomed then
				tab:set_zoomed(false)
				panes[2].pane:activate()
			end
		end),
	},
	-- list WORKSPACES
	{ key = "g", mods = "LEADER", action = wezterm.action.ShowLauncherArgs({
		flags = "FUZZY|WORKSPACES",
	}) },
}

-- theme.setup(config)
tab.setup(config)
return config
