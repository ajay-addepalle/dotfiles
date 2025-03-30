#!/usr/bin/env lua
package.cpath = package.cpath .. ";/Users/" .. os.getenv("USER") .. "/.local/share/sketchybar_lua/?.so"
require 'luarocks.loader'

local socket = require("socket")
local sbar = require("sketchybar")

-- get display props
function get_primary_display()
  local displays = sbar.query('displays')
  if displays[0] ~= nil then
    return displays[0]
  else
    return displays[1]
  end
end
-- get the left and right start and ending position
function get_min_max_positions()
  local items = sbar.query('bar').items
  local primary_display = get_primary_display()
  local bar_width = primary_display.frame.w
  local left_start = 0
  local right_end = bar_width
  for k,v in ipairs(items) do
   local item = sbar.query(v)
    if item.geometry.position == "left" then
      lbound = item.bounding_rects['display-1'].origin[1] + item.bounding_rects['display-1'].size[1]
      if left_start < lbound then
	left_start = lbound
      end
    elseif item.geometry.position == "right" then
      rbound = item.bounding_rects['display-1'].origin[1]
      if rbound ~= -9999 and right_end > rbound then
	right_end = rbound
      end
    end
  end
  return left_start, right_end
end

