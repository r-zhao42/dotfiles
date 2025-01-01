local whitelist = { ["Spotify"] = true, ["Music"] = true }

local media = sbar.add("item", {
	icon = { drawing = false },
	position = "e",
	updates = true,
})

media:subscribe("media_change", function(env)
	if whitelist[env.INFO.app] then
		media:set({
			drawing = (env.INFO.state == "playing") and true or false,
			label = env.INFO.artist .. ": " .. env.INFO.title,
		})
	end
end)
