#!/usr/bin/env lua
package.cpath = package.cpath .. ";/Users/" .. os.getenv("USER") .. "/.local/share/sketchybar_lua/?.so"

require 'luarocks.loader'
local copas = require("copas")
local socket = require("socket")
socket.unix = require("socket.unix")

