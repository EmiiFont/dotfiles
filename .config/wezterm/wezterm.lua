local wezterm = require("wezterm")
local tab = require("tab")
local theme = require("theme")
local config = wezterm.config_builder()
local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")

resurrect.periodic_save()

local function basename(s)
	return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

config.color_scheme = "OneDark (base16)"

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
		key = "e",
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
		key = "P",
		mods = "LEADER",
		action = wezterm.action.PaneSelect({ mode = "SwapWithActiveKeepFocus" }),
	},
	{
		key = "p",
		mods = "LEADER",
		action = wezterm.action.PaneSelect({}),
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
	{
		key = "g",
		mods = "LEADER",
		action = wezterm.action_callback(function(window, pane)
			window:perform_action(
				wezterm.action.PromptInputLine({
					description = "Enter name for new workspace:",
					action = wezterm.action_callback(function(window, pane, line)
						if line then
							window:perform_action(
								wezterm.action.SwitchToWorkspace({
									name = line,
								}),
								pane
							)
						end
					end),
				}),
				pane
			)
		end),
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
	{ key = "s", mods = "LEADER", action = workspace_switcher.switch_workspace() },
	{
		key = "w",
		mods = "ALT",
		action = wezterm.action_callback(function(win, pane)
			resurrect.save_state(resurrect.workspace_state.get_workspace_state())
		end),
	},
	-- {
	-- 	key = "W",
	-- 	mods = "ALT",
	-- 	action = resurrect.window_state.save_window_action(),
	-- },
	-- {
	-- 	key = "T",
	-- 	mods = "ALT",
	-- 	action = resurrect.tab_state.save_tab_action(),
	-- },
	-- {
	-- 	key = "s",
	-- 	mods = "ALT",
	-- 	action = wezterm.action_callback(function(win, pane)
	-- 		resurrect.save_state(resurrect.workspace_state.get_workspace_state())
	-- 		resurrect.window_state.save_window_action()
	-- 	end),
	-- },
	{
		key = "r",
		mods = "ALT",
		action = wezterm.action_callback(function(win, pane)
			resurrect.fuzzy_load(win, pane, function(id, label)
				local type = string.match(id, "^([^/]+)") -- match before '/'
				id = string.match(id, "([^/]+)$") -- match after '/'
				id = string.match(id, "(.+)%..+$") -- remove file extention
				local opts = {
					relative = true,
					restore_text = true,
					on_pane_restore = resurrect.tab_state.default_on_pane_restore,
				}
				if type == "workspace" then
					local state = resurrect.load_state(id, "workspace")
					resurrect.workspace_state.restore_workspace(state, opts)
				elseif type == "window" then
					local state = resurrect.load_state(id, "window")
					resurrect.window_state.restore_window(pane:window(), state, opts)
				elseif type == "tab" then
					local state = resurrect.load_state(id, "tab")
					resurrect.tab_state.restore_tab(pane:tab(), state, opts)
				end
			end)
		end),
	},
}

workspace_switcher.apply_to_config(config)
workspace_switcher.workspace_formatter = function(label)
	return wezterm.format({
		{ Attribute = { Italic = true } },
		{ Text = "󱂬 : " .. label },
	})
end

wezterm.on("smart_workspace_switcher.workspace_switcher.created", function(window, path, label)
	window:gui_window():set_right_status(wezterm.format({
		{ Attribute = { Intensity = "Bold" } },
		{ Text = basename(path) .. "  " },
	}))
	local workspace_state = resurrect.workspace_state

	workspace_state.restore_workspace(resurrect.load_state(label, "workspace"), {
		window = window,
		relative = true,
		restore_text = true,
		on_pane_restore = resurrect.tab_state.default_on_pane_restore,
	})
end)

wezterm.on("smart_workspace_switcher.workspace_switcher.chosen", function(window, path, label)
	window:gui_window():set_right_status(wezterm.format({
		{ Attribute = { Intensity = "Bold" } },
		{ Text = basename(path) .. "  " },
	}))
end)

wezterm.on("smart_workspace_switcher.workspace_switcher.selected", function(window, path, label)
	local workspace_state = resurrect.workspace_state
	resurrect.save_state(workspace_state.get_workspace_state())
end)

-- theme.setup(config)
tab.setup(config)
return config
