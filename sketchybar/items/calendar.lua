local cal = sbar.add("item", {
	icon = {
		padding_right = 0,
		font = {
			style = "Black",
			size = 12.0,
		},
	},
	label = {
		width = 70,
		align = "right",
	},
	position = "right",
	update_freq = 15,
})

local function update()
	local date = os.date("%a. %d %b.")
	local time = os.date("%I:%M %p")
	cal:set({ icon = date, label = time })
end

cal:subscribe("routine", update)
cal:subscribe("forced", update)
