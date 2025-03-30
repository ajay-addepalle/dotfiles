#!/usr/bin/env lua

package.cpath = package.cpath .. ";/Users/" .. os.getenv("USER") .. "/.local/share/sketchybar_lua/?.so"
require 'luarocks.loader'

socket = require 'socket'

for key,value in pairs(socket) do
    print("found member " .. key);
end


co = coroutine.create(function ()
           print("hi")
         end)


print(co)
print(coroutine.status(co))
coroutine.resume(co)
print(coroutine.status(co))

co = coroutine.create(function ()
           for i=1,4 do
             print("co", i)
             coroutine.yield()
           end
         end)

coroutine.resume(co)  
print(coroutine.status(co))
coroutine.resume(co)
print(coroutine.status(co))
coroutine.resume(co)
print(coroutine.status(co))
coroutine.resume(co)
print(coroutine.status(co))
coroutine.resume(co)
print(coroutine.status(co))
