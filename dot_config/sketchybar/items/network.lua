local icons = require("icons")
local sbar = require("sketchybar")
local colors = require("colors")

local download_speed = sbar.add("item", "widgets.download_speed", {
	position = "right",
	padding_left = -12,
	icon = {
		padding_right = 0,
		font = { size = 9 },
		string = icons.wifi.download,
	},
	label = {
		font = { size = 9 },
		color = colors.grey,
		string = "??? KB/s",
	},
})

local upload_speed = sbar.add("item", "widgets.upload_speed", {
	position = "right",
	padding_left = -12,
	width = 0,
	icon = {
		padding_right = 0,
		font = { size = 9 },
		string = icons.wifi.upload,
	},
	label = {
		font = { size = 9 },
		color = colors.grey,
		string = "??? KB/s",
	},
})

local function format_speed(speed_str)
	local speed = tonumber(speed_str)
	if speed < 1024 then
		return string.format("%d KB/s", speed)
	elseif speed < 1024 * 1024 then
		return string.format("%.1f MB/s", speed / 1024)
	else
		return string.format("%.1f GB/s", speed / (1024 * 1024))
	end
end

upload_speed:subscribe("system_stats", function(env)
	local up_color = (env.NETWORK_TX_en0 == "0") and colors.grey or colors.green
	local down_color = (env.NETWORK_RX_en0 == "0") and colors.grey or colors.green

	local tx = format_speed(env.NETWORK_TX_en0)
	local rx = format_speed(env.NETWORK_RX_en0)
	-- make tx, rx string length equal for better alignment
	if #tx < #rx then
		tx = string.rep("0", #rx - #tx) .. tx
	elseif #rx < #tx then
		rx = string.rep("0", #tx - #rx) .. rx
	end

	upload_speed:set({
		icon = { color = up_color },
		label = { string = tx, color = up_color },
	})
	download_speed:set({
		icon = { color = down_color },
		label = { string = rx, color = down_color },
	})
end)
