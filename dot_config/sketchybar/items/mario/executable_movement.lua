#!/usr/bin/env lua
package.cpath = package.cpath .. ";/Users/" .. os.getenv("USER") .. "/.local/share/sketchybar_lua/?.so"
require 'luarocks.loader'

local socket = require 'socket'
local sbar = require("sketchybar")

-- common props
local icon_dir = os.getenv("HOME") .. "/.config/sketchybar/imgs"
local mario_icon = icon_dir .. "/r_stand.png"
local mario_width = 28
local step_size = 5
local animation_duration = 0.08
-- get display props
function get_primary_display()
  local displays = sbar.query('displays')
  if displays[0] ~= nil then
    return displays[0]
  else
    return displays[1]
  end
end
-- calc display boundaries
local primary_display = get_primary_display()
local bar_width = primary_display.frame.w
local left_start = 0
local right_end = bar_width
-- 
function get_min_max_positions()
  local items = sbar.query('bar').items
  for k,v in ipairs(items) do
   local item = sbar.query(v)
    if item.geometry.position == "left" then
      --print("left item", item.name, item.geometry.position)
      lbound = item.bounding_rects['display-1'].origin[1] + item.bounding_rects['display-1'].size[1]
      if left_start < lbound then
	left_start = lbound
      end
      --print(item.bounding_rects['display-1'].origin[1])
    else
      rbound = item.bounding_rects['display-1'].origin[1]
      if rbound ~= -9999 and right_end > rbound then
	right_end = rbound
      end
      --print("right item", item.name, item.geometry.position)
    end
  end
end


print("Bar full width:", bar_width)
print(get_min_max_positions())
print("left bound", left_start)
print("right_bound", right_end)
start_position = left_start
end_position = right_end - mario_width
print("start position", start_position)
print("end position", end_position)

local mario = sbar.add("item", "mario", {
  position = "left",
  width = "dynamic",
  y_offset = -15,
  background = {
    --color = 0xffa1b56c,
    --color = 0xffffffff,
    --border_color = 0xffa1b56c,
    image = {
      string = mario_icon,
      scale = 1,
      border_width = 0,
    },
  },
})

function run_right()
  --local position = start_position
--  sbar.animate("tanh", 300, function()
--	    mario:set({
--              padding_left = end_position - start_position 
--	    })
--            end
--  )
  local step = false
  local lpad = 0
  local rend = end_position - start_position
  while lpad <= rend do
    if step == false then
      sbar.animate("tanh", 50, 
        function()
	  mario:set({
	    background = {
	      image = {
	        string = icon_dir .. "/r_stand.png"
	      } 
	    },
	    padding_left = lpad
	  })
	end
      )
--      mario:set({
--	background = {
--	  image = {
--	    string = icon_dir .. "/r_stand.png"
--	  }
--	},
--	padding_left = lpad
--     })
      --socket.sleep(0.1)
      lpad = lpad + 2
      step = true

    else
      sbar.animate("tanh", 100, 
        function()
	  mario:set({
	    background = {
	      image = {
	        string = icon_dir .. "/r_run.png"
	      } 
	    },
	    padding_left = lpad
	  })
	end
      )
--      mario:set({
--	background = {
--	  image = {
--	    string = icon_dir .. "/r_run.png"
--	  }
--	},
--	padding_left = lpad
 --     })
      --socket.sleep(0.15)
      lpad = lpad + 4
      step = false
    end
    lpad = lpad + step_size
    socket.sleep(animation_duration)
    --break
  end
end

function run_left()
  local lpad = end_position
  while lpad >= start_position do
    mario:set({padding_left = lpad})
    lpad = lpad - step_size
    socket.sleep(anitmation_duration)
  end
end

run_right()
--socket.sleep(1)
--run_left()

--mario:set({
--  padding_left = 0
--})


