local copas = require("copas")

copas(function()
   copas.timer.new({
     delay = 1,                        -- delay in seconds
     recurring = true,                 -- make the timer repeat
     params = "hello world1",
     callback = function(timer_obj, params)
       print(params)                   -- prints "hello world"
       timer_obj:cancel()              -- cancel the timer after 1 occurence
     end
   })
end)

print('1st task')

copas(function()
   copas.timer.new({
     delay = 1,                        -- delay in seconds
     recurring = true,                 -- make the timer repeat
     params = "hello world11",
     callback = function(timer_obj, params)
       print(params)                   -- prints "hello world"
       timer_obj:cancel()              -- cancel the timer after 1 occurence
     end
   })
end)
print('2nd task')

copas(function()
   copas.timer.new({
     delay = 1,                        -- delay in seconds
     recurring = true,                 -- make the timer repeat
     params = "hello world111",
     callback = function(timer_obj, params)
       print(params)                   -- prints "hello world"
       timer_obj:cancel()              -- cancel the timer after 1 occurence
     end
   })
end)

print('3rd task')

copas(function()
   copas.timer.new({
     delay = 1,                        -- delay in seconds
     recurring = true,                 -- make the timer repeat
     params = "hello world1111",
     callback = function(timer_obj, params)
       print(params)                   -- prints "hello world"
       timer_obj:cancel()              -- cancel the timer after 1 occurence
     end
   })
end)

print('4th task')

copas(function()
   copas.timer.new({
     delay = 3,                        -- delay in seconds
     recurring = true,                 -- make the timer repeat
     params = "hello world3",
     callback = function(timer_obj, params)
       print(params)                   -- prints "hello world"
       timer_obj:cancel()              -- cancel the timer after 1 occurence
     end
   })
end)

