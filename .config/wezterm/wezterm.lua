local wezterm = require("wezterm")
local tab = require("tab")
local theme = require("theme")
local config = wezterm.config_builder()
local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
local wpr = wezterm.plugin.require("https://github.com/vieitesss/workspacesionizer.wezterm")

local keymaps = require("keymaps")

-- resurrect.periodic_save()

local function basename(s)
	return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

config.color_scheme = "Catppuccin Mocha"

config.max_fps = 120
config.animation_fps = 120
config.status_update_interval = 500
config.font = wezterm.font("JetBrains Mono")
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
config.underline_thickness = "200%"
config.underline_position = "-3pt"
config.font_size = 13.0
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"
config.cursor_blink_rate = 500
config.default_cursor_style = "BlinkingBlock"
config.warn_about_missing_glyphs = true
config.use_fancy_tab_bar = false
config.tab_max_width = 16
config.window_padding = {
	left = 5,
	right = 5,
	top = 10,
	bottom = 2,
}
config.initial_cols = 110
config.initial_rows = 25
config.window_decorations = "TITLE | RESIZE"
config.switch_to_last_active_tab_when_closing_tab = true
config.pane_focus_follows_mouse = true
config.scrollback_lines = 5000
config.inactive_pane_hsb = {
	hue = 1.0,
	saturation = 1.0,
	brightness = 0.5,
}

wezterm.on("rename-workspace", function(window, pane)
	local mux = wezterm.mux
	local current_workspace = mux.get_active_workspace()

	window:perform_action(
		wezterm.action.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Enter new workspace name:" },
			}),
			action = wezterm.action_callback(function(window, pane, new_name)
				if new_name and new_name ~= "" then
					mux.rename_workspace(current_workspace, new_name)
				end
			end),
		}),
		pane
	)
end)

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

keymaps.setup(config)

-- local act = wezterm.action
-- config.key_tables.resize_pane = {
-- 	-- { key = "h", mods = "SHIFT", action = act.AdjustPaneSize({ "Left", pane_resize }) },
-- 	{ key = "j", mods = "SHIFT", action = act.AdjustPaneSize({ "Down", pane_resize }) },
-- 	-- { key = "k", mods = "SHIFT", action = act.AdjustPaneSize({ "Up", pane_resize }) },
-- 	-- { key = "l", mods = "SHIFT", action = act.AdjustPaneSize({ "Right", pane_resize }) },
-- 	{ key = "Escape", action = act.PopKeyTable },
-- }

workspace_switcher.apply_to_config(config)
workspace_switcher.workspace_formatter = function(label)
	return wezterm.format({
		{ Attribute = { Italic = true } },
		{ Foreground = { AnsiColor = "Fuchsia" } },
		{ Text = "󱂬 : " .. label },
	})
end

-- wezterm.on("smart_workspace_switcher.workspace_switcher.created", function(window, path, label)
-- 	window:gui_window():set_right_status(wezterm.format({
-- 		{ Attribute = { Intensity = "Bold" } },
-- 		{ Text = basename(path) .. "  " },
-- 	}))
-- 	local workspace_state = resurrect.workspace_state
--
-- 	workspace_state.restore_workspace(resurrect.load_state(label, "workspace"), {
-- 		window = window,
-- 		relative = true,
-- 		restore_text = true,
-- 		on_pane_restore = resurrect.tab_state.default_on_pane_restore,
-- 	})
-- end)

wezterm.on("smart_workspace_switcher.workspace_switcher.chosen", function(window, path, label)
	window:gui_window():set_right_status(wezterm.format({
		{ Attribute = { Intensity = "Bold" } },

		{ Text = basename(path) .. "  " },
	}))
end)

-- wezterm.on("smart_workspace_switcher.workspace_switcher.selected", function(window, path, label)
-- 	local workspace_state = resurrect.workspace_state
-- 	resurrect.save_state(workspace_state.get_workspace_state())
-- end)

-- -- Show which key table is active in the status area
-- wezterm.on("update-right-status", function(window, pane)
-- 	local name = window:active_key_table()
-- 	if name then
-- 		name = "TABLE: " .. name
-- 	end
-- 	window:set_right_status(name or "")
-- end)

-- theme.setup(config)

-- tab.setup(config)
local wez = wezterm
bar.apply_to_config(config, {
	position = "bottom",
	max_width = 32,
	padding = {
		left = 1,
		right = 1,
	},
	separator = {
		space = 1,
		left_icon = wez.nerdfonts.fa_long_arrow_right,
		right_icon = wez.nerdfonts.fa_long_arrow_left,
		field_icon = wez.nerdfonts.indent_line,
	},
	modules = {
		tabs = {
			active_tab_fg = 4,
			inactive_tab_fg = 6,
		},
		workspace = {
			enabled = true,
			icon = wez.nerdfonts.cod_window,
			color = 8,
		},
		leader = {
			enabled = true,
			icon = wez.nerdfonts.oct_rocket,
			color = 2,
		},
		pane = {
			enabled = false,
			icon = wez.nerdfonts.cod_multiple_windows,
			color = 7,
		},
		username = {
			enabled = false,
			icon = wez.nerdfonts.fa_user,
			color = 6,
		},
		clock = {
			enabled = true,
			icon = wez.nerdfonts.md_calendar_clock,
			color = 5,
		},
		cwd = {
			enabled = true,
			icon = wez.nerdfonts.oct_file_directory,
			color = 7,
		},
		spotify = {
			enabled = false,
			icon = wez.nerdfonts.fa_spotify,
			color = 3,
			max_width = 64,
			throttle = 15,
		},
	},
})

wpr.apply_to_config(config, {
	paths = { "~/.config", "~/Developer/Github/" },
	git_repos = false,
	show = "base",
	binding = {
		key = "o",
		mods = "LEADER",
	},
})

return config
