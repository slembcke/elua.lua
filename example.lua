local dbg = require("debugger")

dbg.call(function()

local template = require("elua")
local chunk = template.loadFile("example.elua")

print(chunk{foo = "bar"})

end)
