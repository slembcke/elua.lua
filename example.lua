local dbg = require("debugger")

dbg.call(function()

local template = require("template")
local chunk = template.loadFile("example.template")

print(chunk())

end)
