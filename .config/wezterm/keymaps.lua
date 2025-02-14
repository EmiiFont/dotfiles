local wezterm = require("wezterm")
local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")

local Keymaps = {}

local act = wezterm.action

local pane_resize = 5

function Keymaps.setup(config)
	config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 2000 }
	config.keys = {
		-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
		{
			key = "a",
			mods = "LEADER|CTRL",
			action = act.SendKey({ key = "a", mods = "CTRL" }),
		},
		{
			key = "b",
			mods = "LEADER|CTRL",
			action = act.EmitEvent("toggle-opacity"),
		},
		-- show tab list useful when you have many tabs, otherwise use index or next/previous tab
		{
			key = "e",
			mods = "LEADER",
			action = act.ShowTabNavigator,
		},
		-- zoom pane equivalent to make it fullscreen and back
		{
			key = "f",
			mods = "LEADER",
			action = act.TogglePaneZoomState,
		},
		-- next tab
		{
			key = "n",
			mods = "LEADER",
			action = act.ActivateTabRelative(1),
		},
		-- previous tab
		{
			key = "p",
			mods = "LEADER",
			action = act.ActivateTabRelative(-1),
		},
		-- Vertical split of pane
		{
			-- |
			key = "|",
			mods = "LEADER",
			action = act.SplitPane({
				direction = "Right",
				size = { Percent = 50 },
			}),
		},
		-- Horizontal split of pane
		{
			-- -
			key = "-",
			mods = "LEADER",
			action = act.SplitPane({
				direction = "Down",
				size = { Percent = 30 },
			}),
		},
		-- close pane
		{
			key = "w",
			mods = "LEADER",
			action = act.CloseCurrentPane({ confirm = true }),
		},
		-- toggle the swap pane selector to change content with another pane
		{
			-- |
			key = "P",
			mods = "LEADER",
			action = act.PaneSelect({ mode = "SwapWithActiveKeepFocus" }),
		},
		{
			key = "p",
			mods = "LEADER",
			action = act.PaneSelect({}),
		},

		-- move between panes
		{
			key = ";",
			mods = "LEADER",
			action = act.ActivatePaneDirection("Prev"),
		},
		{
			key = "o",
			mods = "LEADER",
			action = act.ActivatePaneDirection("Next"),
		},
		{
			key = "h",
			mods = "LEADER",
			action = act.ActivatePaneDirection("Left"),
		},
		{
			key = "LeftArrow",
			mods = "LEADER",
			action = act.ActivatePaneDirection("Left"),
		},
		{
			key = "j",
			mods = "LEADER",
			action = act.ActivatePaneDirection("Down"),
		},
		{
			key = "DownArrow",
			mods = "LEADER",
			action = act.ActivatePaneDirection("Down"),
		},

		{
			key = "l",
			mods = "LEADER",
			action = act.ActivatePaneDirection("Right"),
		},
		{
			key = "RightArrow",
			mods = "LEADER",
			action = act.ActivatePaneDirection("Right"),
		},
		{
			key = "k",
			mods = "LEADER",
			action = act.ActivatePaneDirection("Up"),
		},
		{
			key = "UpArrow",
			mods = "LEADER",
			action = act.ActivatePaneDirection("Up"),
		},
		-- Resizing Panes
		-- {
		-- 	key = "h",
		-- 	mods = "LEADER|SHIFT",
		-- 	action = wezterm.Multiple({
		-- 		wezterm.AdjustPaneSize({ "Left", pane_resize }),
		-- 		wezterm.ActivateKeyTable({ name = "resize_pane", one_shot = false, until_unknown = true }),
		-- 	}),
		-- },
		{ key = "J", mods = "CTRL", action = act.AdjustPaneSize({ "Down", pane_resize }) },
		{ key = "K", mods = "CTRL", action = act.AdjustPaneSize({ "Up", pane_resize }) },
		{ key = "H", mods = "CTRL", action = act.AdjustPaneSize({ "Left", pane_resize }) },
		{ key = "L", mods = "CTRL", action = act.AdjustPaneSize({ "Right", pane_resize }) },
		{
			key = "g",
			mods = "LEADER",
			action = wezterm.action_callback(function(window, pane)
				window:perform_action(
					act.PromptInputLine({
						description = "Enter name for new workspace:",
						action = wezterm.action_callback(function(window, pane, line)
							if line then
								window:perform_action(
									act.SwitchToWorkspace({
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
		{ key = "<", mods = "LEADER|SHIFT", action = act.MoveTabRelative(-1) },
		{ key = ">", mods = "LEADER|SHIFT", action = act.MoveTabRelative(1) },
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
		-- rename workspace
		{ key = "R", mods = "LEADER", action = wezterm.action.EmitEvent("rename-workspace") },
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
		{
			key = "d",
			mods = "ALT",
			action = wezterm.action_callback(function(win, pane)
				resurrect.fuzzy_load(win, pane, function(id)
					resurrect.delete_state(id)
				end, {
					title = "Delete State",
					description = "Select State to Delete and press Enter = accept, Esc = cancel, / = filter",
					fuzzy_description = "Search State to Delete: ",
					is_fuzzy = true,
				})
			end),
		},
	}
end
return Keymaps
