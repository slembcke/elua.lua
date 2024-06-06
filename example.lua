local elua = require("elua")

local bottles, err = elua.compile_file("example.elua")
if err then error(err) end

local output = bottles{count = 99}
print(output)
