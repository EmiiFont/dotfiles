local wezterm = require("wezterm")
local tab = require("tab")
local theme = require("theme")
local config = wezterm.config_builder()

config.color_scheme = "Tokyo Night"

config.font = wezterm.font("JetBrains Mono")
config.underline_thickness = "200%"
config.underline_position = "-3pt"
config.font_size = 14.0
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
	bottom = 4,
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

config.keys = {
	{
		key = "B",
		mods = "CTRL",
		action = wezterm.action.EmitEvent("toggle-opacity"),
	},
}
theme.setup(config)
tab.setup(config)
return config
