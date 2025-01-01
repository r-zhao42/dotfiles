local colors = require("colors")
local app_icons = require("helpers.app_icons")
local front_app = sbar.add("item", {
	icon = {
		string = ":wezterm:",
		font = "sketchybar-app-font:Regular:16.0",
	},
})

front_app:subscribe("front_app_switched", function(env)
	front_app:set({
		icon = {
			string = app_icons[env.INFO],
			font = "sketchybar-app-font:Regular:20.0",
			color = colors.magenta,
		},
	})

	-- Or equivalently:
	-- sbar.set(env.NAME, {
	--   label = {
	--     string = env.INFO
	--   }
	-- })
end)
