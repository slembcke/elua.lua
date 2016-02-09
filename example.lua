local template = require("elua")
--local dbg = require("debugger")
--dbg.call(function()

--local file = io.open("example.elua", "r")
--print(template.compile(file:read("a")))

local chunk, err = template.loadFile("example.elua")
if err then error(err) end

local output = chunk{count = 99}
print(output)

--end)
