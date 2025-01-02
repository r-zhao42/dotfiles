local colors = require("colors")
local app_icons = require("helpers.app_icons")
local table = require("table")

local LIST_ALL = 'aerospace list-windows --all --format "%{app-name} %{workspace} %{monitor-id} %{window-title}" --json'
local function parse_data(window_result)
	local spaces = {}
	for _, entry in ipairs(window_result) do
		local space_name = entry.workspace
		local monitor_id = entry["monitor-id"]
		local app = entry["app-name"]
		local title = entry["window-title"]
		if spaces[space_name] ~= nil then
			table.insert(spaces[space_name].windows, { name = app, title = title })
		else
			spaces[space_name] = { monitor = monitor_id, windows = { { name = app, title = title } } }
		end
	end
	return spaces
end

local function add_workspace(workspace, display)
	local space = sbar.add("item", "space." .. workspace, {
		icon = {
			string = workspace,
			color = colors.white,
			highlight_color = colors.magenta,
		},
		label = { drawing = false },
		-- don't really have a good way of getting the total number of monitors. For now assume secondary monitor is the left monitor and main monitor is the right monitor and there are only a total of 2 monitors
		display = 3 - display,
		background = { color = colors.bg1 },
	})
	-- add the events
	space:subscribe("aerospace_workspace_change", function(env)
		local selected = env.FOCUSED_WORKSPACE == workspace
		space:set({
			icon = { highlight = selected },
			label = { highlight = selected },
		})
	end)

	space:subscribe("mouse.clicked", function()
		sbar.exec("aerospace workspace " .. workspace)
	end)
	return space
end

local function add_window(display, workspace, app, title)
	local window = sbar.add("item", workspace .. "." .. app .. "." .. title, {
		display = 3 - display,
		icon = {
			string = app_icons[app],
			font = "sketchybar-app-font:Regular:16.0",
			highlight_color = colors.magenta,
			--		color = colors.magenta,
		},
		label = {
			color = colors.magenta,
			font = {
				style = "Black",
				size = 14.0,
			},
		},
	})
	window:subscribe("aerospace_workspace_change", function(env)
		local selected = env.FOCUSED_WORKSPACE == workspace
		window:set({
			icon = { highlight = selected },
			label = { highlight = selected },
		})
	end)
	return window
end

local function draw_spaces()
	sbar.exec(LIST_ALL, function(window_result)
		local spaces = parse_data(window_result)
		-- First parse the information
		-- make spaces table into sketchybar items
		for workspace, info in pairs(spaces) do
			local space_items = {}
			local display = info.monitor

			-- First add the space indicators for current space
			local space = add_workspace(workspace, display)
			table.insert(space_items, space.name)

			-- add app icons for windows in this space
			for _, app in ipairs(info.windows) do
				local name = app.name
				local title = app.title
				local window = add_window(display, workspace, name, title)
				table.insert(space_items, window.name)
			end

			-- Group space icon and app icons for that space into the same bracket
			sbar.add("bracket", space_items, {
				background = { color = colors.bg1, border_color = colors.bg2 },
			})
			sbar.add("item", "spacing.padding." .. workspace, {
				width = 10,
				display = 3 - display,
			})
		end
	end)
end

draw_spaces()
local space_window_observer = sbar.add("item", {
	drawing = false,
	updates = true,
})
--
-- space_window_observer:subscribe("space_windows_change", function()
-- 	draw_spaces()
-- end)
--

--space_window_observer:subscribe("aerospace_workspace_change", draw_spaces())
