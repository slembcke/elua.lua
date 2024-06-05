package.path = 'C:\\Users\\slembcke\\Development\\debugger.lua\\?.lua;'..package.path
dbg = require "debugger"
dbg.call(function()

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

local expected = [==[
local __elua, _ENV = ...
__elua("Let's sing a song!")
__elua("")
for i = count, 1, -1 do
__elua(i, " bottles of beer on the wall.")
__elua(i, " bottles of beer.")
__elua("Take one down pass it around,")
__elua(i - 1, " bottles of beer on the wall.")
__elua("")
end
__elua("That was fun!")
]==]

local append, join = table.insert, table.concat
local function appender(lines)
	return lines, function(...) append(lines, join{...}) end
end

function compile(template_code)
	-- compile the template's lua code
	local chunk, err = load(template_code, "COMPILED TEMPLATE", "t")
	if err then return nil, err end
	
	-- wrap chunk in closure to collect and join it's output lines
	return function(env)
		local lines, append = appender{}
		chunk(append, env)
		return join(lines, "\n")
	end
end
-- local bottles = compile(expected)
-- print(bottles({count = 10}))

local codelines, codeline = appender{"local __elua, _ENV = ..."}
-- for line in str:gmatch("[^\n]*") do
-- 	print("line: "..line)
-- 	for foo in line:gmatch("{{=(.-)}}|.-") do
-- 		print(foo)
-- 	end
-- 	-- codeline("__elua ", string.format("%q", line))
-- end
-- print(join(codelines, "\n"))

-- local bottles = compile(join(codelines))
-- print(bottles{i = 99, count = 10})

local cursor = 1
while true do
	local m
	if m = str:match("^{{=.-}}", cursor) then
		dbg.pp("inline", m)
	elseif m = str:match("^
	
	end
end

end)
return
