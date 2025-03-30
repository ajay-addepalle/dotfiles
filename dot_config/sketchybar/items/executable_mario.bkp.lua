#!/usr/bin/env lua
package.cpath = package.cpath .. ";/Users/" .. os.getenv("USER") .. "/.local/share/sketchybar_lua/?.so"
require 'luarocks.loader'

socket = require 'socket'
sbar = require("sketchybar")

-- cleanup
--if type(sbar.query("mario")) == "table" then
--  sbar.remove("mario")
--end
--if type(sbar.query("mushroom")) == "table" then
--  sbar.remove("mushroom")
--end
-- common props
icon_dir = os.getenv("HOME") .. "/.config/sketchybar/imgs"
mario_icon = icon_dir .. "/r_stand_s.png"
mario_width = 28
step_size = 4
animation_duration = 0.05
mario_size = "s"

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
primary_display = get_primary_display()
bar_width = primary_display.frame.w
left_start = 0
right_end = bar_width
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


get_min_max_positions()
--print("Bar full width:", bar_width)
--print(get_min_max_positions())
--print("left bound", left_start)
--print("right_bound", right_end)
start_position = left_start
end_position = right_end - mario_width
--print("start position", start_position)
--print("end position", end_position)

mario = sbar.add("item", "mario", {
  position = "left",
  width = "20",
  y_offset = -16,
  update_freq = 15,
  updates = on,
  background = {
    --color = 0xffa1b56c,
    color = 0x00ffffff,
    --border_color = 0xffa1b56c,
    corner_radius = 0,
    image = {
      string = mario_icon,
      scale = 1,
      border_width = 0,
    },
  },
})

mushroom = sbar.add("item", "mushroom", {
  position = "right",
  width = "8",
  y_offset = -8,
  background = {
    color = 0x00ffffff,
    image = {
      string = icon_dir .. "/mushroom_smw.png",
      scale = 1,
      border_width = 0,
      corner_radius = 0,
    },
  },
})

function reset()
  mario_size = "s"
  mushroom:set({
    background = {
      drawing = true,
    }
  })
  mario:set({
    y_offset = -16,
    background = {
      image = {
        string = mario_icon
      }
    }
  })
end



function run_right()
  --local position = start_position
  local step = false
  local lpad = 0
  local rend = end_position - start_position
  while lpad <= rend do
    if step == false then
      mario:set({
	y_offset = -16,
        background = {
	  image = {
	    string = icon_dir .. "/r_stand_" .. mario_size .. ".png"
	  }
	},
	padding_left = lpad
      })
      socket.sleep(animation_duration) 
--      sbar.exec("sleep 0.5")
      lpad = lpad + step_size
      step = true
    else
      sbar.exec("sleep 1", function(result, exit_code)
        mario:set({
  	  background = {
	    image = {
	      string = icon_dir .. "/r_run_" .. mario_size .. ".png"
	    }
	  },
	  padding_left = lpad
        })
      end)
      socket.sleep(animation_duration)
--      sbar.exec("sleep 0.5")
      lpad = lpad + step_size
      step = false
    end
  end
end

-- Function to transform Mario after getting mushroom
function transformToSuperMario()
  -- Play transformation animation
  mushroom:set({
    background = {
      drawing = false
    }
  })
  for i = 1, 3 do
    mario:set({ background = { drawing = false } })
    socket.sleep(0.2)
    mario:set({ background = { drawing = true } })
    socket.sleep(0.2)
  end
  mario_size = "b"
  -- Transform to big Mario
  mario:set({
    y_offset = -8,
    background = {
      image = {
        string = icon_dir .. "/r_stand_" .. mario_size .. ".png",
      }
    }
  })
end

-- Function to make Mario jump
function jump()
  local is_big = mario_size == 'b'
  local jump_height = is_big and 25 or 15
  local current_pos = is_big and -8 or -16
  for i = 1, 1 do
    mario:set({
      background = {
        image = {
          string = icon_dir .. "/l_jump_" .. mario_size .. ".png"
        }
      }
    })
    for y = current_pos, jump_height, 3 do
      mario:set({ y_offset = y })
      socket.sleep(0.05)
    end

    for y = jump_height, current_pos, -3 do
      mario:set({ y_offset = y })
      socket.sleep(0.05)
    end
    mario:set({
      background = {
        image = {
          string = icon_dir .. "/l_stand_" .. mario_size .. ".png"
        }
      }
    })
    --socket.sleep(0.5)
  end
end

function run_left()
  local step = false
  local lpad = end_position - start_position
  while lpad >= 0 do
    if step == false then
      mario:set({
        background = {
	  image = {
	    string = icon_dir .. "/l_stand_" .. mario_size .. ".png"
	  }
	},
	padding_left = lpad
      })
      socket.sleep(animation_duration)
      lpad = lpad - step_size
      step = true
    else
      mario:set({
	background = {
	  image = {
	    string = icon_dir .. "/l_run_" .. mario_size .. ".png"
	  }
	},
	padding_left = lpad
      })
      socket.sleep(animation_duration)
      lpad = lpad - step_size
      step = false
    end
  end
end

function runlvl()
  run_right()
  transformToSuperMario()
  jump()
  run_left()
  --jump()
  --reset()
end

--mario:subscribe({"forced", "routine", "system_woke"}, function(env)
--	print("run mario on event")
--	runlvl()
--end)
runlvl()

--mario:subscribe("front_app_switched", runlvl)
--socket.sleep(1)
--while true do
--  runlvl()
--  socket.sleep(60)
--end
