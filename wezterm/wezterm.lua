-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()
local act = wezterm.action
-- This is where you actually apply your config choices
config.tab_bar_at_bottom = true
-- For example, changing the color scheme:
config.color_scheme = "Tokyo Night"
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.use_dead_keys = false
config.window_background_opacity = 0.95
config.text_background_opacity = 0.95

-- Font shaping
-- config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
-- and finally, return the configuration to wezterm
config.set_environment_variables = {
	-- prepend the path to your utility and include the rest of the PATH
	PATH = "/opt/homebrew/bin:" .. "/usr/local/bin/:" .. "/Users/ryanzhao/go/bin:" .. os.getenv("PATH"),
}

-- Key mappings
config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	{
		key = "w",
		mods = "CMD",
		action = act.CloseCurrentPane({ confirm = true }),
	},
	{
		key = "?",
		mods = "LEADER|SHIFT",
		action = act.SplitPane({
			direction = "Right",
			command = {
				args = {
					"wcht.sh",
				},
			},
			size = { Percent = 40 },
		}),
	},
	-- Pane navigation
	{
		key = "h",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "j",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Down"),
	},
	{
		key = "k",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "l",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Right"),
	},
	-- Pane splitting
	{
		key = "=",
		mods = "LEADER",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "-",
		mods = "LEADER",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "a",
		mods = "LEADER|CTRL",
		action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }),
	},
}
return config
