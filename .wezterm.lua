local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Mocha"

config.font = wezterm.font("JetBrains Mono", { weight = "Bold" })
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"
config.cursor_blink_rate = 500
config.default_cursor_style = "BlinkingBlock"
config.warn_about_missing_glyphs = true
config.use_fancy_tab_bar = false
config.window_background_opacity = 0.97
config.tab_max_width = 16

return config
