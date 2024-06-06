
-----------

package.path = '/home/slembcke/Development/debugger.lua/?.lua;'..package.path
-- package.path = 'C:\\Users\\slembcke\\Development\\debugger.lua\\?.lua;'..package.path
local dbg = require "debugger"
dbg.auto_where = 2
dbg.call(function()

local elua = require 'elua'

local str = [====[
Let's sing a song!

{{for i = count, 1, -1 do}}
{{= i}} bottles of beer on the wall.
{{= i}} bottles of beer.
Take one down pass it around,
{{= i - 1}} bottles of beer on the wall.

{{end}}
That was fun!
]====]

local bottles, err = elua.compile(str)
print(bottles({count = 2}))

end)
return
