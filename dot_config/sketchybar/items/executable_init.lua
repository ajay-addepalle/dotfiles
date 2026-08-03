-- From left-most to right
sbar = require("sketchybar")
settings = require("settings")
colors = require("colors")

sbar.exec("killall stats_provider >/dev/null; stats_provider --network en0 --interval 2 --no-units")
require("items.aerospace")
--require("items.aerospace_mode_indicator")
--require("items.front_app")

-- From right-most to left
require("items.calendar")
require("items.widgets")
require("items.media")
require("items.network")
-- require("items.mail")
--require("items.pomodoro_timer")
--require("items.todo")
--require("items.supermario")
--sbar = require("sketchybar")
--print(sbar)
--print(mar.runlvl())
